Cd(__DIR__);
#include "~/AOC-2021/Common.HC"

#if 0
#define INPUT_FILE "sample.TXT"
#else
#define INPUT_FILE "input.TXT"
#endif

class Point {
  I64 x, y;
};

#define PS_CAP 1024
Point ps[PS_CAP];
I64 ps_cnt;

class Fold {
  I32 axis; // 'x' or 'y'
  I32 value;
};

#define FLDS_CAP 64
Fold flds[FLDS_CAP];
I64 flds_cnt;

#define CVS_CAP 2048
I64 cvs[CVS_CAP][CVS_CAP];


U0 BoundaryPs(Point *min, Point *max)
{
  I64 i;
  min->x = I64_MAX;
  min->y = I64_MAX;
  max->x = I64_MIN;
  max->y = I64_MIN;
  for (i=0; i<ps_cnt; ++i) {
    min->x = MinI64(min->x, ps[i].x);
    min->y = MinI64(min->y, ps[i].y);
    max->x = MaxI64(max->x, ps[i].x);
    max->y = MaxI64(max->y, ps[i].y);
  }
}

I64 RenderPs()
{
  Point min, max;
  BoundaryPs(&min, &max);
  I64 i, x, y;
  I64 w = max.x - min.x + 1;
  I64 h = max.y - min.y +1;
  MemSet(cvs, 0, sizeof(cvs));
  for (i=0; i<ps_cnt; ++i) {
    cvs[ps[i].y - min.y][ps[i].x - min.x] = 1;
  }

  I64 count = 0;
  for (y=0; y<h; ++y) {
    for (x=0; x<w; ++x) {
      if (cvs[y][x]) {
        count++;
        "#"; 
      } else " ";
    }
    "\n";
  }
  return count;
}


U0 FoldAlongY(I64 y0)
{
  I64 i;
  for (i=0; i<ps_cnt; ++i){
    if (ps[i].y > y0){
      ps[i].y = y0 - (ps[i].y - y0);
    }
  }  
}

U0 FoldAlongX(I64 x0)
{
  I64 i;
  for (i=0; i<ps_cnt; ++i){
    if (ps[i].x > x0){
      ps[i].x = x0 - (ps[i].x - x0);
    }
  }  
}

U0 FoldPs(Fold *fld)
{
  switch (fld->axis) {
  case 'x': FoldAlongX(fld->value); break;
  case 'y':FoldAlongY(fld->value); break;
  }
}


U0 ReadInput()
{
  SV sv, skip;
  sv.begin = FileRead(INPUT_FILE, &sv.size);
  U8 *saved_begin = sv.begin;

  ps_cnt=0;
  while (sv.size> 0 && sv.begin[0] != '\n') {
    ps[ps_cnt].x = SVChopI64(&sv); SVChopLeft(&sv);
    ps[ps_cnt].y = SVChopI64(&sv); SVChopLeft(&sv);
    ps_cnt++;
  }

  SVChopLeft(&sv);

  flds_cnt=0;
  while (sv.size >1) {
    SVChopByDelim(&sv, ' ', &skip); // "fold"
    SVChopByDelim(&sv, ' ', &skip); // "along"

    flds[flds_cnt].axis = sv.begin[0];
    SVChopByDelim(&sv, '=', &skip);
    flds[flds_cnt].value = SVChopI64(&sv);
    flds_cnt++;

    SVChopLeft(&sv);
  }  

  Free(saved_begin);  
}

I64 CountUniquePs()
{
  MemSet(cvs, 0, sizeof(cvs));
  I64 i, count =0;
  for (i=0; i<ps_cnt; ++i)
    if (!cvs[ps[i].y][ps[i].x]) {
      cvs[ps[i].y][ps[i].x] = 1;
      count++;
    }
  return count;
}

U0 Part1(){
  ReadInput;
  FoldPs(&flds[0]);
  "Part 1:%d\n", CountUniquePs;
}

U0 Part2(){
  ReadInput;
  I64 i;
  for (i=0; i<flds_cnt; ++i)
    FoldPs(&flds[i]);
  "Part 2:\n";
  RenderPs;
}

Part1;
Part2;
