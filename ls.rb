#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

options = ARGV.getopts('a', 'r', 'l')
results = []
file_or_dir = ARGV
# error = proc { raise ArgumentError, "ls: #{file_or_dir}: No such file or directory" }
if file_or_dir != []
  file_or_dir.each do |fod|
    if Dir.exist?(fod)
      Dir.open(fod).each_child { |f| results << f.ljust(11) unless f[0] == "." }
      results.sort!
    elsif File.expand_path(fod) && File.expand_path(fod) != (Dir.pwd + '/' + fod)
      results << File.expand_path(fod)
    else
      Dir.open('.').each { |f| results << f.ljust(11) if fod == f }
    end
  end
  results << "\n"
elsif options['a']
  Dir.open('.').each { |f| results << f.ljust(11) }
  results.sort!
elsif options['r']
  Dir.open('.').each_child { |f| results << f.ljust(11) unless f[0] == "." }
  results.sort!.reverse!
else
  Dir.open('.').each_child { |f| results << f.ljust(11) unless f[0] == "." }
  results.sort!
end
print results.join(' ')
