#
#
#
#
#

require 'redmine_client'

module RedmineClient
  class TimeEntry < RedmineClient::Base
  end
end

module RedmineTimeEntries
  class TimeEntry
    attr_accessor :spent_on, :hours, :comments, :issue_id, :user_id
  end

  class List
    def initialize(site, user, password)
      RedmineClient::Base.configure do
        self.site = site
        self.user = user
        self.password = password
      end
    end

    def find(user_id, from, to)
      result = []         
      page = 1

      begin
        entries = _fetch_entries(page)

        entries.each do |entry|
          if entry.spent_on >= from and entry.spent_on <= to and entry.user_id == user_id
            result.push(entry)
          end
        end

        page += 1
      end while not entries.empty? and entries.last.spent_on >= from

      result
    end

    def _fetch_entries(page)
      entries = []

      RedmineClient::TimeEntry.find(:all, :params => { :page => page }).each do |redmine_entry|
        entry = TimeEntry.new
        entry.spent_on = Date.parse(redmine_entry.spent_on)
        entry.hours = redmine_entry.hours.to_f
        entry.comments = redmine_entry.comments
        entry.user_id = redmine_entry.user.id.to_i

        if redmine_entry.respond_to?('issue')
          entry.issue_id = redmine_entry.issue.id.to_i
        end
       
        entries.push(entry)
      end

      entries
    end
  end
end
