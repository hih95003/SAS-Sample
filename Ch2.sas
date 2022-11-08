
/**** SAS Programming 第2章　統計グラフ ********************/

/************* 1　章より、サンプルデータの作成 **********************/
data  ex11;
input  subject $ gender $ math1 math2;
sum = math1 + math2;  
ave = mean(math1,math2);
if  ave>=80  then  grade="A";
else  if  ave>= 70  then grade= "B";
else  if  ave>= 60  then grade= "C";
else  grade = "F";
label  subject="学籍番号"  gender="性別" 
   math1="数学1"  math2="数学2" 
   sum="合計点"   ave="平均点" 
   grade="成績" ; 
cards;
s002  m  89  68
s003  m  69  77
s004  f  54  68
s009  f  78   91
s012  f  91  96
s013  m  63  44
k021  m  80  80
k023  f  56  61
k024  m  72  79
k026  f  89   89
s103  m  91 100
s106  m  90  98
; 
run:

title  "Example ex11";
proc  print  data=ex11 ;
run; 
title  "Sorted by the grade" ;
proc  sort  data=ex11  ;
  by  grade;
proc  print  label;
run;

data  ex11a (drop=tmp);
 set  ex11 ;
length  dept  $  6. ;
tmp = substr(subject, 1, 1);
 put  "tmp= " tmp ;
 if  tmp="s"  then  dept= "数学";
  else  if  tmp="k"  then  dept = "化学";
  else  if  tmp="b"  then  dept = "物理";
  else  dept = "その他";
label  dept="学科" ; 
proc  print  data = ex11a  label;
run;

/********* 学生生活満足度調査  surver データセット　*********/
options  noxsync  noxwait;
x  "C:\sas_study\student.xls";
filename  scfile   dde  "excel|student survey!r5c1:r30c6" ;

data  survey;
infile  scfile  dlm = '09'x  notab  dsd  missover  lrecl = 20000;
input  pin $  area $  ctime money sc career ; 
label  pin="学籍番号"   area="住所"  ctime="通学時間"
 money="所持金"  sc="満足度"  career="進路"; 
informat  money  comma. ; 
format  money  yen.  ; 
run;
title "student survey";
proc print data=survey (obs=10); 
run;


proc  format ;
value  scfmt 1="大変満足"  2="満足" 3="普通" 4="不満足" 5="大変不満" ; 
value  careerfmt 1="就職"  2="進学" 3="教員" 4="その他" ; 
value  genderfmt  0="男"         1="女" ;
value  smkfmt   0="喫煙歴なし"  1="喫煙" ; 
value $  gfmt   "m"= "男"   "f" = "女" ; 
run;

data survey;
 set survey;
 format sc scfmt.  career  careerfmt. ;
data  ex11;
 set  ex11;
 format   gender  $ gfmt.  ; 
run ; 
title "student survey";
proc print data=survey  label; run;
title  "Example ex11";
proc  print  data=ex11  label; run;

proc  format  ;
value  scfmt 1="大変満足"  2="満足" 3="普通" 4="不満足" 5="大変不満" ; 
value  careerfmt 1="就職"  2="進学" 3="教員" 4="その他" ; 
value  genderfmt  0="男"         1="女" ;
value  smkfmt   0="喫煙歴なし"  1="喫煙" ; 
value $  gfmt   "m"= "男"   "f" = "女" ; 
run;

title ; 

/*******  サンプルデータの作成　終了 **********************/




title  " 成績グラフ";
proc  sgplot  data=ex11 ;
vbar  grade; 
run ;

title   h=2  "男女別 math1 変数の成績グラフ";
title2  h=2  "作成： &sysuserid  on  &sysdate9 " ;
proc  sgplot  data=ex11;
vbar  gender /  response=math1  stat=mean ;
run;

title  " 成績グラフ";
proc  sgplot  data=ex11 ;
vbar  grade / 
response= math1  
stat = mean
group = gender 
groupdisplay = cluster ; 
run ;


