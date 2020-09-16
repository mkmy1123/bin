#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'date'

# methods for display
def arrange_to_three_chars(day)
  day.to_i < 10 ? " #{day} " : "#{day} "
end

def convert_reverse_color(today)
  "\e[7;37m#{today}\e[0m "
end

def today?(today, year, month, day)
  year, month, day = [year, month, day].map!(&:to_i)
  today == Date.new(year, month, day) unless day.zero?
end

today = Date.today
options = ARGV.getopts('m:', 'y:')

# variable for month
month = options['m'] || today.month
# variable for year
year = options['y'] || today.year

# variable for day
first_day = Date.new(year, month, 1)
last_day = Date.new(year, month, -1)

# array for calendar
days = ([' '] * first_day.wday) + (1..last_day.day).to_a

# display calendar
puts "      #{month}月 #{year}    "
puts '日 月 火 水 木 金 土'
days.each_slice(7) do |week|
  week.each do |day|
    if today?(today, year, month, day)
      print convert_reverse_color(day)
    else
      print arrange_to_three_chars(day)
    end
  end
  puts "\n"
end
puts "\n"
