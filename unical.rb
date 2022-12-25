#!/usr/bin/env ruby

# unical.rb

# cal syntax:
# cal [month] [year] [-m month] [-y year] [-h] [-3] [-1] [-A num] [-B num]
#     [-d YYYY-MM] [-j] [-N]

# ncal syntax:
# ncal [month] [year] [-m month] [-y year] [-h] [-3] [-1] [-A num] [-B num]
#      [-d YYYY-MM] [-J] [-C] [-e] [-o] [-p] [-w] [-M] [-S] [-b]

require 'optparse'
require 'date'

VERSION = '0.0.1'
options = {
  action: :print,
  month: nil,
  year: nil,
  fullyear: false,
  highlight: true,
  calendar: 'Julian'
}

month_help = 'Specify a month to display'
year_help = 'Specify a year to display'
highlight_help = 'Do not highlight current day'

op = OptionParser.new
op.banner =  'An improved version of cal/ncal.'
op.separator ''
op.separator 'Usage: unical.rb [OPTION/S]'
op.separator ''

op.separator ''
op.separator 'Supported legacy cal commands:'
op.on('-m', '--set-month=MONTH', month_help) do |mon|
  options[:month] = mon
end
op.on('-y', '--set-year=YEAR', year_help) do |year|
  options[:fullyear] = true
  options[:year] = year
end
op.on('-h', '--no-highlight', highlight_help) { options[:highlight] = false }

op.separator ''
op.separator 'Common options:'
op.on('-H', '--help')    { options[:action] = :help    }
op.on('-V', '--version') { options[:action] = :version }

op.separator ''
begin
  op.parse!(ARGV)
rescue OptionParser::MissingArgument
  puts 'Must specify argument if using -m, -y, -A, -B or -d'
  exit 1
rescue OptionParser::InvalidOption
  puts 'Options invalid - try -H or --help'
  exit 1
end

# Handle options that don't need loading anything
case options[:action]
when :help
  puts op.to_s
  exit 0
when :version
  puts "This is unical.rb version #{VERSION}"
  exit 0
end

# Parse anything  left on the command line
# One item = a year
# Two items = a month and a year
# Three items = error
if ARGV.length == 1
  options[:year] = ARGV[0]
  options[:fullyear] = true
end
if ARGV.length == 2
  options[:month] = ARGV[0]
  options[:year] = ARGV[1]
end
if ARGV.length > 2
  puts op.to_s
  exit 1
end

# Get current month and year if needed
options[:year] = Date.today.strftime("%Y") unless options[:year]
options[:month] = Date.today.strftime("%m") unless options[:month]

puts "Cal output goes here"
pp options

exit 0
