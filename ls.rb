#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

options = ARGV.getopts('a', 'r', 'l')
results = []

if options['a']
  Dir.open('.').each { |f| results << f.ljust(11) }
  results.sort!
  results << "\n"
elsif options['r']
  Dir.open('.').each_child { |f| results << f.ljust(11) unless f[0] == "." }
  results.sort!.reverse!
  results << "\n"
else
  Dir.open('.').each_child { |f| results << f.ljust(11) unless f[0] == "." }
  results.sort!
  results << "\n"
end
print results.join(' ')
