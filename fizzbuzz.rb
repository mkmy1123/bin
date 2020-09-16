#!/usr/bin/env ruby
# frozen_string_literal: true

def fizz_buzz(int)
  if (int % 15).zero?
    'FizzBuzz'
  elsif (int % 3).zero?
    'Fizz'
  elsif (int % 5).zero?
    'Buzz'
  else
    int
  end
end

1.upto(100) { |int| puts fizz_buzz(int) }
