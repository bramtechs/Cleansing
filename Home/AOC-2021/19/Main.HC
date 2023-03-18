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

class Point
{
    I64 x, y, z;
};

Bool PointEq(Point *a, Point *b)
{
    return a->x == b->x && a->y == b->y && a->z == b->z;
}

U0 PointInv(Point *a)
{
    a->x = -a->x;
    a->y = -a->y;
    a->z = -a->z;
}

U0 PointSub(Point *r, Point *a, Point *b)
{
    r->x = a->x - b->x;
    r->y = a->y - b->y;
    r->z = a->z - b->z;
}

U0 PrintPoint(Point *p)
{
    Print("(%ld,%ld,%ld)", p->x, p->y, p->z);
}

class Scanner
{
    Point pos;
    Bool visited;
    Point *beacons;
    I64 beacons_cnt;
};

#define SCANNERS_CAP 1024
Scanner scanners[SCANNERS_CAP];
I64 scanners_cnt;

#define PP_CAP 1024             // PP stands for Points Pool
Point pp[PP_CAP];
I64 pp_cnt;

Point *PPEnd()
{
    return pp + pp_cnt;
}

U0 PPPush(I64 x, I64 y, I64 z)
{
    pp[pp_cnt].x = x;
    pp[pp_cnt].y = y;
    pp[pp_cnt].z = z;
    pp_cnt++;
}

U0 SVChopScanner(SV *sv, Scanner *scanner)
{
    I64 x, y, z;
    scanner->beacons = PPEnd();
    scanner->beacons_cnt = 0;

    while (sv->size > 0 && sv->begin[0] != '\n') {
        x = SVChopI64(sv);
        SVChopLeft(sv);
        y = SVChopI64(sv);
        SVChopLeft(sv);
        z = SVChopI64(sv);
        SVChopLeft(sv);
        PPPush(x, y, z);
        scanner->beacons_cnt++;
    }

    SVChopLeft(sv);
}

U0 PrintScanner(Scanner *s)
{
    I64 i;
    for (i=0; i<s->beacons_cnt; ++i) {
        PrintPoint(&s->beacons[i]);
        Print("\n");
    }
}

U0 OffsetScanner(Scanner *s, Point *v)
{
    I64 i;
    for (i=0; i<s->beacons_cnt; ++i) {
        s->beacons[i].x += v->x;
        s->beacons[i].y += v->y;
        s->beacons[i].z += v->z;
    }
    s->pos.x += v->x;
    s->pos.y += v->y;
    s->pos.z += v->z;
}

I64 BSearchPoints(Point *key, Point *base, I64 num, I64 (*pp_compare)(Point *e1,Point *e2))
{
    I64 left=0, right=num-1, middle;
    I64 cmp;

    while (left < right) {
        middle = left + (right - left) / 2;
        cmp = (*pp_compare)(key, &base[middle]);
        if (cmp < 0) {
            right = middle - 1;
        } else if (cmp > 0) {
            left = middle + 1;
        } else {
            return middle;
        }
    }

    if (left == right && PointEq(key, &base[left])) {
        return left;
    } else {
        return -1;
    }
}

Bool ScannerContains(Scanner *s, Point *p)
{
    I64 i;
    for (i=0; i<s->beacons_cnt; ++i) {
        if (PointEq(&s->beacons[i], p)) {
            return TRUE;
        }
    }
    return FALSE;
}

I64 CommonBeacons(Scanner *s1, Scanner *s2)
{
    I64 i, cnt=0;
    for (i=0; i<s1->beacons_cnt; ++i) {
        if (ScannerContains(s2, &s1->beacons[i])) {
            cnt++;
        }
    }
    return cnt;
}

Bool MatchScannersOffsets(Scanner *s1, Scanner *s2)
{
    I64 i, j;
    Point offset;

    for (i=0; i<s1->beacons_cnt; ++i) {
        for (j=0; j<s2->beacons_cnt; ++j) {
            PointSub(&offset, &s1->beacons[i], &s2->beacons[j]);
            OffsetScanner(s2, &offset);
            if (CommonBeacons(s1, s2) >= 12) return TRUE;
            PointInv(&offset);
            OffsetScanner(s2, &offset);
        }
    }

    return FALSE;
}

