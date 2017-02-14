#!/usr/bin/env ruby
# sum(
#   (C1/D1)*DAY(
#     INDIRECT( 
#       ADDRESS( ROW() , 1 ) 
#     )
#   )
#   -
#   SUM(B2:INDIRECT( 
#     ADDRESS( ROW( ) , 2 ) 
#   ))
# )

## Sum
## => total_points / num_days_in_month
## => * current day
## - Sum
## => num points total so far

## Num points per day: 28 / 100 = 2.8 ( 3 )
## 2.8 * 13 = 36.4
## 36.4 - 22 = 14 

## num_points_so_far = 22
## num_points_left = 100 - 22
## num_days_left = 16
## num_points_per_day = 78 / 16 = 4.875
require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'

require 'time'
require 'logger'
require 'fileutils'

Log = Logger.new(STDOUT)

FLUSH_CACHE = true
UPDATE_REPORT = true
UPDATE_MONTH_CELL = false

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
APPLICATION_NAME = 'Google Sheets API Ruby Quickstart'
CLIENT_SECRETS_PATH = 'client_secret.json'
CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
                             "sheets.googleapis.com-ruby-quickstart.yaml")
SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS

##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization. If authorization is required,
# the user's default browser will be launched to approve the request.
#
# @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
def authorize
  FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

  client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
  token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
  authorizer = Google::Auth::UserAuthorizer.new(
    client_id, SCOPE, token_store)
  user_id = 'default'
  credentials = authorizer.get_credentials(user_id)
  if credentials.nil?
    url = authorizer.get_authorization_url(
      base_url: OOB_URI)
    puts "Open the following URL in the browser and enter the " +
         "resulting code after authorization"
    puts url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: code, base_url: OOB_URI)
  end
  credentials
end

# Initialize the API
service = Google::Apis::SheetsV4::SheetsService.new
service.client_options.application_name = APPLICATION_NAME
service.authorization = authorize

spreadsheet_id = '1z6wdhMUnyKbX6ld1Qmhfh89Xncf74CW33donnQXhRm0'

current_time = Time.new
this_month = current_time.month
num_days_this_month = Date.new(current_time.year, current_time.month, -1).mday
Log.debug("This month: %s (%i)" % [this_month, num_days_this_month])
progress_report = {}

num_days_this_month.times do |i|
  progress_report[i+1] = {}
end


if FLUSH_CACHE
  Log.debug("Getting from source.")
  read_range = 'Form Responses 1!A2:E'
  response = service.get_spreadsheet_values(spreadsheet_id, read_range)
  puts 'No data found.' if response.values.empty?
  data = response.values
  #pp data.to_json
  
  File.open("/tmp/data.json", "w") do |f|
    f.puts( data.to_json )
  end

else
  data = JSON::parse(File.read("/tmp/data.json"))

end

num_points_so_far = 0.0

data.each do |row|
  ts = Time.strptime( row[0], "%m/%d/%Y %T" )
  activity = row[1]
  effort = row[2].to_i
  notes = row[3]
  points = row[4].to_i

  Log.debug("%s - %s - %s" % [ts, points, activity])
  
  progress_report[ts.day][:points] = 0 if !progress_report[ts.day].has_key?( :points )
  progress_report[ts.day][:points] += points
  num_points_so_far += points
end

batch = Google::Apis::SheetsV4::BatchUpdateValuesRequest.new()
value_data = []

monthly_goal = 100.0
num_days_left = num_days_this_month.to_f - current_time.mday.to_f
average_goal_per_day = (monthly_goal - num_points_so_far) / num_days_left
Log.debug("Average goal: %.2f" % average_goal_per_day)

for day_number, row in progress_report
  write_range = "100 points!A%i" % (day_number+1)
  values = Google::Apis::SheetsV4::ValueRange.new()
  date_str = "%s/%s/%s" % [this_month, day_number, current_time.year]
  
  if day_number >= current_time.mday
    values.update!( :range => write_range, :values => [ [ date_str, row[:points], average_goal_per_day ] ])
  else
    values.update!( :range => write_range, :values => [ [ date_str, row[:points] ] ])
  end

  value_data.push(values)
  #response = service.update_spreadsheet_value(spreadsheet_id, write_range, values, value_input_option: "RAW")
end

if UPDATE_REPORT
  Log.debug("Updating sheet...")
  batch.update!( data: value_data, value_input_option: "RAW" )
  response = service.batch_update_values( spreadsheet_id, batch )
end

if UPDATE_MONTH_CELL
  values = Google::Apis::SheetsV4::ValueRange.new()
  write_range = "100 points!D1"
  values.update!( :values => [ [ num_days_this_month ] ])
  response = service.update_spreadsheet_value(spreadsheet_id, write_range, values, value_input_option: "RAW")
end

Log.info("Complete")