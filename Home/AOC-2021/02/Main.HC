Cd(__DIR__);
#include "~/AOC-2021/Common.HC"

U0 part1() {
  SV sv, word;
  sv.begin = FileRead("./input.TXT", &sv.size);
  U8 *saved_begin = sv.begin;
  I64 x;
  I64 pos = 0, depth = 0;
  

  while (sv.size > 1) {
    SVTrimLeft(&sv);
    SVChopWord(&sv, &word);
    x = SVChopI64(&sv);

    switch(word.size) {
       case 2: // up
          depth -= x;
          break;

       case 4: // down
          depth += x;
          break;

       case 7: // forward
          pos += x;
          break;

       default:
          "Unreachable:%d\n", sv.size;
          return;
    }
  }

  Free(saved_begin);

  "Part 1: %d\n", pos *depth;
}

U0 part2() {
  SV sv, word;
  sv.begin = FileRead("./input.TXT", &sv.size);
  U8 *saved_begin = sv.begin;
  I64 x;
  I64 pos = 0, depth = 0, aim = 0;
  

  while (sv.size > 1) {
    SVTrimLeft(&sv);
    SVChopWord(&sv, &word);
    x = SVChopI64(&sv);

    switch(word.size) {
       case 2: // up
          aim -= x;
          break;

       case 4: // down
          aim += x;
          break;

       case 7: // forward
          pos += x;
          depth += aim * x;
          break;

       default:
          "Unreachable:%d\n", sv.size;
          return;
    }
  }

  Free(saved_begin);

  "Part 2: %d\n", pos *depth;
}

part1;
part2;