U0 Rot(I64 *x, I64 *y)
{
    SwapI64(x, y);
    *y = -*y;
}

#define PLANE I64
#define XY 0
#define ZX 1
#define ZY 2

U0 RotPoint(Point *p, PLANE plane)
{
    switch (plane) {
    case XY:
        Rot(&p->x, &p->y);
        break;
    case ZX:
        Rot(&p->z, &p->x);
        break;
    case ZY:
        Rot(&p->z, &p->y);
        break;
    default:
        Print("RotPoint: UNREACHABLE!!111\n");
    }
}

U0 RotPoints(Point *ps, I64 ps_cnt, PLANE plane)
{
    I64 i;
    for(i=0; i<ps_cnt; ++i) RotPoint(&ps[i], plane);
}

Bool MatchScannersRots(Scanner *s1, Scanner *s2)
{
    I64 i, j;

    for (j=0; j<4; ++j) {
        for (i=0; i<4; ++i) {
            if (MatchScannersOffsets(s1, s2)) return TRUE;
            RotPoints(s2->beacons, s2->beacons_cnt, XY);
        }
        RotPoints(s2->beacons, s2->beacons_cnt, ZX);
    }
    RotPoints(s2->beacons, s2->beacons_cnt, ZY);
    for (i=0; i<4; ++i) {
        if (MatchScannersOffsets(s1, s2)) return TRUE;
        RotPoints(s2->beacons, s2->beacons_cnt, XY);
    }
    RotPoints(s2->beacons, s2->beacons_cnt, ZY);
    RotPoints(s2->beacons, s2->beacons_cnt, ZY);
    for (i=0; i<4; ++i) {
        if (MatchScannersOffsets(s1, s2)) return TRUE;
        RotPoints(s2->beacons, s2->beacons_cnt, XY);
    }
    RotPoints(s2->beacons, s2->beacons_cnt, ZY);

    return FALSE;
}

U0 DfsScanners(I64 c)
{
    I64 j;
    for (j=0; j<scanners_cnt; ++j) {
        if (j != c && !scanners[j].visited) {
            if (MatchScannersRots(&scanners[c], &scanners[j])) {
                Print("%ld-%ld\n", c, j);
                scanners[j].visited = TRUE;
                DfsScanners(j);
            }
        }
    }
}

I64 PointCmp(Point *p1, Point *p2)
{
    I64 dx = p1->x - p2->x;
    I64 dy = p1->y - p2->y;
    I64 dz = p1->z - p2->z;
    if (dx != 0) return dx;
    if (dy != 0) return dy;
    if (dz != 0) return dz;
    return 0;
}

I64 Manhat(Point *a, Point *b)
{
    return AbsI64(a->x - b->x) + AbsI64(a->y - b->y) + AbsI64(a->z - b->z);
}

U0 Main()
{
    I64 i, j, a;
    SV sv, line;
    sv.begin = FileRead(INPUT_FILE, &sv.size);
    U8 *saved_begin = sv.begin;

    pp_cnt = 0;
    scanners_cnt = 0;
    while (sv.size > 0) {
        SVChopByDelim(&sv, '\n', &line);

        MemSet(&scanners[scanners_cnt], 0, sizeof(Scanner));
        SVChopScanner(&sv, &scanners[scanners_cnt]);
        scanners_cnt++;
    }

#if 1
    scanners[0].visited = TRUE;
    DfsScanners(0);
    Print("------------------------------\n");
    for (i=0; i<scanners_cnt; ++i) {
        if (scanners[i].visited) {
            Print("%ld: TRUE\n", i);
        } else {
            Print("%ld: FALSE\n", i);
        }
    }
    Print("------------------------------\n");
    QSort(pp,pp_cnt,sizeof(Point),&PointCmp);
    a=1;
    for (i=0; i<pp_cnt-1; ++i) {
        if (!PointEq(&pp[i], &pp[i+1])) a++;
    }
    Print("Part 1: %ld\n", a);

    a = I64_MIN;
    for (i=0; i<scanners_cnt; ++i)
      for (j=i+1; j<scanners_cnt; ++j) {
         a = MaxI64(a, Manhat(&scanners[i].pos, &scanners[j].pos));
      }

    Print("Part 2: %ld\n", a);     
#endif

    Free(saved_begin);
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