data gex212;
input  gender $  ave  up  low  area $  ;
cards;
f   10  13   5  神奈川   
f    9  13   6  千葉   
f   13  15  10  東京
m   13  15   5  神奈川  
m   11  13   5  千葉  
m   14  16   8  東京
;
run;

title "地域別グラフ" ; 
proc  sgplot  data=gex212; 
vbarparm  category=area  response=ave  /  group=gender;
run;

title "地域別グラフ" ; 
proc  sgplot  data=gex212;
hbarparm  category=area  response=ave  /  group=gender
limitupper=up  limitlower=low ;
run; 


title  "成績別　詳細グラフ";
proc  sgplot  data= ex11;
vbar  grade /  response=math1  stat=mean ;
vline  grade /  response=math2  stat=mean  markers ;
run;



data  gex214; 
retain  year  1999 ; 
input  cost  price @@ ; 
year = year + 1 ; 
cards; 
89  100   87  100   89  101  90  102  
95  105   88  103   92  110  94  110 
96  115   97  120   99  120  100 120
100 125   120  130 
;
proc  print  data= gex214 ;
run;

title "2000～2013 年原価，売値比較グラフ" ; 
proc  sgplot  data= gex214;
series  x=year  y=cost   / datalabel ;
series  x=year  y=price  / datalabel ;
run ; 

title "2000～2013 年原価，売値比較グラフ" ; 
proc  sgplot  data=gex214;
series  x=year  y=cost /  
 datalabel  datalabelattrs= (size=3mm  Family=Arial) 
 markers  markerattrs=(symbol=TriangleDownFilled  Color=blue  size=3mm) ; 
series  x=year  y=price / 
 datalabel  datalabelattrs= (size=3mm  Family=Arial)
markers  markerattrs=(symbol=CircleFilled  Color=red  size=3mm) lineattrs=(pattern=42); 
xaxis values=(2000 to 2013 by 1) ;
run ; 


title "男女別 math1 変数の箱ひげ図" ;
proc  sgplot  data=ex11 ;
vbox  math1  /  category=gender ;
run ;

title "学科別 math1 変数の箱ひげ図" ;
proc  sgplot  data=ex11a ;
vbox  math1  /
 category=dept  group=gender ; 
run ;


title  " Histogram for math1 and math2" ;  
proc  sgplot  data = ex11 ;
histogram  math1;
histogram  math2 /  transparency= 0.5 ;
run; 

title  "Histogram and Density curve" ;  
proc  sgplot  data = ex11 ;
histogram  math1 /  showbins ;
density  math1 ;
density  math1  /  type= kernel ;
keylegend  /  location=inside 
    position=topright ;
run ;


title  "Histogram and Density curve" ;  
proc  sgplot  data = ex11 ;
histogram  math1 / showbins;
density  math1 / type=normal ( mu=80 sigma=15)
 lineattrs= ( color=blue  pattern=1 ) ;
refline  75  55  / axis=x  lineattrs= (color=red  pattern=2 ) ;
run;



title  "Scatter plot using math1 and math2 by gender" ; 
proc  sgplot  data= ex11 ;
scatter  y=math1  x= math2  / group= gender  datalabel= subject;
run ;

title  "Scatter plot using math1 and math2 by gender" ; 
proc  sgplot  data= ex11 ;
scatter  y=math1  x= math2  / 
   group= gender  datalabel= subject  markerattrs=(size=3mm)
 datalabelattrs=( size=3mm  Family=Arial) ;
 run ;



title  "Regression plot"  ; 
proc  sgplot  data=ex11;
reg  y=math2  x= math1 /  group= gender  datalabel= subject  ;
run ;

title  "Regression plot"  ; 
proc  sgplot  data=ex11;
reg  y=math2  x= math1 /  
group= gender  datalabel= subject  markerattrs=(size=5mm) ;
xaxis values=(50 to 100 by 5);
yaxis values=(40 to 100 by 10);
run ;

