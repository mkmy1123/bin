#!/usr/bin/env ruby
# 1から100までの数をプリントするプログラムを書け。ただし3の倍数のときは数の代わりに｢Fizz｣と、5の倍数のときは｢Buzz｣とプリントし、3と5両方の倍数の場合には｢FizzBuzz｣とプリントすること。

def fizz_buzz(int)
  case
  when int % 15 == 0
    "FizzBuzz"
  when int % 3 == 0
    "Fizz"
  when int % 5 == 0
    "Buzz"
  else
    int
  end
end

1.upto(100){ |int| puts fizz_buzz(int) }
