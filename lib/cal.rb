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
    if options[:month] =~ /^\d+$/
      options[:month] = options[:month].to_i
    else
      raise BadMonthError
    end
    # FIXME - month out of bounds
    # Fix year
    if options[:year] =~ /^\d+$/
      options[:year] = options[:year].to_i
    else
      raise BadYearError
    end
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

  # print_three_months
  # Calculate and print given month plus previous and following months
  def print_three_months
    prev_m = get_prev_month(@options[:year], @options[:month])
    next_m = get_next_month(@options[:year], @options[:month])

    prev_month = calc_month(prev_m[0], prev_m[1])
    next_month = calc_month(next_m[0], next_m[1])
    this_month = calc_month(@options[:year], @options[:month])

    this_month.each_with_index do |line, index|
      puts "#{prev_month[index].ljust(21)}  #{line.ljust(21)}  #{next_month[index].ljust(21)}"
    end
    puts ""

  end

  # print_month
  # Calculate and print a single month
  def print_month
    output = calc_month(@options[:year], @options[:month])
    output.each do |line|
      puts line
    end
    puts ""
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
    if new_month == 0
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
    if year % 4 == 0
      if year % 100 == 0
        if year % 400 == 0
          return true
        else
          return false
        end
      end
      return true
    end
    return false
  end

  # calc_month
  # Takes a month and year (Gregorian)
  # Returns array containing strings of cal formatted version of that month
  def calc_month(year, month)
    output = []

    months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    # Handle leap years
    if is_leap_year(year)
      months[1] = 29
    end

    # Get a reference date for the first of given month
    ref_d = Date.new(year, month, 1)
    today = Date.today

    pretty_month = ref_d.strftime("%B") # Gets long name of month
    day_of_first = ref_d.strftime("%w").to_i # Gets numeric dow 0-6, 0=Sunday

    output.push("#{pretty_month} #{year}".center(20))
    output.push("Su Mo Tu We Th Fr Sa") # FIXME internationalisation!

    line = ""
    day_of_first.times { line += "   " }
    (1..months[month - 1]).each do |d|
      if (@options[:highlight] == true &&
          today.year == ref_d.year &&
          today.month == ref_d.month &&
          today.day == d)
        line += "\033[7m#{d.to_s.rjust(2, " ")}\033[m "
      else
        line += "#{d.to_s.rjust(2, " ")} "
      end
      if ((d + day_of_first)%7 == 0)
        output.push(line)
        line = ""
      end
    end
    output.push(line) if line != ""
    output
  end

end