title  "Regression plot"  ; 
proc  sgplot  data= ex11;
reg  y=math2  x= math1 / clm cli  alpha= 0.1 ;
refline  60  80 ;
run ;



title  "Loess Curve " ;
proc  sgplot  data= ex11 ;
loess  y=math2  x=math1 / degree=2;
run ;

title  "Penalized B-spline curve ";
proc  sgplot  data= ex11;
pbspline  x=math1  y=math2  / clm;
refline  ave ;
run;



title  "vector using math1 and math2 " ;
proc  sgplot  data= ex11 ;
vector  x=math1  y=math2 /  xorigin=70  yorigin=60 arrowheadshape=barbed
group= gender  datalabel= subject  
datalabelattrs=( size=5mm  Family=Arial) ; 
run ;


/*******   2.2  グラフの比較（SGSCATTERプロシジャ）   ******************/
data add;
input subject $ kokugo @@;
label kokugo = "国語" ; 
cards;
s002  70 	s012  99	k024  86
s003  68	s013  67	k026  90
s004  55	k021  95	s103  89
s009  88	k023  86	s106  90
;

proc sort data=ex11;by subject;
proc sort data=add; by subject;
data ex11c;
merge ex11 add; by subject;
proc print data =ex11c label ;run;



title  "2 scatter plots" ; 
proc  sgscatter  data=ex11c;
plot  math1*kokugo  math2*kokugo  / 
group= gender   grid  reg= ( nogroup  clm  cli )   datalabel= subject 
markerattrs= (size=4mm);
run ; 

title  "2 Scatter plots"; 
proc  sgscatter  data=ex11c;
compare  y= (math1  math2)  x= kokugo /
  group= gender  grid  reg= (nogroup  clm  cli)  datalabel= subject ;
run;


title  "Scatter matrix of scores of  math1,math2 and kokugo "; 
proc  sgscatter  data= ex11c;
matrix  math1  math2  kokugo  /  group=gender  diagonal= ( normal  histogram )
markerattrs= (size=12) ;
run ;


title  "Scatter matrix of scores of  math1,math2 and kokugo "; 
proc  sgscatter  data= ex11c;
matrix  math1  math2  kokugo  /  ellipse= (alpha=0.01  type=mean )
markerattrs = (size=12  color= blue  symbol= triangle ) ;
run ;




/****** 2.3  分類変数の値で比較するグラフ（ SGPANELプロシジャ）*******/
title  "plot using math1 and math2 by gender " ;
proc  sgpanel  data=ex11;
panelby  gender ; 
reg  x=math1  y=math2  / clm;
run;

title  " Distribution for math1 by gender " ;
proc  sgpanel  data=ex11;
panelby gender ; 
histogram  math1 ;
density  math1; 
run; 

title   "Histogram for math1 and math2";
title2  "by grade" ;
proc  sgpanel  data=ex11;
panelby  grade;
vbar  gender  /  response=math1  stat=mean transparency=0.3  ;
vbar  gender  /  response=math2  stat=mean transparency=0.3   barwidth=0.5  ;
run ;




proc  sgpanel  data=ex11;
panelby  grade  /  columns=4 ;
vbar  gender  /  response=math1  stat=mean  transparency=0.3  ;
vbar  gender  /  response=math2  stat=mean  transparency=0.3   barwidth=0.5  ;
run ;



/********グラフテンプレートを利用したグラフ（ SGRENDERプロシジャ） *******/
data  cone ;
do  k =  -2  to  2  by  0.25 ;
  do  m =  -2  to  2  by  0.25 ;
    n=  sqrt( k*k  + m*m ) ;
   output ;
  end ;  
end ;
run;


proc  template ;
define  statgraph  sfgraph ;
 begingraph ;
entrytitle  "Cone 3D Plot" ;
 layout  overlay3d ;
    surfaceplotparm  x=k  y=m  z=n ;
endlayout ;
  endgraph ;
 end ;
run ;

