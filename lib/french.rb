# frozen_string_literal: true

# french.rb

require 'RevCal'

# Handle cal-like output for French Revolutionary calendar
class French < Calendar

  def calc_month(year, month)
    output = []

    # Shamelessly cribbed from RevCal library, which does not do the nice
    # strftime stuff that other libraries do.
    month_names = ["Vendémiaire", "Brumaire", "Frimaire", "Nivôse", "Pluviôse",
        "Ventôse", "Germinal", "Floréal", "Prairial", "Messidor",
        "Thermidor", "Fructidor", "Sansculottides"]

    # We always need to know when today is (unless highlighting is off)
    today = RevDate.fromGregorian(Date.today)

    # Check to see if we need to set year and month
    if @options[:usetoday]
      daynum = Date.today.strftime('%d').to_i
      rev_date = RevDate.fromGregorian(Date.new(year, month, daynum))
      year = rev_date.year
      month = rev_date.month
    end

    # Get a reference date for the first of given month
    ref_d = RevDate.new(year, month, 1)

    pretty_month = month_names[month - 1] # Gets long name of month

    # Month title omits year if full year being printed
    if @options[:fullyear]
      output.push(pretty_month.to_s.center(30))
    else
      output.push("#{pretty_month} #{year}".center(30))
    end

    # Add days of week
    # FIXME: this is a non-ideal way of doing two-letter forms of the ten day
    # week, but I'm not sure that Qa Qi Sx and Sp are any better.
    # At least we don't need to worry about internationalisation here.
    output.push('Pr Du Tr Qu Qu Se Se Oc No Dé')

    line = ''
    (1..30).each do |d|
      line += if @options[:highlight] == true &&
                 today.year == ref_d.year &&
                 today.month == ref_d.month &&
                 today.day == d
                "\033[7m#{d.to_s.rjust(2, ' ')}\033[27m "
              else
                "#{d.to_s.rjust(2, ' ')} "
              end
      if (d % 10).zero?
        output.push(line)
        line = ''
      end
    end

    output
  end

end
