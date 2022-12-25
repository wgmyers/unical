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

  # print
  # Assumes we have a good month and year
  # Prints out cal formatted version of that month
  def print_month
    # FIXME: The WHOLE POINT is not to assume a Julian calendar
    months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    # Get a reference date for the first of given month
    ref_d = Date.new(@options[:year], @options[:month], 1)

    pretty_month = ref_d.strftime("%B") # Gets long name of month
    day_of_first = ref_d.strftime("%w").to_i # Gets numeric dow 0-6, 0=Sunday

    puts "#{pretty_month} #{@options[:year]}".center(20)

    puts "Su Mo Tu We Th Fr Sa"
    day_of_first.times { print "   " }
    (1..months[@options[:month] - 1]).each do |d|
      print "#{d.to_s.rjust(2, " ")} "
      puts "" if ((d + day_of_first)%7 == 0)
    end
    puts ""

  end

end
