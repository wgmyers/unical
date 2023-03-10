# TODO

1. - Replicate a reasonable subset of cal, ensuring calendar details are kept
separate from display details.

## DONE

* -h - Don't highlight today's date
* -m MONTH - Specify month - numerical values only
* -y YEAR - Specify year
* -1 - Output one month only
* -3 - Output one month either side of current month
* -d YYYY-MM - Set current month to given value
* Output mirrors some cal quirks (extra lines except when displaying year, year
  output displays month titles differently)

## ADDED

* -H - output help
* -v - version
* Long options also implemented, no idea if they match cal long options

## NOT DONE

* -m MONTH - non-numerical values
* -y - Original cal allows '-y' by itself for current year, this does not (yet)
* -A X - display X trailing months to whatever else specified
* -B X - display X preceding months to whatever else specified
* -j - display a "Julian" calendar (not actually Julian calendar) with DoY instead of DoM
* -N - behave like ncal
* Any kind of handling of Julian / Gregorian calendar switch
* Any of the ncal only options
* Deep dive to ensure multiple options behave exactly like original cal does

2. - Add eg Hebrew calendar, Islamic calendar, French Revolutionary calendar etc.

### General

#### TODO

* Hook to add warning before undebugged / verified output
* Hook + cmdline switch (-e?) to add extra info where available
* Standard header in lib files to provide aliases and description
* Cmdline switch to list known calendars

### Hebrew

#### DONE

* Basic Hebrew calendar added - MIGHT WELL BE BUGGY NEED TO TEST EXTENSIVELY!

#### TODO

* Add support for displaying year starting in Tishri not Nisan
* Add support for highlighting festivals
* Add support for other fun stuff in the hebrew_date gem

#### Issues

* Using -d option for months before Tishri gives month from previous year
* Using -m option gives 'invalid date'

#### French Revolutionary

#### DONE

* Basic calendar added, needs testing

#### TODO

* Add highlighting for sansculottides
* Fix width issue somehow (three months of ten day weeks don't fit standard
terminal sizes)

#### Issues

* -m borked - not sure what is happening to year but it is the Wrong Thing

# Useful Libraries

Hebrew date library: https://github.com/dorner/hebrew_date

Islamic date library: https://github.com/ecleel/hijri

French Revolutionary date library: https://github.com/jhbadger/FrenchRevCal-ruby

Korean: https://github.com/sunsidew/ruby_lunardate

Chinese (partial): https://github.com/mycolorway/lunar_blessing

Persian / Indian (JavaScript): https://github.com/shahabyazdi/date-object

Discordian calendar: https://www.rubydoc.info/gems/ddate/1.0.0/DDate

Another one: https://github.com/tamouse/ddate-redux
