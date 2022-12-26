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

require_relative 'lib/cal'

VERSION = '0.0.1'
options = {
  action: :print,
  month: nil,
  year: nil,
  fullyear: false,
  threemonth: false,
  highlight: true,
  calendar: 'Gregorian'
}

month_help = 'Specify a month to display'
year_help = 'Specify a year to display'
highlight_help = 'Do not highlight current day'
one_month_help = 'Display one month as default'
three_month_help = 'Display three months as default'
current_month_help = 'Operate as if current month is YYYY-MM'

op = OptionParser.new
op.banner =  'An improved version of cal/ncal.'
op.separator ''
op.separator 'Usage: unical.rb [month] [year] [OPTION/S]'
op.separator ''

op.separator 'Supported legacy cal options:'
op.on('-m', '--set-month=MONTH', month_help) do |mon|
  options[:month] = mon
end
op.on('-y', '--set-year=YEAR', year_help) do |year|
  options[:fullyear] = true
  options[:year] = year
end
op.on('-h', '--no-highlight', highlight_help) { options[:highlight] = false }
op.on('-1', '--one-month', one_month_help) {
  options[:fullyear] = false
  options[:threemonth] = false
}
op.on('-3', '--three-month', three_month_help) {
  options[:fullyear] = false
  options[:threemonth] = true
}
op.on('-d', '--current-month=YYYY-MM', current_month_help) do |input|
  if input !~ /^\d{4}-\d{2}$/
    puts "Error: -d option must be YYYY-MM format"
    exit 1
  end
  year, month = input.split("-")
  options[:year] = year
  options[:month] = month
end

op.separator ''
op.separator 'Standard options:'
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

cal = Calendar.new(options)
cal.print_output

exit 0
