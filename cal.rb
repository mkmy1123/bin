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

# カレンダーの表示
puts "      #{month}月 #{year}    "
puts "日 月 火 水 木 金 土"
weekdays.each do |week|
  week.each do |day|
    if day == today.day && month == today.month && year == today.year
      print "\e[7;37m#{today.day}\e[0m "
    elsif day.to_i< 10
      print " #{day} "
    else
      print "#{day} "
    end
  end
  puts "\n"
end
puts "\n"
