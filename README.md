Redmine-Gdocs timesheeter
=========================

Command line tool which transfers time entries from Redmine to Google Docs spreadsheet.

NOTE: Right now it just lists all time entries of given user in requested date range.

Configuration:
##############

You need to provide configuration to tell the script which Redmine application should be used, how should it authenticate itself. Also credentials for Google Docs are needed. Just copy the `config.yml.dest` to `config.yml` and update it.

Usage:
######

`./run.rb user_id from_date to_date`

Example:
########

By running `./run.rb 22 2011-06-01 2011-06-05` you will get list of time entries which starts on the June 1st, 2011 and end on June 5th, 2011 inclusive. Only time entries of user with Redmine user ID 22 will be listed.

TODO:
#####

* updating the spreadsheet
