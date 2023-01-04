# frozen_string_literal: true

# hebrew.rb

require 'hebrew_date'

# Handle cal-like output for the Hebrew calendar
class Hebrew < Calendar
  # print_year
  # Print a full year
  # We need to override the default to handle leap years with 13 months
  def print_year
    puts "#{@options[:year] - 1}/#{@options[:year]}".center(61)
    (2..11).step(3) do |m|
      @options[:month] = m
      print_three_months
      puts ''
    end
    # Print a 13th month if we have one
    return unless HebrewDate.hebrew_leap_year?(@options[:year])

    @options[:month] = 13
    print_month
  end

  # calc_month
  # This is the main method that all non-Gregorian calendars need to override.
  def calc_month(year, month)
    output = []

    months = [30, 29, 30, 29, 30, 29, 30, 29, 30, 29, 30, 29]

    # Check to see if we need to figure out our own version of 'today'
    if @options[:usetoday]
      daynum = Date.today.strftime('%d').to_i
      hebrew_date = HebrewDate.new(year, month, daynum)
      year = hebrew_date.strftime('*Y').to_i
      month = hebrew_date.strftime('*m').to_i
    end

    # Add the extra month if we are in a leap year
    if HebrewDate.hebrew_leap_year?(year)
      months[11] += 1
      months.push(29)
    end

    # Get a reference date for the first of given month
    ref_d = HebrewDate.new_from_hebrew(year, month, 1)
    today = HebrewDate.new(Date.today)

    pp ref_d
    pp ref_d.year.to_s
    pp ref_d.month.to_s
    pp ref_d.day.to_s
    pp today

    # * calculate the proper lengths of Cheshvan and Kislev for the current year
    months[7] = 30 if ref_d.last_day_of_hebrew_month(8) == 30
    months[8] = 29 if ref_d.last_day_of_hebrew_month(9) == 29

    pretty_month = ref_d.strftime('*B') # Gets long name of month
    day_of_first = ref_d.strftime('%w').to_i # Gets numeric dow 0-6, 0=Sunday

    # Month title omits year if full year being printed
    if @options[:fullyear]
      output.push(pretty_month.to_s.center(20))
    elsif month < 7
      # Year changes in Tishri, not Nisan
      output.push("#{pretty_month} #{year - 1}".center(20))
    else
      output.push("#{pretty_month} #{year}".center(20))
    end

    # Add days of week
    output.push('Su Mo Tu We Th Fr Sh') # FIXME: internationalisation!

    line = ''
    day_of_first.times { line += '   ' }
    (1..months[month - 1]).each do |d|
      line += if @options[:highlight] == true &&
                 today == HebrewDate.new_from_hebrew(year, month, d)
                "\033[7m#{d.to_s.rjust(2, ' ')}\033[27m "
              else
                "#{d.to_s.rjust(2, ' ')} "
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
