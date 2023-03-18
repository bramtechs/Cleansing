Cd(__DIR__);
#include "~/AOC-2021/Common.HC"

#if 0
#define INPUT_FILE "sample.TXT"
#else
#define INPUT_FILE "input.TXT"
#endif

#define TABLE_CAP ('Z'-'A'+1)

I64 table[TABLE_CAP][TABLE_CAP];
I64 back_table[TABLE_CAP][TABLE_CAP];

class Sub {
  I64 a, b, c;
};

#define SUBS_CAP 128

Sub subs[SUBS_CAP];
I64 subs_cnt;

I64 freq[TABLE_CAP];

U0 DumpTable()
{
  I64 i,j;
  "   ";
  for (i=0; i<TABLE_CAP; ++i) {
    "%c ", i+'A';
  }
  "\n";
  for (i=0; i<TABLE_CAP; ++i) {
    "%c:", i+'A';
    for (j=0; j<TABLE_CAP; ++j) {
      if (table[i][j])
        "%d ", table[i][j];
      else ". ";
    }
    "\n";
  }
}

U0 PairInsertion()
{
  I64 i, n;
  MemSet(back_table, 0, sizeof(back_table));
  for(i=0; i<subs_cnt; ++i) {
    n=table[subs[i].a][subs[i].b];
    back_table[subs[i].a][subs[i].c] += n;
    back_table[subs[i].c][subs[i].b] += n;
  }
  MemCpy(table, back_table, sizeof(back_table));
}

I64 Proof(I64 last_char)
{
  I64 i,j;
  MemSet(freq, 0, sizeof(freq));
  for (i=0; i<TABLE_CAP; ++i) {
    for (j=0; j<TABLE_CAP; ++j) {
      freq[i]+=table[i][j];
    }
  }
  freq[last_char-'A']++;

  I64 min=I64_MAX, max=I64_MIN;
  for (i=0; i<TABLE_CAP; ++i) {
    if (freq[i] > 0){
      min=MinI64(min, freq[i]);
      max=MaxI64(max, freq[i]);
    }
  }
  return max-min;
}

U0 Main(){
  I64 i,a,b;
  SV sv, temp;
  sv.begin = FileRead(INPUT_FILE, &sv.size);
  U8 *saved_begin = sv.begin;

  SVChopByDelim(&sv, '\n', &temp);  

  MemSet(table, 0, sizeof(table));
  for (i=0; i<temp.size-1; ++i) {
    a=temp.begin[i]-'A';
    b=temp.begin[i+1]-'A';
    table[a][b]++;
  }

  subs_cnt=0;
  
  SVChopLeft(&sv);

  while (sv.size >1){
    subs[subs_cnt].a=sv.begin[0]-'A';
    subs[subs_cnt].b=sv.begin[1]-'A';
    SVChopLeft(&sv, 6);
    subs[subs_cnt].c=sv.begin[0]-'A';
    subs_cnt++;
    SVChopLeft(&sv, 2);
  }

  I64 last_char = temp.begin[temp.size-1];

  for (i=0; i<10;++i) PairInsertion;
  "Part 1:%d\n", Proof(last_char);
  for (; i<40; ++i) PairInsertion;
  "Part 2:%d\n", Proof(last_char);

  Free(saved_begin);
}


Main;
