#!/usr/bin/env ruby

#
# Timesheeting tool which shows time entries from Redmine
# (using its RESTful API).
#
# Author: Jan Vlcek <vlki@vlki.cz>
#

require 'rubygems'
require 'yaml'
require 'optparse'

$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'redmine_time_entries'

# Setup the option parsing
optparse = OptionParser.new do |opts|
   # Set a banner, displayed at the top
   # of the help screen.
   opts.banner = "Usage: run.rb [options] user_id from_date to_date"
   opts.separator ""
   opts.separator "Arguments:"
   opts.separator "  user_id: The Redmine ID of user we want to track"
   opts.separator "  from_date: The starting date in ISO-6901 format (inclusive)"
   opts.separator "  to_date: The ending date in ISO-6901 format (inclusive)"
   opts.separator ""
   opts.separator "Options:"
 
   # This displays the help screen, all programs are
   # assumed to have this option.
   opts.on( '-h', '--help', 'Display this screen' ) do
     puts opts
     exit
   end
end

# Commence the parsing
optparse.parse!

# Load configuration
begin
  config = YAML.load_file('config.yml')
rescue Errno::ENOENT => e
  # config file not found
  puts 'error: provide the config.yml'
  exit false
end

if ARGV.length != 3
  puts 'error: three arguments must be specified'
  exit false
end

from = Date.parse(ARGV[1])
to = Date.parse(ARGV[2])
user_id = ARGV[0].to_i

# load entries
redmine_time_entries = RedmineTimeEntries::List.new(*config['redmine'].values)
entries = redmine_time_entries.find(user_id, from, to)

# print entries
puts "Spent on\tHours\tIssue#\tComment"
entries.each do |entry|
  puts entry.spent_on.to_s \
       + "\t" + entry.hours.to_s \
       + "\t" + entry.issue_id.to_s \
       + "\t" + entry.comments.to_s \
end
