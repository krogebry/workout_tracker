require 'koala'

module Tracker
  class CLI < Thor
    desc 'version', 'Display version'
    def version
      LOG.info(format('Version:  %s', Tracker::VERSION))
    end

    desc 'fb', 'FB scrape'
    def fb
      url = 'http://misty-dev.krogebry.com/fb_oauth_callback'
      @oauth = Koala::Facebook::OAuth.new(165492310670315, '8d24ce85e4f55b10e64afe961c77dff8')
      # pp @oauth.url_for_oauth_code
      # puts @oauth.url_for_oauth_code

      @graph = Koala::Facebook::API.new('EAACWg65jZBZBsBAPeM8vQ9YSZBxp1gPECHrVeQKycERM6dkIPD5ldKIH2UeJFZC2Lv1IdS4z20MzmpcX5cgXd4FF6fZBHxDVnDZB6rQnwM3swrRZA12nwBzC9czRfrGQ6dsVL0TCbGk6Q5Mq1elAUXcKedP35tfd0UZD')
      pp @graph.get_object('702632493_10156759404097494')
    end

    desc 'workout NAME', 'Update workouts for NAME'
    def workout(name='ALL')
      s = Tracker::Workout::SheetService.new

      accounts = name == 'ALL' ? s.get_all_accounts : [name]

      accounts.each do |account|
        s.update_account(account)
      end
    end
  end
end