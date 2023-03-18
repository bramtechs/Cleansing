Cd(__DIR__);
#include "~/AOC-2021/Common.HC"

#if 0
#define INPUT_FILE "sample.TXT"
#else
#define INPUT_FILE "input.TXT"
#endif

// Unique
// 1:2
// 4:4
// 7: 3
// 8:7

// Not very unique
// 2:5
// 3: 5
// 5: 5
// 0: 6
// 6:6
// 9:6


//  0
// 1 2
//  3
// 4 5
//  6

//  -
// | 
//  -
//   |
//  -
#define DIGITS_CNT 10

I64 digit_masks[DIGITS_CNT] = {
  //6543210
  0b1110111, // 0
  0b0100100, // 1
  0b1011101, // 2
  0b1101101, // 3
  0b0101110, // 4
  0b1101011, // 5
  0b1111011, // 6
  0b0100101, // 7
  0b1111111, // 8
  0b1101111  // 9
};

#define SEGS_SIZE 7

I64 Decode(U8 *segs, SV *wire)
{
  I64 mask = 0;
  I64 i, j;

  for (i=0; i<wire->size; ++i) {
    for (j=0; j<SEGS_SIZE; ++j) {
      if (segs[j] == wire->begin[i]) {
        mask |= (1<<j);
      }
    }
  }

  for (i=0; i<DIGITS_CNT; ++i) {
    if (digit_masks[i] == mask) {
      return i;
    }
  }

  return -1;
}

U0 Part1(){
  SV sv, word;
  sv.begin = FileRead(INPUT_FILE, &sv.size);
  U8 *saved_begin = sv.begin;
  I64 i, count=0;

  while (sv.size> 1) {
    for (i=0; i<10; ++i) {
      SVChopWord(&sv, &word);
      SVChopLeft(&sv);
    }

    SVChopLeft(&sv, 2);

    for (i=0; i<4; ++i) {
      SVChopWord(&sv, &word);
      SVChopLeft(&sv);
      switch(word.size) {
        case 2: case 4: case 3: case 7:
          count++;
          break;
      }
    }      
  }

  "Part 1: %d\n", count;

  Free(saved_begin);
}

#define SEGS_CNT 5040

SV all_segs[SEGS_CNT];

U0 ReadAllSegs()
{
  SV sv;
  sv.begin = FileRead("segs.TXT", &sv.size);  
  U8 *saved_begin = sv.begin;
  I64 cnt;

  for (cnt = 0; sv.size >1; ++cnt){
    SVChopWord(&sv, &all_segs[cnt]);
    SVChopLeft(&sv); 
  }

  "%d segs read\n", cnt;

  Free(saved_begin);
}

SV wires[DIGITS_CNT];

Bool VerifySegs(U8 *segs)
{
  I64 i;
  for (i = 0; i <DIGITS_CNT; ++i)
    if (Decode(segs, &wires[i]) < 0)
       return FALSE;
  return TRUE;
}

U0Part2() {
  ReadAllSegs;

  SV sv, word;
  sv.begin = FileRead(INPUT_FILE, &sv.size);
  U8 *saved_begin = sv.begin;
  I64 i, j;
  I64 value;
  I64 answer = 0;
  
  while (sv.size> 1) {
    for (i=0; i<10; ++i) {
      SVChopWord(&sv, &wires[i]);
      SVChopLeft(&sv);
    }

    for (i=0; i<SEGS_CNT; ++i) {
      if (VerifySegs(all_segs[i].begin)) {
        break;
      }
    }


    if (i >= SEGS_CNT) {
      "Unreachable\n";
      return;
    }

    SVChopLeft(&sv, 2);

    value = 0;
    for (j=0; j<4; ++j) {
      SVChopWord(&sv, &word);
      SVChopLeft(&sv);
      value = value *10 +Decode(all_segs[i].begin, &word);
    }      
    answer += value;
  }

  "Part 2: %d\n", answer;

  Free(saved_begin);
  

}

Part1;
Part2;