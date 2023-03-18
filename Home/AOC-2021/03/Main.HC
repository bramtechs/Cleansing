Cd(__DIR__);
#include "~/AOC-2021/Common.HC"

#if 1
#define BITS_COUNT 12
#define INPUT_FILE "./input.TXT"
#else
#define BITS_COUNT 5
#define INPUT_FILE "./sample.TXT"
#endif

I64 bits[BITS_COUNT][2];

U0 part1() {
  SV sv;
  I64 x, i;
  sv.begin = FileRead(INPUT_FILE, &sv.size);
  U8 *saved_begin = sv.begin;
  I64 gamma = 0, epsilon = 0;

  MemSetI64(bits, 0, 2*BITS_COUNT);

  while (sv.size > 1){
    x = SVChopI64(&sv, 2);

    for (i=0; i<BITS_COUNT; ++i) {
      bits[i][(x>>i)&1]++;
    }
  }


  for (i=0; i<BITS_COUNT; ++i) {
    if (bits[i][0] < bits[i][1]) {
      gamma   |= 1<<i;
      epsilon&= ~(1<<i);
    } else if (bits[i][0] >bits[i][1]) {
      gamma   &= ~(1<<i);
      epsilon |= 1<<i;
    } else {
      "unreachable\n";
    }
  }
  
  "gamma:%d\n", gamma;
  "epsilon: %d\n", epsilon;
  "Part 1: %d\n", gamma*epsilon;

  Free(saved_begin);
}

#define XS_CAP 1024
I64 xs[XS_CAP];
Bool xs_removed[XS_CAP];
I64 xs_sz = 0;
I64 xs_cnt = 0;

U0 ReadXs() {
  SV sv;
  I64 x;
  sv.begin = FileRead(INPUT_FILE, &sv.size);
  U8 *saved_begin = sv.begin;

  xs_sz = 0;

  while (sv.size > 1){
    x = SVChopI64(&sv, 2);

    xs[xs_sz] = x;
    xs_removed[xs_sz] = FALSE;
    xs_sz++;
  }

  xs_cnt = xs_sz;

  Free(saved_begin);  
}

U0 BitsOfXs(I64 bit_number, I64 *bits) {
  I64 i;
  MemSetI64(bits, 0, 2);
  for (i=0; i <xs_sz;++i) {
    if (!xs_removed[i]) {
      bits[(xs[i]>>bit_number)&1]++;
    }
  }
}

U0 DumpXs() {
  I64 i, j;
  for (i=0; i <xs_sz; ++i) {
    if (!xs_removed[i]) {
      for (j=BITS_COUNT-1; j >= 0; --j) {
        "%c", ((xs[i]>>j)&1)+'0';
      }
      ": %d\n", xs_removed[i];
    }
  }
}

I64 SearchValue(Bool common=TRUE) {
  I64 i, j=0;
  I64 bit_number = BITS_COUNT-1;
  I64 bits[2];
  I64 bit;

  MemSet(xs_removed, 0, XS_CAP*sizeof(Bool));
  xs_cnt = xs_sz;

  while (xs_cnt > 1) {
    BitsOfXs(bit_number, bits);
    for (i=0; i <xs_sz; ++i) {
      if (!xs_removed[i]) {
        bit = (xs[i]>>bit_number)&1;
        if (common) {
          if ((bits[1] >= bits[0]) != (bit == 1)) {
            xs_removed[i] = TRUE;
            xs_cnt--;
          }
        } else {
          if ((bits[1] >= bits[0]) == (bit == 1)) {
            xs_removed[i] = TRUE;
            xs_cnt--;
          }
        }
      }
    }  
    bit_number--;
    j += 1;

  }  

  for (i=0; i < xs_sz; ++i) {
    if (!xs_removed[i]) {
      return xs[i];
    }
  }
}

U0 part2() {
  ReadXs;
  I64 oxygen = SearchValue;
  I64 co2 = SearchValue(FALSE);
  "oxygen: %d\n", oxygen;
  "co2:    %d\n", co2;
  "Part 2: %d\n", oxygen*co2;
}

part1;
part2;