##
# Simple way of testing the service.
##
require 'pp'
require 'json'
require 'net/http'

desc "Load stuff."
task :load, :url do |t,args|
  uri = URI args[:url]
  http = Net::HTTP.new( uri.host, uri.port )

  iterations = 1000

  iterations.times do |i|
    #r = http.get format "/excercises/%i", rand( 100 )
    r = http.get format "/version"
    pp JSON::parse r.body 
    s = 0.1 * rand(10)
    #puts format('sleeping: %.2f', s)
    sleep s
  end
end
