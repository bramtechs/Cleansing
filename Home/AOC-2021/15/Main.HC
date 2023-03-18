Cd(__DIR__);
#include "~/AOC-2021/Common.HC"

#if 0
#define INPUT_FILE "sample.TXT"
#else
#define INPUT_FILE "input.TXT"
#endif

#define MAP_CAP 128

I64 map[MAP_CAP][MAP_CAP];
I64 map_h, map_w;
I64 dp[MAP_CAP*5][MAP_CAP*5];


#define Q_CAP 100000
I64 q[Q_CAP][2];
I64 qs;
I64 qb;

U0 CleanQ()
{
   qb = 0;
   qs = 0;
}

U0 Nq(I64 i, I64 j)
{
  I64 place;
  if (qs < Q_CAP) {
    place = (qb+qs)%Q_CAP;
    q[place][0] = i;
    q[place][1] = j;
    qs++;
  } else "QOVERFLOW!!!!!\n";
}

U0 Dq(I64 *i, I64 *j)
{
  if (qs > 0) {
    *i = q[qb][0];
    *j = q[qb][1];
    qb = (qb +1)%Q_CAP;
    qs--;
  } else "QUNDERFLOW!!!!!\n";
}

#define NBORS_CNT 4
I64 nbors[NBORS_CNT][2] = {
  {-1, 0},
  {0, -1},
  {1, 0},
  {0, 1}
};

U0 ReadInput()
{
  SV sv, line;
  sv.begin = FileRead(INPUT_FILE, &sv.size);
  U8 *saved_begin = sv.begin;

  for (map_h=0; sv.size >1; ++map_h) {
    SVChopByDelim(&sv, '\n', &line);
    for (map_w=0; map_w<line.size; ++map_w) {
      map[map_h][map_w] = line.begin[map_w] - '0';
    }
  }

  Free(saved_begin);  
}

U0 Part1(){
  ReadInput;

  I64 ci,cj;
  I64 i, j, n;

  MemSetI64(dp, I64_MAX, map_w*map_h);
  dp[0][0] = 0;

  CleanQ;
  Nq(0, 0);
  while (qs >0){
    Dq(&ci, &cj);
    for (n=0; n<NBORS_CNT; ++n) {
      i = ci+nbors[n][0];
      j = cj+nbors[n][1];
      if (0 <= i < map_h)
        if (0 <= j < map_w)
          if (dp[ci][cj] +map[i][j] < dp[i][j]) {
            dp[i][j] = dp[ci][cj] +map[i][j];
            Nq(i, j);
          }
    }        
  }

  "Part 1:%d\n", dp[map_h-1][map_w-1];  
}

I64 WrapOne(I64 x)
{
  return (x-1)%9+1;
}

I64 BigMap(I64 i, I64 j)
{
  return WrapOne(map[i%map_h][j%map_w] +j/map_w +i/map_h);
}

U0Part2() {
  ReadInput;

  I64 dp_w = map_w*5, dp_h = map_h*5;
  I64 ci,cj;
  I64 i, j, n;

  for (i=0; i<dp_h; ++i)
    for (j=0; j<dp_w; ++j)
      dp[i][j] = I64_MAX;
  dp[0][0] = 0;

  CleanQ;
  Nq(0, 0);
  while (qs >0){
    Dq(&ci, &cj);
    for (n=0; n<NBORS_CNT; ++n) {
      i = ci+nbors[n][0];
      j = cj+nbors[n][1];
      if (0 <= i < dp_h)
        if (0 <= j < dp_w)
          if (dp[ci][cj] +BigMap(i, j) < dp[i][j]) {
            dp[i][j] = dp[ci][cj] +BigMap(i, j);
            Nq(i, j);
          }
    }        
  }

  "Part 2:%d\n", dp[dp_h-1][dp_w-1];  
}

Part1;
Part2;