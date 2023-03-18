Cd(__DIR__);
#include "~/AOC-2021/Common.HC"

#if 0
#define INPUT_FILE "sample.TXT"
#else
#define INPUT_FILE "input.TXT"
#endif

#define N 10

I64 octo[N][N];
Bool flashed[N][N];

U0 PrintOcto()
{
  I64 row, col;
  for (row=0; row<N; ++row) {
    for (col=0; col<N; ++col)
      "%d", octo[row][col];
    "\n";
  }
}

U0 Flash(I64 row, I64 col)
{
  I64 drow, dcol, nrow, ncol;
  for (drow=-1; drow<=1; ++drow)
    for (dcol=-1; dcol<=1; ++dcol)
      if (drow != 0 || dcol != 0){
        nrow = row+drow;
        ncol = col +dcol;
        if (0 <= nrow < N && 0 <= ncol < N) {
          if (!flashed[nrow][ncol])
            octo[nrow][ncol]++;
        }
      }        
}

U0 NextOcto(I64 *flashes)
{
  I64 row, col;
  for (row=0; row<N; ++row)
    for (col=0; col<N; ++col)
      octo[row][col]++;

  MemSet(flashed, 0, sizeof(flashed));

  Bool stop = FALSE;
  while (!stop) {
    stop = TRUE;
    for (row=0; row<N; ++row)
      for (col=0; col<N; ++col)
        if (octo[row][col] > 9) {
          (*flashes)++;
          octo[row][col] = 0;
          flashed[row][col] = TRUE;
          Flash(row, col);
          stop = FALSE;
        }
  }
}

U0 ReadInput()
{
  SV sv, line;
  sv.begin = FileRead(INPUT_FILE, &sv.size);
  U8 *saved_begin = sv.begin;
  I64 row, col;

  row=0;
  while (sv.size > 0) {
    SVChopByDelim(&sv, '\n', &line);

    for (col=0; col < 10; ++col) 
      octo[row][col] = line.begin[col] - '0';
    row++;
  }

  Free(saved_begin);
}

U0 Part1(){
  ReadInput;

  I64 i, flashes = 0;

  for (i=0; i<100; ++i) {
    NextOcto(&flashes);
  }
  "Part 1: %d\n", flashes;

}

U0Part2() {
  ReadInput;

  I64 i, flashes;

  for (i=0; flashes != N*N; ++i) {
    flashes=0;
    NextOcto(&flashes);
  }  

  "Part 2: %d\n", i;
}

#define CELL_SIZE 30

U0 DrawIt(CTask *,CDC *dc)
{
  I64 row, col;
  F64 x, y, w, h;
  F64 t;
  for (row=0; row<N; ++row) {
    for (col=0; col<N; ++col) {
      t = ToF64(octo[row][col])/9.0;
      dc->color=RED;//octo[row][col];
      x = ToF64(col*CELL_SIZE)+CELL_SIZE/2.0*(1.0-t);
      y = ToF64(row*CELL_SIZE)+CELL_SIZE/2.0*(1.0-t);
      w = CELL_SIZE*t;
      h = CELL_SIZE*t;
      
      GrRect(dc, ToI64(x), ToI64(y), ToI64(w), ToI64(h));
    }
  }
}

U0 Visualization()
{
  ReadInput;

  I64 flashes = 0;

  SettingsPush; //See $LK,"SettingsPush",A="MN:SettingsPush"$
  DocClear;
  Fs->draw_it=&DrawIt;
  while (!ScanChar) {
    NextOcto(&flashes);
    Sleep(120);
  }
  SettingsPop;
}


//Part1;
//Part2;
Visualization;
