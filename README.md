# Unical

An attempt at an "improved" version of cal, with support for arbitrary
calendrical systems and eventually things like dual calendar display.

## What Works And What Doesn't

Currently it's a cut-down version of cal, implementing everything except the
`-A`, `-B` and `-j` options.

I've yet to address any of the ncal stuff, so there's no Easter, no partial list
of switch from Julian to Gregorian, no handling of Julian dates of any sort,
and none of the extra ncal formatting options.

There is a new option `-U`, which, given the name of a calendar, will attempt
to use that for all calculations if it finds a file of the corresponding name
under the `lib` directory.

So far the only non-Gregorian calendars implemented are the Hebrew and French
Revolutionary calendars. Both seem to mostly work, with some bugs remaining and
many unanswered (and unexpected) questions.

## Installation

Really?

Ok, so you'll need a recent Ruby and a version of make. Not yet tested anywhere
but Linux so might not work for you as is.

Grab the repo and run `make install` to install the (currently one) dependency.

Run the `unical` shell script rather than `unical.rb` directly, unless you like
typing `bundle exec` a lot.

Please let me know how it goes if you try it out.

## Usage

Run `unical -H` or `unical --help` if you like typing.

I don't fully understand why `cal -h` now outputs help rather than being
the 'turn off highlighting' switch as claimed by the man page, but that's old
Unix commands for you. Anyway, `unical -h` (for now) does the switch thing.

## Adding Support For New Calendars

Really really? Like really? I'd be delighted, obviously.

Anyway. Look at `lib/hebrew.rb` and/or `lib/french.rb` to see how it works.

Basically, you drop a file in `lib` that inherits from `Calendar` in `lib/cal.rb`,
overriding whatever methods you need to make it all work.

Sometimes it might be ok just to override `calc_month`, but with Hebrew, I had
to override `print_year` as well because sometimes the Hebrew calendar has 13
months instead of 12. I'd imagine that any other lunisolar calendar will have to
do the same.

I'm planning to add a standard magic header for things like aliases and a
description, but that's not in place yet.

I'm also thinking very hard about whether or not I should even try adding
support for calendars I genuinely know nothing about beyond the Wikipedia page,
when it turns out that the Jewish calendar (about which I do know a few things)
turns out to be so tricky (and is definitely not right yet).

But I'd love to provide support for as many calendars as possible, over time,
and make it easy for people to add them: that was basically the Whole Idea.

## What's Next

See `TODO.md`

## Oh go on, do a date

Ok, 29th December, 2022 / 5th Tevet 5783 / 9 Nivôse 231

## That's not what the output looks like though, is it

No

## ...

Fine.

```
$ ./unical
   December 2022    
Su Mo Tu We Th Fr Sa
             1  2  3
 4  5  6  7  8  9 10
11 12 13 14 15 16 17
18 19 20 21 22 23 24
25 26 27 28 29 30 31

$ ./unical -U Hebrew
     Tevet 5783     
Su Mo Tu We Th Fr Sh
 1  2  3  4  5  6  7
 8  9 10 11 12 13 14
15 16 17 18 19 20 21
22 23 24 25 26 27 28
29

$ ./unical -U French
          Nivôse 231          
Pr Du Tr Qu Qu Se Se Oc No Dé
 1  2  3  4  5  6  7  8  9 10
11 12 13 14 15 16 17 18 19 20
21 22 23 24 25 26 27 28 29 30

```

## You should do screenshots

Yes. Probably.
