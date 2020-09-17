#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.chars

frames = Array.new(9) { [0, 0] }
frames.push([0, 0, 0])

count = 0
first_throw = true
final_flag = false
scores.each do |score|
  if count == 9 && first_throw
    if score == "X"
      frames[9][0] = 10
      first_throw = false
    else
      frames[9][0] = score.to_i
      first_throw = false
    end
  elsif count == 9 && !final_flag
    if score == "X"
      frames[9][1] = 10
    else
      puts "きたよ"
      frames[9][1] = score.to_i
    end
    final_flag = true
  elsif final_flag
    if frames[9].sum >= 10
      if score == "X"
        frames[9][2] = 10
      else
        frames[9][2] = score.to_i
      end
    end
  else
    if first_throw
      if score == "X"
        frames[count][0] = 10
        frames[count][1] = 0
        count += 1
        first_throw = true
      else
        frames[count][0] = score.to_i
        first_throw = false
      end
    else
      if score == "X"
        frames[count][1] = 10
      else
        frames[count][1] = score.to_i
      end
      count += 1
      first_throw = true
    end
  end
end

point = 0
frames.each_with_index do |frame, idx|
  if idx == 9
    p point += frame.sum
  elsif frame[0] == 10
    if idx == 8
      p point += (10 + frames[9][0] + frames[9][1])
    elsif frames[idx + 1][0] == 10
      p point += (10 + 10 + frames[idx + 2][0])
    else
      p point += (10 + frames[idx + 1].sum)
    end
  elsif frame.sum >= 10 && idx != 9
    p point += (10 + frames[idx + 1][0])
  else
    p point += frame.sum
  end
end

puts point

