#!/usr/bin/env ruby
require 'optparse'
require 'date'

today = Date.today

# コマンドライン引数を変数化
options = ARGV.getopts("m:", "y:")

# 月の設定
if options["m"]
  month = options["m"].to_i
else
  month = today.month
end

# 年の設定
if options["y"]
  year = options["y"].to_i
else
  year = today.year
end

# 月初月末の変数化
first_day = Date.new(year, month , 1)
last_day = Date.new(year, month , -1)

# カレンダーに使用する配列を作成
days = []
(first_day.wday).times { days << " "  }
1.upto(last_day.day) { |day| days << day }

# 週ごとに配列を分ける
weekdays = days.each_slice(7).to_a

# 表示に関するものをメソッド化
def arrange_to_three_chars(day)
  if day.to_i < 10
    " #{day} "
  else
    "#{day} "
  end
end

def black_and_white_reversal(today)
  "\e[7;37m#{today}\e[0m "
end

def today?(year, month, day)
  today = Date.today
  today.year == year &&
  today.month == month &&
  today.day == day
end

def enter_new_line
  puts "\n"
end

# カレンダーの表示
puts "      #{month}月 #{year}    "
puts "日 月 火 水 木 金 土"
weekdays.each do |week|
  week.each do |day|
    if today?(year, month, day)
      print black_and_white_reversal(day)
    else
      print arrange_to_three_chars(day)
    end
  end
  enter_new_line
end
enter_new_line
