Cd(__DIR__);
#include "~/AOC-2021/Common.HC"

#if 0
#define INPUT_FILE "sample.TXT"
#define BOARD_SZ 10

I64 board[BOARD_SZ][BOARD_SZ];

U0 DumpBoard() {
  I64 x, y;
  for (y=0; y<BOARD_SZ; ++y) {
    for (x=0; x<BOARD_SZ; ++x) {
      if (board[y][x])
        "%d ", board[y][x];
      else
        ". ";
    }
    "\n";
  }
}

#else
#define INPUT_FILE"input.TXT"
#define BOARD_SZ 1010

I64 board[BOARD_SZ][BOARD_SZ];

U0 DumpBoard() {}

#endif


U0 DrawLine(I64 x1, I64 y1, I64 x2, I64 y2) {
  I64 x, y, i;
  I64 n = MaxI64(AbsI64(x2-x1)+1, AbsI64(y2-y1)+1);
  
  for (i=0; i<n; ++i) {
    x=x1+SignI64(x2-x1)*i;
    y=y1+SignI64(y2-y1)*i;
    board[y][x]++;
  }
}

U0 part1() {
  SV sv;
  sv.begin = FileRead(INPUT_FILE, &sv.size);
  U8 *saved_begin = sv.begin;
  I64 x1, y1, x2, y2, x, y;

  MemSet(board, 0, sizeof(I64)*BOARD_SZ*BOARD_SZ);

  while (sv.size >1) {
    x1 = SVChopI64(&sv); SVChopLeft(&sv);
    y1 = SVChopI64(&sv); SVChopLeft(&sv, 4);
    x2 = SVChopI64(&sv); SVChopLeft(&sv);
    y2 = SVChopI64(&sv); SVChopLeft(&sv);

    if (x1 == x2 ||y1 == y2) DrawLine(x1, y1, x2, y2);
  }

  DumpBoard;

  I64 answer = 0;
  
  for (y=0; y<BOARD_SZ; ++y)
    for (x=0; x<BOARD_SZ; ++x)
      if (board[y][x] > 1)
        ++answer;

  "Part 1: %d\n", answer;

  Free(saved_begin);
}

U0 part2() {
  SV sv;
  sv.begin = FileRead(INPUT_FILE, &sv.size);
  U8 *saved_begin = sv.begin;
  I64 x1, y1, x2, y2, x, y;

  MemSet(board, 0, sizeof(I64)*BOARD_SZ*BOARD_SZ);

  while (sv.size >1) {
    x1 = SVChopI64(&sv); SVChopLeft(&sv);
    y1 = SVChopI64(&sv); SVChopLeft(&sv, 4);
    x2 = SVChopI64(&sv); SVChopLeft(&sv);
    y2 = SVChopI64(&sv); SVChopLeft(&sv);

    DrawLine(x1, y1, x2, y2);
  }

  DumpBoard;

  I64 answer = 0;
  
  for (y=0; y<BOARD_SZ; ++y)
    for (x=0; x<BOARD_SZ; ++x)
      if (board[y][x] > 1)
        ++answer;

  "Part 2: %d\n", answer;

  Free(saved_begin);
}

part1;
part2;