#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

# ------------ outline  ------------
def main(files, options)
  files << ('.') if files == []
  files.each do |file|
    array = build_array_all_files(file)
    adjust_option_a(array, options)
    return if blank?(array)

    puts file + ":" if files.length >= 2
    display_data(array, options)
  end
end

# ------------ processing infomation ------------
def build_array_all_files(path)
  array = []
  if path == '.'
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

# ------------ option a ------------
def adjust_option_a(array, options)
  array.delete_if { |ary| ary[0] == '.' } unless options['a']
  array << "" if blank?(array)
end

# ------------ option r ------------
def sort_or_reverse_sort(array, options)
  array.sort!
  array.reverse! if options['r']
end

# ------------ option l ------------
def display_long_result(array)
  total = calc_total_byte(array)
  puts "total #{total}"
  array.each do |ary|
    stat = File::Stat.new(ary)
    filetype = convert_filettype(ary)
    mode = convert_mode(stat)
    nlink = stat.nlink.to_s.rjust(3)
    username = Etc.getpwuid(stat.uid).name.ljust(12)
    groupname = Etc.getgrgid(stat.gid).name.ljust(5)
    size = convert_size(ary)
    mtime = stat.mtime.strftime('%_m %d %R')
    name = convert_filename(ary)
    puts <<~INFO
      #{filetype}#{mode}#{nlink} #{username}  #{groupname}#{size} #{mtime} #{name}
    INFO
  end
end

# ------------ arrange data for option l ------------
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
    "#{file} -> #{File.readlink(file)}"
  else
    file
  end
end

def convert_filettype(file)
  case File.ftype(file)
  when 'directory' then 'd'
  when 'link' then 'l'
  when 'pipe' then 'p'
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
  when '0' then '---'
  when '1' then '--x'
  when '2' then '-w-'
  when '3' then '-wx'
  when '4' then 'r--'
  when '5' then 'r-x'
  when '6' then 'rw-'
  when '7' then 'rwx'
  end
end

def convert_size(file)
  if File.symlink?(file)
    File.readlink(file).size.to_s.rjust(5)
  else
    File.size(file).to_s.rjust(5)
  end
end

# ------------ dislay infomation ------------
def display_data(array, options)
  sort_or_reverse_sort(array, options)
  if options['l']
    display_long_result(array)
  else
    to_equal_length(array)
    display_result(array)
  end
end

def to_equal_length(array)
  digits = array.max_by(&:length).length + 1
  array.each_with_index do |r, idx|
    array[idx] = r.ljust(digits)
  end
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
files = ARGV

main(files, options)
