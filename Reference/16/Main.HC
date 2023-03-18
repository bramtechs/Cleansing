Cd(__DIR__);
#include "~/AOC-2021/Common.HC"

#if 0
#define INPUT_FILE "sample2.TXT"
#else
#define INPUT_FILE "input.TXT"
#endif

#define BITS_BUF_CAP 2048
U8 bits_buf[BITS_BUF_CAP];

I64 Hex2Dec(I64 x)
{
  if ('0' <= x <= '9') return x-'0';
  if ('a' <= x <= 'f') return x-'a'+10;
  if ('A' <= x <= 'F') return x-'A'+10;
  "Hex2Dec: unreachable\n";
}

U0 HexStr2Bits(SV *p, U8 *bits)
{
  I64 i, j;
  for (i=0; i<p->size; ++i)
    for (j=0; j<4; ++j)
      bits[i*4+j] = (Hex2Dec(p->begin[i])>>(3-j))&1;
}

I64 BitsChopLeft(SV *bits, I64 n, I64 *count)
{
  I64 i=0;
  I64 result = 0;
  for (i=0; i<n; ++i)
    result = (result<<1)|bits->begin[i];
  SVChopLeft(bits, n);
  *count += n;
  return result;
}

U0 PrintBits(SV *bits)
{
  I64 i;
  for(i=0;i<bits->size;++i) "%d", bits->begin[i];
  "\n";
}

I64 BitsChopLiteral(SV *bits, I64 *count)
{
  I64 c=1, n;
  I64 result = 0;
  while (bits->size > 0 && c>0) {
    c = BitsChopLeft(bits, 1, count);
    n = BitsChopLeft(bits, 4, count);
    result = (result<<4)|n;
  }
  return result;
}

I64 BitsChopPacket(SV *bits, I64 *count, I64 *versum, I64 depth=0)
{
  I64 type, mode, n, m, result=-1, value;
  *versum += BitsChopLeft(bits, 3, count);
  type = BitsChopLeft(bits, 3, count);;
  if (type == 4) {
    result = BitsChopLiteral(bits, count);
//    "%*sLiteral: %d\n", 2*depth, "", result;
  } else {
//    "%*sOperator: %d\n", 2*depth, "", type;
    mode = BitsChopLeft(bits, 1, count);
//    "%*sMode:     %d\n", 2*depth, "", mode;
    if (mode == 0)    
      n = BitsChopLeft(bits, 15, count);
    else
      n = BitsChopLeft(bits, 11, count);
//    "%*sN: %d\n", 2*depth, "", n;

    while (n>0) {
      m = 0;
      value = BitsChopPacket(bits, &m, versum, depth+1);

      if (result < 0) {
        result = value;
      } else {
        switch (type) {
        case 0:  //sum
          result += value;
          break;
        case 1:  //product
          result *= value;
          break;
        case 2:  //min
          result = MinI64(result, value);
          break;
        case 3:  //max
          result = MaxI64(result, value);
          break;
        case 5:  //greather than
          result = result > value;
          break;
        case 6:  //less than
          result = result < value;
          break;
        case 7:  //equalto
          result = result == value;
          break;
        default:
          "UNKNOWN OPERATOR %d!!!!!!\n", type;
        }
      }

      if (mode == 0){
        n -= m;
      } else {
        n -= 1;
      }
      *count += m;
    }
  }
  return result;
}

U0 Main(){
  SV sv, p, bits;
  sv.begin = FileRead(INPUT_FILE, &sv.size);
  I64 count, versum, value, i;

  for (i=0; sv.size>1; ++i) {
    SVChopByDelim(&sv, '\n', &p);

    HexStr2Bits(&p, bits_buf);
    bits.begin = bits_buf;
    bits.size = p.size*4;

//    PrintBits(&bits); "\n";

    count=0;
    versum=0;
    value = BitsChopPacket(&bits, &count, &versum);
    "Part 1:%d\n", versum;
    "Part 2: %d\n", value;
  }
}

Main;