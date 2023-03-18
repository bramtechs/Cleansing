#ifdef BLASPHEMY
#include "../Blasphemy.hpp"
#include "../Common.HC"
#else
Cd(__DIR__);
#include "~/AOC-2021/Common.HC"
#endif

#if 0
#define INPUT_FILE "sample.TXT"
#define P1_START 4
#define P2_START 8
#else
#define INPUT_FILE "input.TXT"
#define P1_START 8
#define P2_START 2
#endif

I64 Roll(I64 *die)
{
    I64 result = *die;
    *die = *die % 100 + 1;
    return result;
}

U0 Part1()
{
    I64 p1_pos = P1_START;
    I64 p2_pos = P2_START;
    I64 p1_score = 0;
    I64 p2_score = 0;
    I64 die = 1;
    I64 sum;
    I64 rolls = 0;

    while (TRUE) {
        sum = 0;
        sum += Roll(&die);
        rolls++;
        sum += Roll(&die);
        rolls++;
        sum += Roll(&die);
        rolls++;
        p1_pos = (p1_pos + sum - 1) % 10 + 1;
        p1_score += p1_pos;
        if (p1_score >= 1000) break;

        sum = 0;
        sum += Roll(&die);
        rolls++;
        sum += Roll(&die);
        rolls++;
        sum += Roll(&die);
        rolls++;
        p2_pos = (p2_pos + sum - 1) % 10 + 1;
        p2_score += p2_pos;
        if (p2_score >= 1000) break;
    }

    Print("Part 1: %ld\n", MinI64(p1_score, p2_score) * rolls);
}

I64 Wrap10(I64 x)
{
    return (x - 1) % 10 + 1;
}

I64 cache1[2][15][15][25][25];
I64 cache2[2][15][15][25][25];
Bool visited[2][15][15][25][25];

U0 P1Wins(I64 p, I64 p1_pos, I64 p2_pos, I64 p1_score, I64 p2_score, I64 *p1_wins, I64 *p2_wins)
{
    I64 a,b,c,new_pos,p1_wins0,p2_wins0;

    if (visited[p][p1_pos][p2_pos][p1_score][p2_score]) {
        *p1_wins = cache1[p][p1_pos][p2_pos][p1_score][p2_score];
        *p2_wins = cache2[p][p1_pos][p2_pos][p1_score][p2_score];
    } else {
        if (p1_score >= 21) {
            *p1_wins = 1;
            *p2_wins = 0;
        } else if (p2_score >= 21) {
            *p1_wins = 0;
            *p2_wins = 1;
        } else {
            switch (p) {
            case 0: {
                *p1_wins = 0;
                *p2_wins = 0;
                for (a=1; a<=3; ++a)
                    for (b=1; b<=3; ++b)
                        for (c=1; c<=3; ++c) {
                            new_pos=Wrap10(p1_pos+a+b+c);
                            P1Wins(1 - p, new_pos, p2_pos, p1_score + new_pos, p2_score, &p1_wins0, &p2_wins0);
                            *p1_wins += p1_wins0;
                            *p2_wins += p2_wins0;
                        }
            }
            break;
            case 1: {
                *p1_wins = 0;
                *p2_wins = 0;
                for (a=1; a<=3; ++a)
                    for (b=1; b<=3; ++b)
                        for (c=1; c<=3; ++c) {
                            new_pos=Wrap10(p2_pos+a+b+c);
                            P1Wins(1 - p, p1_pos, new_pos, p1_score, p2_score + new_pos, &p1_wins0, &p2_wins0);
                            *p1_wins += p1_wins0;
                            *p2_wins += p2_wins0;
                        }
            }
            break;
            }
        }

        visited[p][p1_pos][p2_pos][p1_score][p2_score] = TRUE;
        cache1[p][p1_pos][p2_pos][p1_score][p2_score] = *p1_wins;
        cache2[p][p1_pos][p2_pos][p1_score][p2_score] = *p2_wins;
    }
}

U0 Part2()
{
    MemSet(cache1, 0, sizeof(cache1));
    MemSet(cache2, 0, sizeof(cache2));
    MemSet(visited, 0, sizeof(visited));
    I64 p1_wins, p2_wins;
    P1Wins(0, P1_START, P2_START, 0, 0, &p1_wins, &p2_wins);
    Print("p1: %ld\n", p1_wins);
    Print("p2: %ld\n", p2_wins);
}

#ifdef BLASPHEMY
int main(void)
{
    Part1();
    Part2();
    return 0;
}
#else
Part1;
Part2;
#endif
