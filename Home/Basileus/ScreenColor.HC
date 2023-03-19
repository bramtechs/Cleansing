// NOTE: Script that shows custom colors
// that aren't in the default palette!

U0 MakeColor(CBGR48* bgr, U8 r, U8 g, U8 b)
{
    bgr->r = ToI64(r*255);
    bgr->g = ToI64(g*255);
    bgr->b = ToI64(b*255);
}

U0 SetScreenCol(CBGR48* bgr)
{
    I64 i;
    for (i=0;i<COLORS_NUM;i++)
        GrPaletteColorSet(i,bgr);
}

SettingsPush;

CBGR48 bgr;

// chartreuse
MakeColor(&bgr, 127, 255, 0);
SetScreenCol(bgr);

// chocolate
PressAKey;
MakeColor(&bgr, 210, 105, 30);
SetScreenCol(bgr);

// hotpink
PressAKey;
MakeColor(&bgr, 255, 105, 180);
SetScreenCol(bgr);

// lightseagreen
PressAKey;
MakeColor(&bgr, 32, 178, 170);
SetScreenCol(bgr);

// indigo
PressAKey;
MakeColor(&bgr, 75, 0, 130);
SetScreenCol(bgr);

PressAKey;
SettingsPop;
