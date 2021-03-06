#!/usr/bin/env ruby
# frozen_string_literal: true

def main(string_score)
  frames = build_frames(string_score)
  calc_point(frames)
end

def build_frames(string_score)
  scores = string_score.chars

  frames = Array.new(9) { [0, 0] }
  frames.push([0, 0, 0])

  frame_number = 0
  frame_first_throw = true
  final_throw = false

  scores.each do |score_char|
    score = to_integer(score_char)
    if final_frame?(frame_number)
      if frame_first_throw
        frames[9][0] = score
        frame_first_throw = false
      elsif !final_throw
        frames[9][1] = score
        final_throw = true
      else
        frames[9][2] = score
      end
    elsif frame_first_throw
      frames[frame_number][0] = score
      case score
      when 10
        frame_number += 1
        frame_first_throw = true
      else
        frame_first_throw = false
      end
    else
      frames[frame_number][1] = score
      frame_number += 1
      frame_first_throw = true
    end
  end
  frames
end

def calc_point(frames)
  frames.each_with_index.sum do |current_frame, current_frame_number|
    next_frame_number = current_frame_number + 1
    next_frame = frames[next_frame_number]
    case
    when final_frame?(current_frame_number)
      current_frame.sum
    when final_frame?(next_frame_number) && strike?(current_frame)
      10 + next_frame[0..1].sum
    when strike?(current_frame)
      if strike?(next_frame)
        10 + 10 + frames[next_frame_number + 1][0]
      else
        10 + next_frame.sum
      end
    when spare?(current_frame)
      10 + frames[next_frame_number][0]
    else
      current_frame.sum
    end
  end
end

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

puts main(ARGV[0])
