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

#define Token I64
#define TOKEN_OPEN -1
#define TOKEN_CLOSE -2
#define TOKENS_CAP (2 * 1024)
Token dst[TOKENS_CAP];
Token src[TOKENS_CAP];
Token tokens[TOKENS_CAP][TOKENS_CAP];
I64 tokens_szs[TOKENS_CAP];
I64 tokens_cnt;

I64 ChopTokens(SV *sv, Token *tokens, I64 tokens_cap)
{
    I64 tokens_sz = 0;
    while (sv->size > 0 && tokens_sz < tokens_cap) {
        switch (sv->begin[0]) {
        case '[':
            tokens[tokens_sz++] = TOKEN_OPEN;
            SVChopLeft(sv); // skip '['
            break;
        case ']':
            tokens[tokens_sz++] = TOKEN_CLOSE;
            SVChopLeft(sv); // skip ']'
            break;
        case ',':
            SVChopLeft(sv); // skip ','
            break;
        default:
            tokens[tokens_sz++] = SVChopI64(sv);
        }
    }
    return tokens_sz;
}

U0 PrintTokens(Token *tokens, I64 tokens_sz)
{
    I64 i;
    for (i=0; i<tokens_sz; ++i)
        switch(tokens[i]) {
        case TOKEN_OPEN:
            Print("(");
            break;
        case TOKEN_CLOSE:
            Print(")");
            break;
        default:
            Print(" %ld ", tokens[i]);
        }
}

Bool ExplodeTokens(Token *src, I64 *src_sz)
{
    I64 i, j, a, b;
    I64 level=0;
    for (i=0; i<*src_sz; ++i) {
        switch (src[i]) {
        case TOKEN_OPEN: {
            if (level == 4) {
                // ((((( 9  8 ) 1 ) 2 ) 3 ) 4 )
                if (i+3 < *src_sz) {
                    if (src[i+1] >= 0 && src[i+2] >= 0) {
                        // assert(src[i+3] == TOKEN_CLOSE);
                        src[i] = 0;
                        a = src[i+1];
                        b = src[i+2];
                        for (j=0; i+4+j<*src_sz; ++j) {
                            src[i+1+j] = src[i+4+j];
                        }
                        *src_sz -= 3;
                        for (j=i-1; j>=0; --j) {
                            if (src[j]>=0) {
                                src[j] += a;
                                break;
                            }
                        }
                        for (j=i+1; j<*src_sz; ++j) {
                            if (src[j]>=0) {
                                src[j] += b;
                                break;
                            }
                        }
                        return TRUE;
                    }
                }
            }

            level++;
        }
        break;

        case TOKEN_CLOSE: {
            level--;
        }
        break;

        default:
        {}
        }
    }

    return FALSE;
}

Bool SplitTokens(Token *tokens, I64 *tokens_sz, I64 tokens_cap)
{
    I64 i, j, a;
    for (i=0; i<*tokens_sz; ++i) {
        if (tokens[i] >= 10) {
            a = tokens[i];
            if (*tokens_sz + 3 > tokens_cap) {
                Print("------------------------------\n");
                Print("CAPACITY OVERFLOW ON SPLIT!!! ALLOCATE MORE MEMORY!!!1\n");
                Print("------------------------------\n");
                return FALSE;
            }

            for (j=*tokens_sz-1; j>i; --j) {
                tokens[j+3] = tokens[j];
            }

            *tokens_sz += 3;

            tokens[i]   = TOKEN_OPEN;
            tokens[i+1] = a/2;
            tokens[i+2] = (a+1)/2;
            tokens[i+3] = TOKEN_CLOSE;
            return TRUE;
        }
    }
    return FALSE;
}

U0 AddTokens(Token *dst, I64 *dst_sz, I64 dst_cap,
             Token *src, I64 src_sz)
{
    I64 i;
    if (*dst_sz + src_sz + 2 > dst_cap) {
        Print("------------------------------\n");
        Print("CAPACITY OVERFLOW ON ADD!!! ALLOCATE MORE MEMORY!!!1\n");
        Print("------------------------------\n");
    }

    for (i=*dst_sz-1; i >= 0; --i) {
        dst[i+1] = dst[i];
    }
    dst[0] = TOKEN_OPEN;

    *dst_sz += 1;

    for (i=0; i<src_sz; ++i) {
        dst[(*dst_sz)++] = src[i];
    }
    dst[(*dst_sz)++] = TOKEN_CLOSE;
}

I64 Magnitude(Token *src, Token **end=NULL)
{
    I64 a, b;
    Token *endp = NULL;
    if (*src >= 0) {
        if (end) *end = src + 1;
        return *src;
    } else if (*src == TOKEN_OPEN) {
        a = Magnitude(src + 1, &endp);
        src = endp;
        b = Magnitude(src, &endp);
        src = endp;
        if (end) *end = src + 1;
        return 3*a + 2*b;
    }
    Print("------------------------------\n");
    Print("UNREACHABLE IN MAGNITUDE\n");
    Print("------------------------------\n");
    return 0;
}

U0 Part1()
{
    SV sv, line;
    sv.begin = FileRead(INPUT_FILE, &sv.size);
    U8 *saved_begin = sv.begin;
    I64 dst_sz, src_sz;
    Bool first = TRUE;

    while (sv.size > 1) {
        if (first) {
            SVChopByDelim(&sv, '\n', &line);
            dst_sz = ChopTokens(&line, dst, TOKENS_CAP);
            first = FALSE;
        } else {
            SVChopByDelim(&sv, '\n', &line);
            src_sz = ChopTokens(&line, src, TOKENS_CAP);

            AddTokens(dst, &dst_sz, TOKENS_CAP, src, src_sz);
            while (TRUE) {
                if (!ExplodeTokens(dst, &dst_sz))
                    if (!SplitTokens(dst, &dst_sz, TOKENS_CAP))
                        break;
            }
        }
    }

    Print("Part 1: %ld\n", Magnitude(dst));

    Free(saved_begin);
}

U0 Part2()
{
    SV sv, line;
    I64 i, j, dst_sz;
    sv.begin = FileRead(INPUT_FILE, &sv.size);
    U8 *saved_begin = sv.begin;
    tokens_cnt = 0;

    while (sv.size > 1) {
        SVChopByDelim(&sv, '\n', &line);
        tokens_szs[tokens_cnt] = ChopTokens(&line, tokens[tokens_cnt], TOKENS_CAP);
        tokens_cnt++;
    }

    I64 result = I64_MIN;

    for (i=0; i<tokens_cnt; ++i)
        for (j=0; j<tokens_cnt; ++j)
            if (i != j) {
                dst_sz = tokens_szs[i];
                MemCpy(dst, tokens[i], dst_sz * sizeof(Token));
                AddTokens(dst, &dst_sz, TOKENS_CAP, tokens[j], tokens_szs[j]);
                while (TRUE) {
                    if (!ExplodeTokens(dst, &dst_sz))
                        if (!SplitTokens(dst, &dst_sz, TOKENS_CAP))
                            break;
                }
                result = MaxI64(result, Magnitude(dst));
            }

    Print("Part 2: %ld\n", result);

    Free(saved_begin);
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
