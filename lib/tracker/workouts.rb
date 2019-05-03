module Tracker
  module Workout
    class SheetService
      def initialize
        @config = load_config
        setup_time

        @service = ::Google::Apis::SheetsV4::SheetsService.new
        @service.client_options.application_name = @config['application_name']
        @service.authorization = Tracker::Google::Auth.authorize(@config['google_sheets'])
      end

      def load_config
        YAML.safe_load(File.read(File.join('conf', 'tracker.yaml')))
      end

      def get_all_accounts
        @config['accounts']
      end

      def setup_time
        @current_time = Time.new
        # @current_time = Time.new(2019, 4, 1)

        @this_month = @current_time.month
        @num_days_this_month = Date.new(@current_time.year, @current_time.month, -1).mday
        LOG.debug(format('This month: %s (%i)', @this_month, @num_days_this_month))
      end

      def update_account(account)
        progress_report = {}

        @num_days_this_month.times do |i|
          progress_report[i+1] = {}
        end

        data = get_data(account['name'], account['doc_id'])

        num_points_so_far = 0.0

        data.each do |row|
          ts = Time.strptime( row[0], "%m/%d/%Y %T" )
          next if ts.month != @this_month
          activity = row[1]
          points = row[3].to_i
          fractional = row[4].to_f

          points *= -1 if activity == 'Bad habit'

          total_points = points + fractional

          LOG.debug(format('%s - %s - %s', ts, total_points, activity))

          progress_report[ts.day][:points] = 0 unless progress_report[ts.day].has_key?( :points )
          progress_report[ts.day][:points] += total_points
          num_points_so_far += total_points
        end

        batch = ::Google::Apis::SheetsV4::BatchUpdateValuesRequest.new
        value_data = []

        num_days_left = @num_days_this_month.to_f - (@current_time.mday.to_f - 1)
        num_days_left += 1 if num_days_left == 0
        LOG.debug('NumDaysLeft: %s (%i - %i)' % [num_days_left, @num_days_this_month, @current_time.mday])
        average_goal_per_day = (account['monthly_goal'] - num_points_so_far) / num_days_left
        LOG.debug("Average goal: %.2f" % average_goal_per_day)

        # for day_number, row in progress_report
        progress_report.each do |day_number, row|
          write_range = "Monthly Scorecard!A%i" % (day_number+1)
          values = ::Google::Apis::SheetsV4::ValueRange.new()
          date_str = "%s/%s/%s" % [@this_month, day_number, @current_time.year]

          if day_number >= @current_time.mday
            values.update!(range: write_range,
                           values: [[date_str, row[:points], average_goal_per_day]])
          else
            values.update!(range: write_range,
                           values: [[date_str, row[:points]]])
          end

          value_data.push(values)
        end

        if @config['update_report']
          LOG.debug(format('Updating sheet...'))
          batch.update!( data: value_data, value_input_option: 'RAW' )
          @service.batch_update_values( account['doc_id'], batch )
        end

        if @config['update_month_cell']
          values = Google::Apis::SheetsV4::ValueRange.new
          write_range = 'Monthly Scorecard!D1'
          values.update!( :values => [[ @num_days_this_month ]])
          service.update_spreadsheet_value(
              account['doc_id'], write_range, values, value_input_option: 'RAW')
        end
      end

      def get_data(account_name, doc_id)
        tmp_file = File.join('/', 'tmp', format('data-%s.json', account_name))
        if @config['flush_cache']
          LOG.debug('Getting from source.')
          read_range = 'Form Responses!A2:E'
          response = @service.get_spreadsheet_values(doc_id, read_range)
          if response.values.nil? || response.values.empty?
            puts 'No data found.'
          end

          data = response.values

          File.open(tmp_file, 'w') do |f|
            f.puts data.to_json
          end
        else
          data = JSON::parse(File.read(tmp_file))
        end
        data
      end

    end
  end
end
