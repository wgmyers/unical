# hebrew.rb

# Handle cal-like output for the Hebrew calendar

require 'hebrew_date'

class Hebrew < Calendar

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

    # FIXME: here we need to:
    # * add the extra month if we are in a leap year
    # * calculate the proper lengths of Cheshvan and Kislev for the current year

    # Get a reference date for the first of given month
    ref_d = HebrewDate.new_from_hebrew(year, month, 1)
    today = HebrewDate.new(Date.today)

    pretty_month = ref_d.strftime('*B') # Gets long name of month
    day_of_first = ref_d.strftime('%w').to_i # Gets numeric dow 0-6, 0=Sunday

    # Month title omits year if full year being printed
    if @options[:fullyear]
      output.push(pretty_month.to_s.center(20))
    else
      output.push("#{pretty_month} #{year}".center(20))
    end

    line = ''
    day_of_first.times { line += '   ' }
    (1..months[month - 1]).each do |d|
      line += if @options[:highlight] == true &&
                 today.year == ref_d.year &&
                 today.month == ref_d.month &&
                 today.day == d
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
