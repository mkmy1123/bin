#!/usr/bin/env ruby
require 'optparse'
require 'date'

# 表示に関するメソッド
def arrange_to_three_chars(day)
  day.to_i < 10 ? " #{day} " : "#{day} "
end

def convert_reverse_color(today)
  "\e[7;37m#{today}\e[0m "
end

def today?(today, year, month, day)
  year, month, day = [year, month, day].map!(&:to_i)
  today == Date.new(year, month, day) unless day == 0
end

today = Date.today
# コマンドライン引数を変数化
options = ARGV.getopts("m:", "y:")

# 月の設定
month = options["m"] || today.month
# 年の設定
year = options["y"] || today.year

# 月初月末の変数化
first_day = Date.new(year, month , 1)
last_day = Date.new(year, month , -1)

# カレンダーに使用する配列を作成
days = ([" "] * first_day.wday) + (1..last_day.day).to_a

# カレンダーの表示
puts "      #{month}月 #{year}    "
puts "日 月 火 水 木 金 土"
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
