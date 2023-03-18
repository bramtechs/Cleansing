#ifdef BLASPHEMY
#include "../Blasphemy.hpp"
#include "../Common.HC"
#else
Cd(__DIR__);
#include "~/AOC-2021/Common.HC"
#endif

#if 0
#define INPUT_FILE "sample.TXT"
#define INF_PIXEL 0
#else
#define INPUT_FILE "input.TXT"
#define INF_PIXEL (it % 2)
#endif

#define BOARD_CAP (1024 * 1024)
I64 width, height;
I64 curr;
U8 board[2][BOARD_CAP];

U8 NextPixel(I64 cx, I64 cy, SV *algo, I64 it)
{
    I64 dx, dy;
    I64 x, y;
    I64 i = 0, b;
    for (dy=-1; dy<=1; ++dy) {
        for (dx=-1; dx<=1; ++dx) {
            x = cx + dx;
            y = cy + dy;
            if (0 <= x && x < width && 0 <= y && y < height) {
                b = board[curr][y*width + x] == '#';
            } else {
                b = INF_PIXEL;
            }
            i = (i<<1) | b;
        }
    }
    return algo->begin[i];
}

U0 NextBoard(SV *algo, I64 it)
{
    I64 x, y;
    I64 next = 1 - curr;
    I64 next_width = width + 2;
    I64 next_height = height + 2;

    for (y=0; y<next_height; ++y) {
        for (x=0; x<next_width; ++x) {
            board[next][y*next_width + x] = NextPixel(x-1, y-1, algo, it);
        }
    }

    width = next_width;
    height = next_height;
    curr = next;
}

U0 PrintCurrBoard()
{
    I64 x, y;
    for (y=0; y<height; ++y) {
        for (x=0; x<width; ++x) {
            Print("%c", board[curr][y*width + x]);
        }
        Print("\n");
    }
}

I64 CountLit()
{
    I64 i;
    I64 result = 0;
    for (i=0; i<width*height; ++i)
        if (board[curr][i] == '#')
            result++;
    return result;
}

U0 Main()
{
    I64 x, y, it;
    SV sv, algo, line;
    sv.begin = FileRead(INPUT_FILE, &sv.size);
    U8 *saved_begin = sv.begin;

    SVChopByDelim(&sv, '\n', &algo);
    SVChopLeft(&sv);
    height = 0;
    width = 0;
    curr = 0;
    while (sv.size > 1) {
        SVChopByDelim(&sv, '\n', &line);
        width = MaxI64(width, line.size);
        for (x=0; x<line.size; ++x) {
            board[curr][height*width + x] = line.begin[x];
        }
        height++;
    }

    Print("%ldx%ld\n", width, height);

    for (it=0; it<2; ++it) {
        NextBoard(&algo, it);
    }
    Print("Part 1: %ld\n", CountLit());
    for (; it<50; ++it) {
        NextBoard(&algo, it);
    }
    Print("Part 2: %ld\n", CountLit());

    Free(saved_begin);
}

U0 Part2()
{
}

#ifdef BLASPHEMY
int main(void)
{
    Main();
    return 0;
}
#else
Main;
#endif
