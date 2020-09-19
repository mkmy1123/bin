#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

def main(file_or_dir, options)
  if file_or_dir != []
    file_or_dir.each do |fod|
      array = build_array_all_files(fod)
      adjust_option_a(array, options)
      return if blank?(array)
      if Dir.exist?(fod)
        puts fod
        display_data(array, options)
      else
        display_data(array, options)
      end
    end
  else
    array = build_array_all_files(".")
    adjust_option_a(array, options)
    return if is_blank?(array)
    display_data(array, options)
  end
end

def build_array_all_files(path)
  array = []
  if path == "."
    Dir.open('.').each { |file| array << file }
  elsif Dir.exist?(path)
    Dir.open(path).each { |file| array << file }
  elsif Dir.open('.').include?(path)
    array << path
  elsif File.exist?(path)
    array << File.expand_path(path)
  else
    array << "ls: #{path}: No such file or directory"
  end
  array
end

def blank?(array)
  array == []
end

def adjust_option_a(array, options)
  unless options['a']
    array.delete_if { |ary| ary[0] == "." }
  end
end

def display_data(array, options)
  sort_or_reverse_sort(array, options)
  if options['l']
    display_long_result(array)
  else
    to_equal_length(array)
    display_result(array)
  end
end

def sort_or_reverse_sort(array, options)
  array.sort!
  array.reverse! if options['r']
  array
end

def display_long_result(array)
  total = calc_total_byte(array)
  puts "total #{total}"
  array.each_with_index do |ary, idx|
    stat = File::Stat.new(ary)
    filetype = convert_filettype(ary)
    mode = convert_mode(stat)
    nlink = stat.nlink.to_s.rjust(3)
    username = Etc.getpwuid(stat.uid).name.ljust(12)
    groupname = Etc.getgrgid(stat.gid).name.ljust(7)
    size = convert_size(ary)
    mtime = stat.mtime.strftime("%_m %d %R")
    name = convert_filename(ary)
    puts <<~INFO
    #{filetype}#{mode}#{nlink} #{username}  #{groupname}#{size} #{mtime} #{name}
    INFO
  end
end

def calc_total_byte(array)
  total = 0
  array.each do |ary|
    total +=
      if File.symlink?(ary)
        0
      else
        File::Stat.new(ary).blocks
      end
  end
  total
end

def convert_filename(file)
  if File.symlink?(file)
    name = "#{file} -> #{File.readlink(file)}"
  else
    name = file
  end
end

def convert_filettype(file)
  case File.ftype(file)
  when "directory" then 'd'
  when "link" then 'l'
  when "pipe" then 'p'
  else '-'
  end
end

def convert_mode(stat)
  mode = []
  mode << permission(stat.mode.to_s(8)[-3])
  mode << permission(stat.mode.to_s(8)[-2])
  mode << permission(stat.mode.to_s(8)[-1])
  mode.join
end

def permission(string)
  case string
  when "0" then "---"
  when "1" then "--x"
  when "2" then "-w-"
  when "3" then "-wx"
  when "4" then "r--"
  when "5" then "r-x"
  when "6" then "rw-"
  when "7" then "rwx"
  end
end

def convert_size(file)
  if File.symlink?(file)
    File.readlink(file).size.to_s.rjust(6)
  else
    File.size(file).to_s.rjust(6)
  end
end

def to_equal_length(array)
  digits = array.max_by(&:length).length + 1
  array.each_with_index do |r, idx|
    array[idx] = r.ljust(digits)
  end
  array
end

def display_result(array)
  display = []
  (array.length / 5.0).ceil.times do |i|
    display[i] = []
  end
  array.each_with_index do |result, idx|
    display[idx % display.length] << result
  end
  display.each do |files|
    files.each do |file|
      print file
    end
    puts "\n"
  end
end

options = ARGV.getopts('a', 'r', 'l')
file_or_dir = ARGV

main(file_or_dir, options)