proc  sgrender  data= cone  template= sfgraph ;
run;


proc  template ;
define  statgraph  sfgraph ;
 begingraph ;
entrytitle  "Cone 3D Plot" ;
 layout  overlay3d ;
    surfaceplotparm  x=k  y=m  z=n/
surfacetype= wireframe  
fillattrs=(color=SlateBlue) ;
;
endlayout ;
  endgraph ;
 end ;
run ;

proc  sgrender  data= cone  template= sfgraph ;
run;


proc  template ;
define  statgraph  sfgraph ;
 begingraph ;
entrytitle  "Cone 3D Plot" ;
 layout  overlay3d ;
bihistogram3dparm  x=k  y=m  z=n ; 
endlayout ;
  endgraph ;
 end ;
run ;

proc  sgrender  data= cone  template= sfgraph ;
run;

proc  template ;
define  statgraph  ScatterReg ;
begingraph ;
entrytitle  "Scatter Plot for math1 and math2";
entrytitle  "Reported by &sysuserid on &sysdate9";
layout  overlay ;
modelband  "myclm" ;
scatterplot  y=math1  x=math2 / markerattrs=(size=15)
datalabel=subject  datalabelattrs=(size=15)  group=gender ;
regressionplot  y=math1  x=math2 / clm="myclm"  alpha=0.01
degree=1  name='line'  legendlabel= 'Linear Fit' ;
endlayout ;
endgraph ;
end ;
run ;


proc  sgrender  data=ex11  
template=scatterreg ;
run;


proc  template ;
define  statgraph  Panel3g ;
begingraph ;
 entrytitle  "math1の点数";
layout  lattice / rows=3  columns=1 ;

layout  overlay  /
yaxisopts=(offsetmin=.15) xaxisopts=(label='math2の点数');
     histogram  math2 / binstart=0  BINwidth=10 ;
     fringeplot  math2 ;
     densityplot  math2  / normal( );
endlayout;
layout  overlay  / xaxisopts=(label='math2の点数');
     boxplot  y= math2 / orient= horizontal;
endlayout ;

layout overlay /
yaxisopts=(label='math2の点数') xaxisopts=(label='math1の点数');
     scatterplot  y=math2  x=math1 / 
markercharacter= subject 
         name='color'  markercolorgradient= sum;
     continuouslegend  'color' /  title='合計点' ;
     regressionplot  y=math2  x=math1 ;
endlayout ;
endlayout;
endgraph ;
end ;

proc  sgrender  data= ex11  template= panel3g ;
run;


proc  template ;
define  statgraph  ScatterReg2 ;
dynamic  VARX  VARY  DEG ;
begingraph ;
entrytitle  "Scatter Plot for " VARX " and " VARY;
entrytitle "Reported  by  &sysuserid  on  &sysdate9" ;
layout  overlay ;
modelband  "myclm";
scatterplot   y=VARY  x= VARX  /  markerattrs=(size=15 ) 
datalabel= subject  datalabelattrs=(size=15)  group=gender ;
regressionplot  y=VARY  x= VARX  /  clm="myclm"  alpha=0.01
degree=DEG  name= 'line'  legendlabel= 'Linear Fit' ;
endlayout ;
endgraph ;
end;
run;

proc  sgrender  data= ex11  template= ScatterReg2;
dynamic  vary="math1" varx="math2" deg= 3 ; 
run ;


proc  template;
define statgraph  sgbutterfly;
dynamic  _HL  _LEFT  _HR  _RIGHT;
begingraph;
   entrytitle halign=center _LEFT"と" _RIGHT "の比較グラフ";
   entryfootnote halign=left "作成：吉澤 (&sysuserid) , 日付：&sysdate9 &systime";
   layout lattice / rowdatarange=data columndatarange=data columns=2 rowgutter=10
columngutter=10 columnweights=(0.5 0.5);
      layout overlay / xaxisopts=( reverse=true) yaxisopts=( display=(LINE));
      barchart x=_HL y=_LEFT / name='bar(h)' datatransparency=0.5
