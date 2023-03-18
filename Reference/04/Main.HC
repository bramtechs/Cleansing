Cd(__DIR__);
#include "~/AOC-2021/Common.HC"

#if 0
#define INPUT_FILE"sample.TXT"
#else
#define INPUT_FILE"input.TXT"
#endif

#define NUMS_CAP 128

I64 nums[NUMS_CAP];
I64 nums_sz = 0;

#define BOARD_SZ 5
union Board {
  I64 s[BOARD_SZ][BOARD_SZ];
  I64 l[BOARD_SZ*BOARD_SZ];
};

#define VALUE 0
#define CROSSED 1

U0 BoardDump(Board *board) {
  I64 i, j, cell;
  for (i=0; i<BOARD_SZ; ++i) {
    for (j=0; j<BOARD_SZ; ++j) {
      cell = board->s[i][j];
      if (cell.u8[CROSSED]) {
        "[%*d] ", 2, cell.u8[VALUE];
      } else {
        " %*d  ", 2, cell.u8[VALUE];
      }
    }
    "\n";
  }
}

U0 BoardCross(Board *board, U8 x) {
  I64 i;
  for (i=0; i<BOARD_SZ*BOARD_SZ; ++i)
    if (board->l[i].u8[VALUE] == x)
      board->l[i].u8[CROSSED] = TRUE; 
}

Bool BoardWon(Board *board) {
  I64 i, j;
  for (i=0; i<BOARD_SZ; ++i){
    j=0;
    while (j<BOARD_SZ && board->s[i][j].u8[CROSSED]) {++j;}
    if (j >= BOARD_SZ) return TRUE;

    j=0;
    while (j<BOARD_SZ && board->s[j][i].u8[CROSSED]) {++j;}
    if (j >= BOARD_SZ) return TRUE;
  }

  return FALSE;
}

I64 BoardSum(Board *board)
{
  I64 i, result;
  result=0;
  for (i=0; i<BOARD_SZ*BOARD_SZ; ++i)
    if (!board->l[i].u8[CROSSED]) 
      result += board->l[i].u8[VALUE];
  return result;
}

#define BOARD_CAP 128
Board boards[BOARD_CAP];
I64 boards_sz = 0;


U0 ReadInput() {
  I64 i;
  SV sv;
  sv.begin = FileRead(INPUT_FILE, &sv.size);
  U8 *saved_begin = sv.begin;

  nums_sz = 0;
  while (sv.size > 1 && *sv.begin != '\n') {
    nums[nums_sz++] = SVChopI64(&sv);
    SVChopLeft(&sv);
  }

  SVChopLeft(&sv);

  boards_sz = 0;
  while (sv.size >1) {
    for (i=0; i<BOARD_SZ*BOARD_SZ; ++i) {
      boards[boards_sz].l[i] = SVChopI64(&sv);
    }
    boards_sz++;
  }    

  Free(saved_begin);
}

U0 part1() {
  I64 i, j;
  ReadInput;
  for (i=0; i<nums_sz; ++i) {
    for (j=0; j<boards_sz; ++j) {
      BoardCross(&boards[j], nums[i]);
      if (BoardWon(&boards[j])) {
        "Part 1: %d\n", BoardSum(&boards[j])*nums[i];
        return;
      }
    }
  }
  "Unreachable\n";
}

U0 part2() {
  I64 i, j;
  I64 won_cnt = 0;
  ReadInput; 
  for (i=0; i<nums_sz; ++i) {
    for (j=0; j<boards_sz; ++j) {
      if (!BoardWon(&boards[j])) {
        BoardCross(&boards[j], nums[i]);
        if (BoardWon(&boards[j])) {
          won_cnt++;
          if (won_cnt >= boards_sz) {
            "Part 2: %d\n", BoardSum(&boards[j])*nums[i];
            return;
          }
        }
      }
    }
  }
  "Unreachable\n";
}

part1;
part2;
