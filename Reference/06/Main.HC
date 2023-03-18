Cd(__DIR__);
#include "~/AOC-2021/Common.HC"

#if 0
#define INPUT_FILE "sample.TXT"
#else
#define INPUT_FILE "input.TXT"
#endif

#define N 9

I64 table[N];
I64 back_table[N];

I64 CountFish()
{
  I64 i;
  I64 result = 0;
  for (i=0; i<N; ++i) result += table[i];
  return result;
}

U0 DumpTable()
{
  I64 i;
  for (i=0; i<N; ++i) {
    "%2d: %d\n", i, table[i];
  }
}

U0 NextDay()
{
  I64 i;

  MemSet(back_table, 0, sizeof(I64)*N);  

  back_table[8] += table[0];
  back_table[6] += table[0];

  for (i=1; i<N; ++i) {
    back_table[i-1] += table[i];
  }

  MemCpy(table, back_table, sizeof(I64)*N);
}

U0 Main(){
  SV sv;
  sv.begin = FileRead(INPUT_FILE, &sv.size);
  U8 *saved_begin = sv.begin;
  I64 x, i;

  MemSet(table, 0, sizeof(I64)*N);

  while (sv.size > 1) {
    x = SVChopI64(&sv); 
    SVChopLeft(&sv);
 
    table[x]++;
  }

  for (i=0; i<80; ++i) NextDay;
  "Part 1: %d\n", CountFish;
  for (; i<256; ++i) NextDay;
  "Part 2: %d\n", CountFish;

  Free(saved_begin);
}


Main;
