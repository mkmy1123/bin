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
  lines.sum { |line| line.split("\s").length }
end

def count_bytes(lines)
  lines.sum { |line| line.bytesize }
end

# ----- method to display info ------
def to_8char(data)
  data.to_s.rjust(8)
end

def hash_to_8char(hash)
  string = ""
  hash.each_value { |value| string += to_8char(value) }
  string
end

# ----- variable for total data ------
total = {
  line: 0,
  string: 0,
  bytes: 0,
}

def calc_data(lines)
  {
    line_length: count_lines(lines),
    string_length: count_strings(lines),
    bytes: count_bytes(lines),
  }
end

# ----- display data ------
if lines # stdin
  result = calc_data(lines)
  if option_l
    puts to_8char(result[:line_length])
  else
    puts hash_to_8char(result)
  end
else
  path_or_error.each do |string|
    if File.exist?(string)
      path = string
      lines = IO.readlines(path)
      result = calc_data(lines)
      if option_l
        puts "#{to_8char(result[:line_length])} #{path}"
      else
        puts <<~INFO
          #{hash_to_8char(result)} #{path}
        INFO
      end
      total[:line] += result[:line_length]
      total[:string] += result[:string_length]
      total[:bytes] += result[:bytes]
    else
      puts string # error
    end
  end
  # --> display total data
  if path_or_error.length > 1
    if option_l
      puts "#{to_8char(total[:line])} total"
    else
      puts <<~INFO
        #{hash_to_8char(total)} total
      INFO
    end
  end
end