stat=mean  orient=horizontal groupdisplay=Stack clusterwidth=1.0;
      endlayout;
      layout overlay / yaxisopts=( display=(TICKVALUES LINE));
      barchart x=_HR y=_RIGHT / name='bar(h)2' datatransparency=0.5 
stat=mean  orient=horizontal discreteoffset=0.08 fillattrs=GraphData2;
      endlayout;
   endlayout;
endgraph;
end;
run;

data gex241;
input age female male @@ ;
cards;
10  10  11    20  13  13    30  14  26
40  26  28    50  20  23    60  13  20
;
run;

proc  sgrender  data=gex241  template=sgbutterfly;
dynamic  _HL="age"  _LEFT="male"  _HR="age"  _RIGHT="female";
run;

proc  sgrender  data=survey  template=sgbutterfly;
dynamic  _HL="sc"  _LEFT="money"  _HR="sc"  _RIGHT="ctime" ;
run;



/***** 付録　*****************************************/
ods  listing  style=Journal ;
title " histogram and density curve"; 
proc  sgplot  data= ex11;
histogram math1;
density  math1;
run ;


data  gexB242 ;
input   a  b  web $ 30. ;
datalines;
30  10   http://www.tuniv.ac.jp/
20  15   http://www.abc.co.jp/
25  20   http://www.mmm.co.jp/
;
run;

ods  graphics  on  /  imagemap=on ;
ods  html  body='text.html' ;
proc  sgplot  data= gexB242; 
 scatter  y= a  x= b /  url= web ;
run ;
ods  html  close ;


title  "Graph testing 3 " ; 
ods  rtf ;
proc  sgplot  data=ex11 ;
 scatter  y=math2  x=math1  ;
run ;
ods  _all_  close;


ods html; 

/******** 演習 *************************************/
/*** (ex2.1)  **************************************/
data e2a;
do i=1 to 100;
x=rand("normal",2,5);
grade=(x ge 7)+(x ge 2)+(x ge -3);
select;
when (i<=25) group="A";
when (i<=50) group="B";
when (i<=75) group="C";
otherwise group="D";
end;
output;
end;
run;


proc sgplot data=e2a;
hbar grade;
run;

proc sgplot data=e2a;
histogram x;
density x;
run;

proc sgplot data=e2a;
vbox x /category=group;
run;

proc sgpanel data=e2a;
panelby group;
histogram x;
density x;
run;


/*** (ex2.2)  *****************************************/
proc  sort   data=survey  out=temp;
 by  ctime;
 run;
proc  sgplot  data=temp;
series  y= money  x= ctime /  datalabel=pin ; 
 run ;
proc  sgplot  data=survey;
 bubble  x=sc  y=area  size=money  / datalabel= money;
format  sc  scfmt. ; 
where  area  in  ("東京", "神奈川", "埼玉", "千葉") ; 
run ;

/*** (ex2.3)  *****************************************/
proc  sgplot  data= gex214;
step  x=year  y=cost  / datalabel ;
step  x=year  y=price  / datalabel ;
run ;

proc  sgplot  data= gex214;
step x=year  y=cost  / datalabel ;
step  x=year  y=price  / datalabel ;
 where  2005 <= year ; 
 xaxis values= (2005 to 2013 by 1) ; 
run ;

proc  sgrender  data=gex214  template=sgbutterfly;
dynamic  _HL="year"  _LEFT="cost"  _HR="year"  _RIGHT="price";
run;



data cov (type=cov);
infile cards;
input _type_ $ _name_  $ x1 x2 x3;
cards;
cov  x1   14  8    0
cov  x2   8    5    -2
cov  x3   0   -2   10
;
run;
proc simnormal data=cov (type=cov) out=sim numreal=200 seed=0;
var x1 x2 x3;
run;

proc sgscatter data=sim;
matrix x1 x2 x3 / diagonal=(normal histogram);
run;
