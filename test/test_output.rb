#!/usr/bin/env ruby

# test_output.rb

# Test that our output matches that of cal, when appropriate
# NB:
# * not unit tests - we literally run cal(1) and unical.rb and compare output.
# * we cheat a bit b/c cal's whitespace output is insane and we don't copy it exactly

require 'pty'

TESTS = [
  ['', 'No flags given'],
  ['-h', 'Remove highlighting'], # FAILS b/c cal -h does not behave as expected.
  ['07 1971', 'July 1971'],
  ['-m 6', 'June of this year'],
  ['-1', 'One month only'],
  ['-3', 'Three months with current month in middle'],
  ['1984', 'Year specified without -y'],
  ['-y 1984', 'Year specified with -y'],
  ['-d 1984-12', 'Month specified with -d']
]

# strip_trailing
# Strips trailing whitespace from each line of a multiline string
# A workaround for the fact that we do not after all replicate cal(1) exactly
# and it has weird trailing whitespace (so do we, but differently)
def strip_trailing(str)
  lines = str.split("\n")
  output = []
  lines.each do |line|
    output.push(line.rstrip)
  end
  output.join("\n")
end

# compare_output
# Take a string  of command line flags
# Run cal with them and capture output
# Run unical.rb with them, and check output is identical, MODULO trailing
# whitespace, which cal is weird about and we aren't mimicking exactly yet.
# Return true if so, false otherwise
def compare_output(flags)
  cal_cmd = "cal #{flags}"
  unical_cmd = "../unical.rb #{flags}"
  # cal_output = strip_trailing(`#{cal_cmd}`)
  # We need to run cal from a PTY or it won't do highlighting
  cal_output_lines = []
  begin
    PTY.spawn(cal_cmd) do |r_f, _w_f, _pid|
      r_f.each { |line| cal_output_lines.push(line) }
    end
  rescue Errno::EIO
  end
  cal_output = strip_trailing(cal_output_lines.join(''))
  unical_output = strip_trailing(`#{unical_cmd}`)

  return true if cal_output == unical_output

  false
end

puts 'Testing output of unical.rb against cal output:'
puts 'NB: the -h test fails because cal -h does not work as expected'

TESTS.each do |test|
  print "* - #{test[1]} (#{test[0]}): "
  if compare_output(test[0])
    puts 'OK'
  else
    puts 'FAILED'
  end
end
