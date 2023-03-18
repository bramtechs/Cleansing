Cd(__DIR__);
#include "~/AOC-2021/Common.HC"

#if 0
// target area: x=20..30, y=-10..-5
#define INPUT_FILE "sample.TXT"
#define MINX 20
#define MINY -10
#define MAXX 30
#define MAXY -5
#else
// target area: x=175..227, y=-134..-79
#define INPUT_FILE "input.TXT"
#define MINX 175
#define MAXX 227
#define MINY -134
#define MAXY -79
#endif

Bool InTarget(I64 x, I64 y)
{
  return (MINX <= x <= MAXX) && (MINY <= y <= MAXY);
}

Bool Simulate(I64 vx, I64 vy, I64 *maxh)
{
  I64 x = 0;
  I64 y = 0;

  *maxh = I64_MIN;

  while (!InTarget(x, y) && x <= MAXX && y >= MINY) {
    *maxh = MaxI64(*maxh, y);
    x  += vx;
    y  += vy;
    vx += -SignI64(vx);
    vy += -1;
  }

  return InTarget(x, y);
}

U0 Main(){
  SV sv;
  sv.begin = FileRead(INPUT_FILE, &sv.size);
  U8 *saved_begin = sv.begin;

  I64 maxh;
  I64 vx, vy;
  Bool success;
  I64 amaxh = I64_MIN;
  I64 avx = I64_MIN;
  I64 avy = I64_MIN;
  I64 count = 0;

  for (vy=MINY; vy<=2000; ++vy) {
    for (vx=1; vx<=MAXX+1; ++vx) {
      success = Simulate(vx, vy, &maxh);
      if (success) {
        count++;
        if (amaxh < maxh) {
          avx = vx;
          avy = vy;
          amaxh = maxh;
        }
      }
    }
  }

  "Part 1: %d\n", amaxh;
  "Part 2:%d\n", count;

  Free(saved_begin);
}

Main;
