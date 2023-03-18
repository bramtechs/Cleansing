Cd(__DIR__);
#include "~/AOC-2021/Common.HC"

#if 0
#define INPUT_FILE "sample.TXT"
#else
#define INPUT_FILE "input.TXT"
#endif

#define UPPER_BOUND 2000

I64 table[UPPER_BOUND];

U0 DumpTable()
{
  I64 i;
  for (i=0; i<UPPER_BOUND; ++i)
    if (table[i] > 2)
       "%4d: %d\n", i, table[i];
}

I64 FuelCount1(I64 align)
{
  I64 i;
  I64 result = 0;

  for (i=0; i<UPPER_BOUND; ++i)
    result += AbsI64(align-i)*table[i];

  return result;
}

I64 FuelCount2(I64 align)
{
  I64 i, n, fuel;
  I64 result=0;

  for (i=0; i<UPPER_BOUND; ++i) {
    n = AbsI64(align-i);
    fuel = (n*(n+1))/2;
    result += fuel*table[i];
  }

  return result;
}

U0 ReadInput() {
  SV sv;
  sv.begin = FileRead(INPUT_FILE, &sv.size);
  U8 *saved_begin = sv.begin;
  I64 x;

  MemSet(table, 0, sizeof(table));

  while (sv.size > 1) {
    x = SVChopI64(&sv); SVChopLeft(&sv);
    table[x]++;
  }

  Free(saved_begin);
}

U0 Part1(){
  I64 i;
  I64 result=I64_MAX;

  ReadInput;

  for (i=0; i<UPPER_BOUND; ++i)
    if (table[i]>0)
      result = MinI64(result, FuelCount1(i));

  "Part 1:%d\n", result;
}

U0Part2() {
  I64 i;
  I64 result=I64_MAX;

  ReadInput;

  for (i=0; i<UPPER_BOUND; ++i)
    result = MinI64(result, FuelCount2(i));
 

  "Part 2:%d\n", result;
}

Part1;
Part2;