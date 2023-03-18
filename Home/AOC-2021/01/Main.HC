Cd(__DIR__);
#include "~/AOC-2021/Common.HC"


U0 part1() {
  I64 x;
  
  SV sv;
  sv.begin = FileRead("input.TXT", &sv.size);
  U8 *saved_begin = sv.begin;
  
  I64 answer = 0;
  I64 prev = -1;
  
  while (sv.size > 1) {
    x = SVChopI64(&sv);
    if (prev >= 0 && x > prev) answer++;
    prev = x;
  }
  
  Free(saved_begin);
  
  "Part 1: %d\n", answer;
}

U0 part2() {
  SV sv;
  sv.begin = FileRead("input.TXT", &sv.size);
  U8 *saved_begin = sv.begin;
  
  I64 answer = 0;
  
  I64 a,b,c,d;
  a = SVChopI64(&sv);
  b = SVChopI64(&sv);
  c = SVChopI64(&sv);
  
  while (sv.size > 1) {
    d = SVChopI64(&sv);
    if (b+c+d > a+b+c) answer++;
    a = b;
    b = c;
    c = d;
  }
  
  Free(saved_begin);
  
  "Part 2: %d\n", answer;
}

part1;
part2;
// Hello from God's Temple!