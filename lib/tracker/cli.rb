module Tracker
  class CLI < Thor
    desc 'version', 'Display version'
    def version
      LOG.info(format('Version:  %s', Tracker::VERSION))
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