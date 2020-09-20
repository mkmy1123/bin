#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

# ----- AGRV arrange for option ------
option_l = false
opt = OptionParser.new
opt.on('-l') { option_l = true }
opt.parse!(ARGV)

# ----- get data by stdin ------
unless $stdin.tty?
  lines = []
  while line = gets
    lines << line
  end
end

# ----- method for path_or_error ------
def file_exist?(path)
  if Dir.exist?(path)
    "wc: #{path}: read: Is a director"
  elsif File.exist?(path)
    File.path(path)
  else
    "wc: #{path}: open: No such file or directory"
  end
end

# ----- ARGV -> path_or_error ------
paths = ARGV
path_or_error = []
paths.each do |path|
  path_or_error << file_exist?(path)
end

# ----- method to get info ------
def count_lines(lines)
  lines.length
end

def count_strings(lines)
  string_count = 0
  lines.each do |line|
    string_count += line.split("\s").length
  end
  string_count
end

def count_bytes(lines)
  bytes = 0
  lines.each do |line|
    bytes += line.bytesize
  end
  bytes
end

# ----- method to display info ------
def to_8char(data)
  data.to_s.rjust(8)
end

# ----- variable for total data ------
total_line = 0
total_string = 0
total_bytes = 0

# ----- display data ------
if lines # stdin
  line_length = count_lines(lines)
  string_length = count_strings(lines)
  bytes = count_bytes(lines)
  if option_l
    puts to_8char(line_length)
  else
    puts <<~INFO
      #{to_8char(line_length)}#{to_8char(string_length)}#{to_8char(bytes)}
    INFO
  end
else
  path_or_error.each do |string|
    if File.exist?(string)
      path = string
      lines = IO.readlines(path)
      line_length = count_lines(lines)
      string_length = count_strings(lines)
      bytes = count_bytes(lines)
      if option_l
        puts "#{to_8char(line_length)} #{path}"
      else
        puts <<~INFO
          #{to_8char(line_length)}#{to_8char(string_length)}#{to_8char(bytes)} #{path}
        INFO
      end
      total_line += line_length
      total_string += string_length
      total_bytes += bytes
    else
      puts string # error
    end
  end
  # --> display total data
  if option_l
    puts "#{to_8char(total_line)} total"
  else
    puts <<~INFO
      #{to_8char(total_line)}#{to_8char(total_string)}#{to_8char(total_bytes)} total
    INFO
  end
end
