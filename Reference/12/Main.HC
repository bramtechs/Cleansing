Cd(__DIR__);
#include "~/AOC-2021/Common.HC"

#if 0
#define INPUT_FILE "sample.TXT"
#else
#define INPUT_FILE "input.TXT"
#endif

#define BUF_CAP (4 *1024)

U8 buf[BUF_CAP];
I64 buf_sz = 0;

U0BufAppend(U8 *buf0, I64 buf0_sz)
{
  if (buf_sz + buf0_sz <= BUF_CAP) {
    MemCpy(buf+buf_sz, buf0, buf0_sz);
    buf_sz += buf0_sz;
  }
}

U0 BufAppendNul(U8 *s)
{
  BufAppend(s, StrLen(s));
}

#define VERT_CAP 16
Bool graph[VERT_CAP][VERT_CAP];
Bool visited[VERT_CAP];
SV verts[VERT_CAP];
I64 verts_sz;
I64 vstart;
I64 vend;

Bool IsBig(I64 vert)
{
  I64 x = verts[vert].begin[0];
  return 'A' <= x <= 'Z';
}

U0 DumpGraph()
{
  I64 i,j;
  "\n";
  for (i=0; i<verts_sz; ++i) {
    for(j=0; j<verts_sz; ++j) "%2d", graph[i][j];
    "\n\n";
  }
}

I64 VertIndex(SV *name)
{
  I64 i;
  for (i=0; i<verts_sz; ++i)
    if (SVEq(name, &verts[i]))
      return i;
  
  MemCpy(&verts[verts_sz], name, sizeof(SV));
  return verts_sz++;
}

U0 DFS1(I64 a, I64 *count)
{
  if (a==vend){
    (*count)++;
    return;
  } 


  I64 i;
  for (i=0; i<verts_sz;++i) {
    if (graph[a][i] && !visited[i]) {
      if (!IsBig(i)) visited[i] = TRUE;
      DFS1(i, count);
      visited[i] = FALSE;
    }
  }
}

U0 ReadInput()
{
  SV sv, a, b;
  sv.begin = FileRead(INPUT_FILE, &sv.size);
  U8 *saved_begin = sv.begin;
  I64 a_idx, b_idx;

  verts_sz = 0;
  MemSet(graph, 0, sizeof(graph));
  while (sv.size >1) {
    SVChopByDelim(&sv, '\n', &b);
    SVChopByDelim(&b, '-', &a);
    a_idx = VertIndex(&a);
    b_idx = VertIndex(&b);
    graph[a_idx][b_idx] = TRUE;
    graph[b_idx][a_idx] = TRUE;
  }

  a.begin = "start";
  a.size = 5;
  b.begin = "end";
  b.size = 3;
  vstart = VertIndex(&a);
  vend = VertIndex(&b);
  Free(saved_begin);
}

U0 Part1(){
  ReadInput;
  I64 count = 0;
  MemSet(visited, 0, sizeof(visited));
  visited[vstart] = TRUE;
  DFS1(vstart, &count);
  "Part 1: %d\n", count;  

}

U0 DFS2(I64 a, Bool twice, I64 *count)
{
  if (a==vend){
    (*count)++;
    return;
  } 


  I64 i;
  for (i=0; i<verts_sz;++i) {
    if (graph[a][i]) {
      if (IsBig(i)) {
        DFS2(i, twice, count);
      } else if (!visited[i]) {
        visited[i] = TRUE;
        DFS2(i, twice, count);
        visited[i] = FALSE;
      } else if (!twice && i!=vstart) {
        DFS2(i, TRUE, count);
      }
    }
  }
}

U0Part2() {
  ReadInput;
  I64 count = 0;
  MemSet(visited, 0, sizeof(visited));
  visited[vstart] = TRUE;
  DFS2(vstart, FALSE, &count);
  "Part 2:%d\n", count;
}

Part1;
Part2;