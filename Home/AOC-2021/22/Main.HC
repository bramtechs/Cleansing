#ifdef BLASPHEMY
#include "../Blasphemy.hpp"
#include "../Common.HC"
#else
Cd(__DIR__);
#include "~/AOC-2021/Common.HC"
#endif

#if 0
#define INPUT_FILE "sample.TXT"
#else
#define INPUT_FILE "input.TXT"
#endif

class Cuboid
{
    Bool on;
    I64 x0, x1;
    I64 y0, y1;
    I64 z0, z1;
};

U0 SVChopCuboid(SV *sv, Cuboid *c)
{
    SV token;

    SVChopByDelim(sv, ' ', &token);
    c->on = SVEqCstr(&token, "on");

    SVChopLeft(sv, 2); // skip 'x='
    c->x0 = SVChopI64(sv);
    SVChopLeft(sv, 2); // skip '..'
    c->x1 = SVChopI64(sv) + 1;

    SVChopLeft(sv, 1); // skip ','

    SVChopLeft(sv, 2); // skip 'y='
    c->y0 = SVChopI64(sv);
    SVChopLeft(sv, 2); // skip '..'
    c->y1 = SVChopI64(sv) + 1;

    SVChopLeft(sv, 1); // skip ','

    SVChopLeft(sv, 2); // skip 'z='
    c->z0 = SVChopI64(sv);
    SVChopLeft(sv, 2); // skip '..'
    c->z1 = SVChopI64(sv) + 1;
}

U0 PrintCuboid(Cuboid *c)
{
    Print("on=");
    if (c->on) Print("TRUE");
    else Print("FALSE");
    Print(" ");
    Print("X=%ld..%ld Y=%ld..%ld Z=%ld..%ld\n",
          c->x0, c->x1,
          c->y0, c->y1,
          c->z0, c->z1);
}

#define CS_CAP 512
Cuboid cs[CS_CAP];
I64 cs_cnt;
I64 xs[2*CS_CAP];
I64 ys[2*CS_CAP];
I64 zs[2*CS_CAP];
U8 grid[2*CS_CAP][2*CS_CAP][2*CS_CAP];

U0 CuboidAddCoords(Cuboid *c)
{
    xs[2*cs_cnt + 0] = c->x0;
    xs[2*cs_cnt + 1] = c->x1;
    ys[2*cs_cnt + 0] = c->y0;
    ys[2*cs_cnt + 1] = c->y1;
    zs[2*cs_cnt + 0] = c->z0;
    zs[2*cs_cnt + 1] = c->z1;
}

I64 CoordCmp(I64 a, I64 b)
{
    return a - b;
}

I64 BSearchI64(I64 *base, I64 num, I64 key, I64 (*fp_compare)(I64 a, I64 b))
{
    I64 left = 0;
    I64 right = num - 1;
    I64 middle;
    I64 cmp;
    while (left <= right) {
        middle = left + (right - left) / 2;

        cmp = (*fp_compare)(base[middle], key);
        if (cmp == 0) {
            return middle;
        } else if (cmp < 0) {
            left = middle + 1;
        } else {
            // assert(cmp > 0)
            right = middle - 1;
        }
    }

    if ((*fp_compare)(base[left], key) == 0) {
        return left;
    } else {
        Print("BSearchI64: UNREACHABLE\n");
        return -1;
    }
}

U0 ProcessCuboid(Cuboid *c)
{
    I64 x0 = BSearchI64(xs, 2*cs_cnt, c->x0, &CoordCmp);
    I64 x1 = BSearchI64(xs, 2*cs_cnt, c->x1, &CoordCmp);
    I64 y0 = BSearchI64(ys, 2*cs_cnt, c->y0, &CoordCmp);
    I64 y1 = BSearchI64(ys, 2*cs_cnt, c->y1, &CoordCmp);
    I64 z0 = BSearchI64(zs, 2*cs_cnt, c->z0, &CoordCmp);
    I64 z1 = BSearchI64(zs, 2*cs_cnt, c->z1, &CoordCmp);
    I64 x, y, z;

    for (x=x0; x<x1; ++x)
        for (y=y0; y<y1; ++y)
            for (z=z0; z<z1; ++z)
                grid[x][y][z] = c->on;
}

U0 ReadInput()
{
    SV sv;
    sv.begin = FileRead(INPUT_FILE, &sv.size);
    U8 *saved_begin = sv.begin;

    MemSet(grid, 0, sizeof(grid));
    cs_cnt = 0;
    while (sv.size > 1) {
        SVChopCuboid(&sv, &cs[cs_cnt]);
        SVChopLeft(&sv, 1);
        CuboidAddCoords(&cs[cs_cnt]);
        cs_cnt++;
    }

    QSortI64(xs, 2*cs_cnt, &CoordCmp);
    QSortI64(ys, 2*cs_cnt, &CoordCmp);
    QSortI64(zs, 2*cs_cnt, &CoordCmp);

    Free(saved_begin);
}

I64 CountOn()
{
    I64 x, y, z, result=0;
    for (x=0; x<2*cs_cnt-1; ++x)
        for (y=0; y<2*cs_cnt-1; ++y)
            for (z=0; z<2*cs_cnt-1; ++z)
                if (grid[x][y][z])
                    result += (xs[x+1]-xs[x]) * (ys[y+1]-ys[y]) * (zs[z+1]-zs[z]);
    return result;
}

U0 Main()
{
    I64 i;
    ReadInput();

    for (i=0; i<cs_cnt && -50 <= cs[i].x0 && cs[i].x0 <= 50; ++i) {
        ProcessCuboid(&cs[i]);
    }

    Print("Part 1: %ld\n", CountOn());

    for (; i<cs_cnt; ++i) {
        ProcessCuboid(&cs[i]);
    }

    Print("Part 2: %ld\n", CountOn());
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
