#!/usr/bin/env ruby
# frozen_string_literal: true

string_score = ARGV[0]
scores = string_score.chars

frames = Array.new(9) { [0, 0] }
frames.push([0, 0, 0])

frame_count = 0
frame_first_throw = true
final_throw = false

def to_integer(score)
  score == 'X' ? 10 : score.to_i
end

def final_frame?(frame_count)
  frame_count == 9
end

def strike?(frame)
  frame[0] == 10
end

def spare?(frame)
  frame.sum == 10 && !strike?(frame)
end

scores.each do |score|
  if final_frame?(frame_count)
    if frame_first_throw
      frames[9][0] = to_integer(score)
      frame_first_throw = false
    elsif !final_throw
      frames[9][1] = to_integer(score)
      final_throw = true
    elsif final_throw
      frames[9][2] = to_integer(score)
    end
  elsif frame_first_throw
    frames[frame_count][0] = to_integer(score)
    case score
    when 'X'
      frame_count += 1
      frame_first_throw = true
    else
      frame_first_throw = false
    end
  else
    frames[frame_count][1] = to_integer(score)
    frame_count += 1
    frame_first_throw = true
  end
end

point = 0
point = frames.each_with_index.sum do |frame, idx|
  next_frame = frames[idx + 1]
  case
  when idx == 9
    frame.sum
  when idx == 8 && strike?(frame)
    10 + frames[9][0] + frames[9][1]
  when strike?(frame)
    if strike?(next_frame)
      10 + 10 + frames[idx + 2][0]
    else
      10 + next_frame.sum
    end
  when spare?(frame)
    10 + next_frame[0]
  else
    frame.sum
  end
end

puts point