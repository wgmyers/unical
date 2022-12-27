# frozen_string_literal: true

# cal.rb

# A library to handle standard cal output
class Calendar
  class BadMonthError < StandardError
  end

  class BadYearError < StandardError
  end

  def initialize(options)
    @options = fix_options(options)
  end

  # fix_options
  # FIXME: * Quite a bit of old-school cal stuff to do here
  #        * Plus everything should be validated properly
  def fix_options(options)
    # Fix month
    raise BadMonthError unless options[:month] =~ /^\d+$/

    options[:month] = options[:month].to_i
    # FIXME - month out of bounds

    # Fix year
    raise BadYearError unless options[:year] =~ /^\d+$/

    options[:year] = options[:year].to_i
    # FIXME - year out of bounds

    # FIXME: fix other stuff?

    # Return munged options array
    options
  end

  # print_output
  # Looks at options to see what we should print, then prints it
  # FIXME - does not yet handle -A and -B options
  def print_output
    if @options[:fullyear]
      print_year
    elsif @options[:threemonth]
      print_three_months
    else
      print_month
    end
  end

  # print_year
  # Print a full year
  def print_year
    puts @options[:year].to_s.center(61)
    # FIXME: this will fail on years that have more than 12 months
    (2..11).step(3) do |m|
      @options[:month] = m
      print_three_months
      puts '' if m < 11 # copy finicky cal formatting exactly
    end
  end

  # print_three_months
  # Calculate and print given month plus previous and following months
  def print_three_months
    prev_m = get_prev_month(@options[:year], @options[:month])
    next_m = get_next_month(@options[:year], @options[:month])

    prev_month = calc_month(prev_m[0], prev_m[1])
    next_month = calc_month(next_m[0], next_m[1])
    this_month = calc_month(@options[:year], @options[:month])

    # Some months extend over more weeks than others, so we need to add blank
    # lines in the months with fewer weeks to ensure we get them all
    max_lines = [prev_month.length, next_month.length, this_month.length].max
    [prev_month, next_month, this_month].each do |month|
      month.push('') while month.length < max_lines
    end

    this_month.each_with_index do |line, index|
      puts "#{prev_month[index].ljust(21)} #{line.ljust(21)} #{next_month[index].ljust(21)}"
    end
    # We want an extra blank line if we're only doing three months
    # OR if it's a group of three months where no month extends into a 6th week
    # 7 is the magic number as two lines are for title and DOW
    puts '' if @options[:threemonth] || max_lines == 7
  end

  # print_month
  # Calculate and print a single month
  def print_month
    output = calc_month(@options[:year], @options[:month])
    output.each do |line|
      puts line
    end
    puts ''
  end

  #############
  # GREGORIAN #
  #############
  #
  # Everything below here assumes a Gregorian calendar, and needs to be moved
  # into a gregorian.rb file, so we can handle multiple different calendars
  # in the future.

  def get_prev_month(year, month)
    new_month = month - 1
    new_year = year
    if new_month.zero?
      new_year -= 1
      new_month = 12
    end
    [new_year, new_month]
  end

  def get_next_month(year, month)
    new_month = month + 1
    new_year = year
    if new_month == 13
      new_year += 1
      new_month = 1
    end
    [new_year, new_month]
  end

  # is_leap_year
  # Gregorian calendar, obvs
  def is_leap_year(year)
    if (year % 4).zero?
      if (year % 100).zero?
        return true if (year % 400).zero?

        return false
      end
      return true
    end
    false
  end

  # calc_month
  # Takes a month and year (Gregorian)
  # Returns array containing strings of cal formatted version of that month
  def calc_month(year, month)
    output = []

    months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    # Handle leap years
    months[1] = 29 if is_leap_year(year)

    # Get a reference date for the first of given month
    ref_d = Date.new(year, month, 1)
    today = Date.today

    pretty_month = ref_d.strftime('%B') # Gets long name of month
    day_of_first = ref_d.strftime('%w').to_i # Gets numeric dow 0-6, 0=Sunday

    # Month title omits year if full year being printed
    if @options[:fullyear]
      output.push(pretty_month.to_s.center(20))
    else
      output.push("#{pretty_month} #{year}".center(20))
    end

    # Days of week
    output.push('Su Mo Tu We Th Fr Sa') # FIXME internationalisation!

    line = ''
    day_of_first.times { line += '   ' }
    (1..months[month - 1]).each do |d|
      if @options[:highlight] == true &&
         today.year == ref_d.year &&
         today.month == ref_d.month &&
         today.day == d
        line += "\033[7m#{d.to_s.rjust(2, ' ')}\033[m "
      else
        line += "#{d.to_s.rjust(2, ' ')} "
      end
      if ((d + day_of_first) % 7).zero?
        output.push(line)
        line = ''
      end
    end
    output.push(line) if line != ''
    output
  end
end
