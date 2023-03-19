I64 glbl_r[4][4];

U0 DrawIt(CTask *,CDC *dc)
{
  I64 *old_r=dc->r;
  dc->thick=2;
  dc->color=RED;
  dc->x=200;
  dc->y=200;
  dc->flags|=DCF_TRANSFORMATION;
  DCMat4x4Set(dc,glbl_r); //This assigns to dc->r and sets r_norm.
  GrLine3(dc,-100,-100,-100, -100, 100,-100);
  GrLine3(dc,-100, 100,-100,  100, 100,-100);
  GrLine3(dc, 100, 100,-100,  100,-100,-100);
  GrLine3(dc, 100,-100,-100, -100,-100,-100);
  GrLine3(dc,-100,-100, 100, -100, 100, 100);
  GrLine3(dc,-100, 100, 100,  100, 100, 100);
  GrLine3(dc, 100, 100, 100,  100,-100, 100);
  GrLine3(dc, 100,-100, 100, -100,-100, 100);
  GrLine3(dc,-100,-100, 100, -100,-100,-100);
  GrLine3(dc,-100, 100, 100, -100, 100,-100);
  GrLine3(dc, 100, 100, 100,  100, 100,-100);
  GrLine3(dc, 100,-100, 100,  100,-100,-100);
  dc->r=old_r;

  GrCircle(dc, 50,50, 25);
}

U0 Box()
{
  F64 é=0,è=0,ê=0,s=1,s1=1.05;
  SettingsPush; //See $LK,"SettingsPush",A="MN:SettingsPush"$
  DocClear;
  Fs->draw_it=&DrawIt;
  while (!ScanChar) {
    Sleep(20);
  }
  SettingsPop;
}

Box;
