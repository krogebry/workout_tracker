##
# Simple way of testing the service.
##
require 'pp'
require 'json'
require 'aws-sdk'
require 'net/http'
require 'fileutils'

desc "Load stuff."
task :load, :url do |t,args|
  uri = URI args[:url]
  http = Net::HTTP.new( uri.host, uri.port )

  iterations = 1000

  iterations.times do |i|
    r = http.get format "/version"
    pp JSON::parse r.body 
    s = 0.1 * rand(10)
    sleep s
  end
end

def get_enc_client
  creds = Aws::SharedCredentials.new()
  s3_client = Aws::S3::Client.new(region: ENV['AWS_DEFAULT_REGION'], credentials: creds)
  kms_client = Aws::KMS::Client.new(region: ENV['AWS_DEFAULT_REGION'], credentials: creds)

  #aliases = kms_client.list_aliases.aliases
  #key = aliases.find { |alias_struct| alias_struct.alias_name == format("alias/workout-tracker-%s", ENV['ENV_NAME']) }
  #key_id = key.target_key_id
  key_id = "f9ea7c6a-4f61-4b35-99b8-a3096be09569"

  Aws::S3::Encryption::Client.new(
    client: s3_client,
    kms_key_id: key_id,
    kms_client: kms_client
  )
end

def mk_secrets_dir
  dir = '/tmp/secrets/workout-tracker/%s/env' % ENV['ENV_NAME']
  if !File.exists? dir
    FileUtils.mkdir_p dir 
  end
end

namespace :secrets do

  desc "Push secrets"
  task :push do |t,args|
    mk_secrets_dir
    s3_enc_client = get_enc_client()
    s3_enc_client.put_object(
      key: '%s/env' % ENV['ENV_NAME'],
      body: File.read('/tmp/secrets/workout-tracker/%s/env' % ENV['ENV_NAME']),
      bucket: 'workout-tracker'
    )
  end

  desc "Pull secrets"
  task :pull do |t,args|
    mk_secrets_dir
    s3_enc_client = get_enc_client()
    File.open('/tmp/secrets/workout-tracker/%s/env' % ENV['ENV_NAME'], 'w') do |f|
      s3_enc_client.get_object(
        key: '%s/env' % ENV['ENV_NAME'],
        bucket: 'workout-tracker'
      ) do |chunk|
        f.write(chunk)
      end
    end
  end

end

