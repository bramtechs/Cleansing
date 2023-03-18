Cd(__DIR__);
#include "~/AOC-2021/Common.HC"

#if 0
#define INPUT_FILE "sample.TXT"
#else
#define INPUT_FILE "input.TXT"
#endif

#define LINES_CAP 128

SV lines[LINES_CAP];
I64 lines_cnt;
Bool visited[LINES_CAP][LINES_CAP];

#define ROW 0
#define COL 1
#define DIRS_CNT 4

I64 dirs[DIRS_CNT][2] = {
  {-1,  0},
  { 0, -1},
  { 1,  0},
  { 0,  1}
};

Bool IsLowPoint(I64 row0, I64 col0)
{
  I64 i, n, p, row, col;
  p = lines[row0].begin[col0];
  for (i=0; i<DIRS_CNT; ++i) {
    row = row0 + dirs[i][ROW];
    col = col0 + dirs[i][COL];
    if (0 <= row < lines_cnt)
      if (0 <= col < lines[0].size) {
        n = lines[row].begin[col];
        if (n <=p) return FALSE;
      }
  }
  return TRUE;
}

U0 ReadInput(){
  SV sv;
  sv.begin = FileRead(INPUT_FILE, &sv.size);
  U8 *saved_begin = sv.begin;

  lines_cnt = 0;
  while(sv.size >1) {
    SVChopWord(&sv, &lines[lines_cnt]);
    SVChopLeft(&sv);
    lines_cnt++;
  }  

  Free(saved_begin);
}

U0 Part1(){
  ReadInput;

  I64 row, col, answer;

  answer = 0;
  for (row=0; row<lines_cnt; ++row)
    for (col=0; col<lines[0].size; ++col) {
      if (IsLowPoint(row, col)) {
        answer += lines[row].begin[col] - '0' +1;
      }
    }

  "Part 1:%d\n", answer;
}

U0 DFS(I64 row0, I64 col0, I64 *size) {
  if (visited[row0][col0]) return;
  visited[row0][col0] = TRUE;
  (*size)++;

  I64 i, p, n, row, col;
  p = lines[row0].begin[col0];
  for (i=0; i<DIRS_CNT; ++i) {
    row = row0 + dirs[i][ROW];
    col = col0 + dirs[i][COL];
    if (0 <= row < lines_cnt)
      if (0 <= col < lines[0].size) {
        n = lines[row].begin[col];
        if (n >= p &&n < '9') DFS(row, col, size);
      }
  }  
}
U0 VisitedMap() {
  I64 row, col;
  for (row=0; row < lines_cnt; ++row) {
    for (col=0; col <lines[0].size; ++col)
      if (visited[row][col]) "*"; else ".";
    "\n";
  }
}

U0 HeightMap() {
  I64 row, col;
  for (row=0; row < lines_cnt; ++row) {
    for (col=0; col <lines[0].size; ++col)
      "%c", lines[row].begin[col];
    "\n";
  }
}

#define BASINS_CAP (LINES_CAP*LINES_CAP)
I64 basins[BASINS_CAP];
I64 basins_cnt;

I64 RevCmp(I64 a, I64 b)
{
   return b - a;
}

U0Part2() {
  ReadInput;
  MemSet(visited, 0, sizeof(visited));


  I64 row, col, size;
  basins_cnt = 0;
  for (row=0; row<lines_cnt; ++row)
    for (col=0; col<lines[0].size; ++col)
      if (IsLowPoint(row, col)) {
        size = 0;
        DFS(row, col, &size);
        basins[basins_cnt++] = size;
      }

  QSortI64(basins, basins_cnt, &RevCmp);
  "Part 2:%d\n", basins[0]*basins[1]*basins[2];
}

Part1;
Part2;