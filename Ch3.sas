/***** SAS Programming 第３章　マクロ　*****/

data randata;
   seed1 = 0;
   seed2 = 1;
   do  i = 1 to 500 ;
    call  rannor (seed1,x1);
    call  rannor (seed2,x2);
   output;
end;
run;
title  "500 random obs " ; 
title2  "Created by &sysuserid" ;
title3  "seed1 is 0, seed2 is 1";
symbol  v=dot ; 
proc  gplot  data= randata ; 
plot  x1 *x2 ;
run; quit;

%macro mnplot(dtype, s1, s2, n);
data randata ;
seed1= &s1 ;
seed2= &s2 ;
   do i = 1 to &n ;
    call &dtype(seed1,x1);
    call &dtype (seed2,x2);
   output;
   end;
run;
title " &n random obs  by &dtype";
title2  "Created by &sysuserid" ;
title3  "seed1 is &s1, seed2 is &s2"; 
symbol  v=dot ; 
proc  gplot  data= randata ; 
plot  x1 * x2 ;
run; quit;
%mend mnplot ;
%mnplot ( rannor , 0, 1, 500 )
%mnplot (ranuni , 0, 1, 500 )
%mnplot ( rannor , 11111, 22222, 5000 )


/***** データ生成 ***********************/
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
s009  f  78  91
s012  f  91  96
s013  m  63  44
k021  m  80  80
k023  f  56  61
k024  m  72  79
k026  f  89  89
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


/**********  健康診断  health データセット *********/
proc  import  out= health
            datafile= "C:\sas_study\student.xls" 
            dbms=EXCEL  REPLACE;
     sheet="health check"; 
     getnames=YES; 
     mixed=NO;
     scantext=YES;
     usedate=YES;
     scantime=YES;
run;

proc print data=health; 
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


proc print data=survey;
format  sc  scfmt.  career  careerfmt.  ; 
run;

data health ;
 set health;
 label age="年齢" gender="性別" height="身長" weight="体重"
    sleeping="睡眠時間" smoking="喫煙歴" nsmoking="１日の喫煙本数";
format  gender   genderfmt.  ; 
format  smoking  smkfmt.  ; 
 run;
 title "health data" ;
proc  print  data=health  label;
run;

data survey;
 set survey;
 format sc scfmt.  career  careerfmt. ;
data  ex11;
 set  ex11;
 format   gender  $ gfmt.  ; 
run: 
title "student survey";
proc print data=survey  label; run;
title  "Example ex11";
proc  print  data=ex11  label; run;


data  ex11a (drop=tmp);
 set  ex11 ;
length  dept  $  6. ;
tmp = substr(subject,1,1);
 put  "tmp= " tmp ;
 if  tmp="s"  then  dept= "数学";
  else  if  tmp="k"  then  dept = "化学";
  else  if  tmp="b"  then  dept = "物理";
  else  dept = "その他";
label  dept="学科" ; 
proc  print data = ex11a  label;
 run;


/***** データ生成  (終了)　***********************/




/*** 3.1　マクロ入門 ********************************/

%let  ds =ex11 ; 
proc means data= &ds;
run;

%let  ds= ex11;
%let  var= grade;
%let  type= hbar;
title  "Bar chart for &var of &ds";
proc  gchart  data=&ds;
 &type  &var;
run;  quit;

%let  type= vbar3d;
title  "Bar chart for &var of &ds";
proc  gchart  data= &ds;
 &type  &var;
run;  quit;

%let  condition= ave ge 80 ;
title  "&condition" ;
proc  print  data=ex11;
 where  &condition;
run;

%let condition= ave >= 80;
title  "&condition" ;
proc  print  data=ex11;
 where  &condition;
run;

%let  condition=  math1 ge 80 and math2 ge 80 ; 
title  "&condition" ;
proc  print data=ex11;
 where  &condition ;
run;

%let  num=100; 
%let  a= Yamada Taro;
%put   &num;
%put  *** name: &a *** ;

%put  Enter your name ;
%put  名前を入力してください. ;
%put  %str(Enter student%'s name.);
%put  %nrstr(%let v=23.2; );

%let  null= ;
%put  &null ;

%let  sum= 100 + 50;
%put  &sum ;
%let  sum= %eval( 100+50 );
%put  &sum ;
%let  sumf=%sysevalf( 2.53+10 );
%put  &sumf ;

%let  a=10 ;
%let  b=20 ;
%let  s= &a + &b ;
%put  &s ;
%let  s= %eval( &a+&b );
%put  &s ;
%let  d= %eval( &a / &b );
%put  &d ;
%let  df= %sysevalf( &a / &b );
%put  &df ;

%let  city = Yokohama;
title1  "Data of &city on &sysdate9";
title2  'Data of &city on &sysdate9';
proc  print  data=ex11;  run;

options  symbolgen ;
%let  city= Tokyo ;
%put  &city ;
%let  ku= Shinjuku ;
%put  &ku-ku , &city ;

options nosymbolgen;

%macro macsmry; 
proc print data= ex11;
  proc means data= ex11;
  run;
%mend macsmry;
%macsmry 


%macro  macgplot ;
%put  dataset=&ds  varx=&varx  vary=&vary;
symbol  v=star  c=blue  i=&i  cv=orange;
title  "&varx  vs. &vary from &ds dataset";
proc  gplot  data= &ds ;
plot  &varx * &vary ;
run;  quit;
%mend  macgplot ;

%let  ds= ex11 ;
%let  varx= math1 ;
%let  vary= math2 ;
%let  i= none ;
%macgplot

options  mprint ;
%let  i= rl ;
%macgplot


%macro  msincos ;
data  gsc;
  do  x  =  &kaishi  to  &owari  by  &a ;
y = sin(x)**2 - x * cos(x)**2;
output  ;
end ;
run ;
title   "plot using gsc dataset";
title2  "from &kaishi to &owari by &a";
footnote  "&sysdate by &sysuserid";
symbol  i= join ;
proc  gplot  data=gsc;
  plot  y * x;
run;  quit;
%mend  msincos;

%let  kaishi = 0;
%let  owari = 3;
%let  kizaimi = 0.01;
%msincos

%let  owari= 10;
%msincos

%let  kaishi= -30;
%let  owari= 100;
%let  a= 0.1;
%msincos

/****   3.3  マクロのパラメータ（引数）**********************/
%macro  macgplot2( ds, varx, vary, i );
%put  dataset=&ds  varx=&varx  vary=&vary;
symbol  v=star  c=blue  i=&i  cv=orange;
title  "&varx vs. &vary from &ds dataset" ;
proc  gplot  data= &ds ;
plot  &varx * &vary ;
run; quit;
%mend macgplot2 ;

%macgplot2 (ex11,  math1,  math2,  rl )
%macgplot2( ds=ex11 , varx=math1 , vary=math2 , i=rl )
%macgplot2(i=none, vary=ave, varx=math1,ds=ex11)


%macro  macmeans( ds , var , stat) ;
title  "Reported on &sysdate" ;
proc  means data=&ds  &stat ;
var  &var; 
run ;
%mend  macmeans;

%macmeans(ex11,  math1 math2 )
%macmeans(ex11,  math1 math2 ,  mean max min )
%macmeans(stat=mean max min std var range ,  ds=ex11, var= math1 math2 )
%macmeans(ex11)
%macmeans( ds=ex11, var= math1 math2 )


%macro  findval( ds , val= . ) ;
data  _null_;
set  &ds ;
file  print ;
length  varname  $  32 ;
array  v[*]  _numeric_ ; 
do  ii  = 1  to  dim(v) ;
   if  v[ii] = &val  then  do ;
     call  vname( v[ii] , varname) ;
      put  "&val for "  varname  " in case "  _n_;
    end ;
end ;
drop  ii ;
run ;
%mend  findval ;

data  test ;
input  math  eng  ;
cards ;
10  999
999  40
70   999
100   .
;
proc  print ; run ;

%findval (test)
%findval (test , val= 999 )

%macro  a ;
/*  　This macro is sample for comment text   */
%* 　This macro is sample for comment text  ;
*   Date: 2013.01.03 ;
*   Comment: Sample macro program ; 
%mend  a ;
options  mprint;
%a

/***** 3.4  グローバルマクロ変数とローカルマクロ変数 ****************/
%let  x= 10;
%put  x=&x ;

%let  x2= 10;
%macro A(x2); 
%let  x2=1000;
%let  y2= 300;
%put  in: x2= &x2 ; 
%put  in: y2= &y2 ; 
%mend A;

%A(200)
%put  out: x2= &x2;
%put  out: y2= &y2;

%macro A;
%let  x3= 100;
%mend A;

%A
%put  First x3: &x3 ;
%let  x3= 200;
%put  2nd  x3: &x3 ;


%macro C ;
%global  z; 
%let  z= 30; 
%put  z= &z;
%mend C ;
%C 
%put z= &z;

/********* 3.5   自動マクロ変数   ********************************/
title1  "Reported on &sysdate" ;
title2  "Today is &sysday by &sysuserid" ;
proc  print  data= ex11 ;
run ;

%macro  dscopy( ds ) ;
data  ab;
 set  &ds;
 run;
%put  return code is &syserr ;
%if   &syserr NE 0 %then %do ;
%put  NO &ds dataset ;
%return ; 
%end ;

%put &ds dataset is valid ;
proc  means  data= ab ; run; 
%mend  dscopy ;

%dscopy(abcdef123)
%dscopy(ex11)

/********* 3.7  プログラム制御  ********************************/
%macro  mmeans;
proc  means  data=&ds; 
var  &var;
run ;
%mend  mmeans;

%macro  mgchart;
title  "&var of &ds dataset";
proc  gchart  data=&ds;
vbar  &var;
run;  quit;
%mend  mgchart ;

%macro  analyze(ds,var);
%mmeans
%mgchart
%mend  analyze;

%analyze( ex11, math2 )


%macro  mprint (condition, ds);
%if  &condition = prt  %then  %do;
 proc  print  data= &ds ;  run;
%end ;
%else  %put *** condition: &condition *** ; 
%mend  mprint;

options mprint;
%mprint (prt , ex11 )
%mprint ( , class )
%mprint ( N , runtime )


%macro  macmean(stat , ds= _last_ ) ;
proc  means  &stat  data= &ds ;
title 
%if  &ds ^= _last_  %then
"Statistics for dataset &ds " ;
%else
"Statistics for LAST dataset ";
;
run ;
%mend  macmean;

data  one ;
input  x  @@ ;
cards ;
1  2  3  4  5
;
data  two ;
input  y  @@ ;
cards ;
10  12  14  16
;
run ;
%macmean(n mean std,ds=one)
%macmean ( n  mean  std )


%macro  mtest  ;
%do  i = 0  %to  50  %by  10 ;
%put  ** &i : text&i **  ;
%end ;
%mend  mtest ;
%mtest


%macro  nway(n);
data  tmp;
%do  i = 1  %to  &nfac ;
   do  &&fact&i  = 1  to  &&flast&i ;
%end ;
do  k = 1  to  &n ;
   input  x  @@ ;
   output;
end ;
%do  i = 1  %to  &nfac ;
 end ;
%end ;
%mend  nway ;


%let  nfac= 2;
%let  fact1= gender;  %let  flast1= 2 ;
%let  fact2= treat;  %let  flast2= 3 ;
%nway(1)
cards;
10  20  30 
50  60  70
proc  print;
run;
proc  freq ;
table  gender * treat;
weight  x ;
run ;


%macro  runds;
 %do  i = 1  %to  3 ;
 data  student&i  ( label="student&i for Class &i" ) ;
 infile  "c:\sas_study\st&i..txt";
 input  id $  name $  runtime  runpluse ;
 run ;
 %put  **** external file:c:\ sas_study\st&i..txt **** ;
 title  "dataset: student&i";
 proc  print  data= student&i;
 run; 
 %end ;
%mend  runds ;
%runds


%macro sub1(start,end); 
%let y =&start; 
%do %while (&y <= &end);
 title "**sum &y **";
 proc print data=ex11;
 where  sum= &y ;
 run;
%let  y = %eval(&y + 1);
%end;
%mend sub1;

%sub1(180,200)

%macro sub2(start,end) ; 
%let y =&start ; 
%do %until (&y >= &end);
 title "** sum &y ** ";
 proc print data=ex11;
 where  sum= &y ;
 run;
%let y=%eval(&y + 1);
%end;
%mend sub2;

%sub2(180,200)


%macro  mcheck(ds);
%if  &ds=  %then  %do;
  %put  ERROR: No dataset!! ;
  %go to exit ;
  %end;
%else %do ;
  proc  print  data=&ds;
  run; 
%end ;
%exit:  %mend  mcheck;

%mcheck( ) 
%mcheck(sashelp.class )


%macro  colorck(color);
 %goto  &color ; 
%white :
  %put  白： &color  ; 
%goto  next ; 
%red :
  %put  赤： &color ;  
%goto  next; 
%next :
%mend  colorck;
%colorck(white)


%let  n1= one;
%let  n2= two;
%let  n3= three;

%macro  nprnt;
%do  i = 1  %to  3  ;
%put  *** &&n&i ***  ; 
%end ;
%mend  nprnt ;
%nprnt


%macro  stdds;
%do  i = 2001 %to 2003 ;
data year&i.Student (label="&i.student") ;
infile "c:\sas_study\&i.year.txt";
input id math eng gender $ ;
run;
%put **** external file: c:\tmp\&i.year.txt **** ;
title "dataset: year&i.Student"; 
proc print data=year&i.Student;
run;
%end;
%mend  stdds;
%stdds

/*  単純移動平均(simple moving average) */
%macro print(ds, obs=max);
proc print data=&ds (obs=&obs);
title "The data &ds, N=&obs";
run;
%mend print;
%macro mova(ds, r_ds, var, r_var, n);
data &r_ds;
set &ds;
y1=&var;
%do i=1 %to &n;
%let d=%eval(&i+1);
y&d=lag&i(&var);
%end;
time=_n_;
if _n_  lt &n then do;
&r_var=.;
end;
else do;
&r_var=mean(of y1-y&n);
output;
end;
drop y: ;
run;
data &ds;
merge &ds &r_ds; 
by time;
%print(&ds);
%mend mova;

data  temp;
input  x;
time= _n_;
cards;
5.9
5.5
10.7
14.7
18.5
21.3
27.0
26.8
24.4
19.4
13.1
9.8
6.8
7.8
10.0
15.7
20.1
22.5
26.3
26.6
23.0
19.0
13.5
9.0
7.0
6.5
9.1
12.4
19.0
23.6
28.0
29.6
25.1
;

data  temp ;
set  temp ;
%mova(temp,rtemp,x,xm,3)
%mova(temp,rtemp,x,xm1,6)
proc  sgplot  data=temp;
  series  x=time  y=x;
  series  x=time  y=xm;
  series  x=time   y=xm1;
run;


/********* 3.8 マクロ関数   *****************************/
%macro  a ;
%let  x1= 2; 
%let  x2= 3;
%put  &x1 ** &x2 ; 
%put  %eval(&x1 ** &x2) ; 

%if  &x1 ** &x2 = 8  %then  %put ** True!  ** ; 
%else  %put  ** NOT  8 !  *** ; 
%mend  a;
%a 


%macro  calcnum(a,b);
 %let  y= %sysevalf(&a+&b);
 %put  SYSEVALF value: &y;
 %put  BOOLEAN option: %sysevalf(&a +&b, boolean);
 %put  CEIL option: %sysevalf(&a +&b, ceil);
%put  INTEGER option: %sysevalf(&a +&b, int);
 %mend  calcnum;
%calcnum( 10, 1.31)
%calcnum(-10, 1.31)


%macro  yearck(dsn);
 %if  %substr(&dsn,5,4)  LT  2000  %then  %do ;
   %put  ERROR: &dsn は 2000年以前のデータです!  ;
   %goto  exitmac;
 %end ;
 %else  %put  OK: &dsn は有効なデータです.  ; 
 %exitmac:
 %mend yearck;

 %yearck(year2010)
 %yearck(year1999)
%yearck(ABCD2000)


%put  %upcase(Japan);
%let  _prefecture= Saitama;
%put  %upcase(&_prefecture);

%let  text= Red Green Blue ;
%put  Blue position: 　%index(Red Green Blue,Blue);
%put  blue position: 　%index(Red Green Blue,blue);  
%put  Blue(&text) position: 　%index(&text,Blue);

%put %bquote(Enter Company's name.);
%put %str(Enter Company%'s name.);

%put  %str(  dog (;)   　cat);
%put  %nrstr( %let a=1; %put &a; );

%macro  ccode(x);
%if  %quote(&x)= JPN %then %put  &x is JPN;
%else  %put &x is not JPN ;
%mend  ccode ;

%ccode(AND)


%macro  macmean;
%let  m=%sysfunc(mean(1,2,3,4));
%put  ## &m ## ; 
%mend  macmean;
%macmean 

%macro pnormal;
%do x= -3 %to 3 ;
%let cdf=%sysfunc(probnorm(&x));
%put  ***  &x:  &cdf  ***  ; 
%end; 
%mend pnormal;
%pnormal

%macro steppnormal;
%do  x = -30  %to  30  %by  1;
%let  x2 = %sysevalf(&x * 0.1);
%let cdf=%sysfunc(probnorm(&x2));
%put  **  &x2:  &cdf  **  ; 
%end; 
%mend steppnormal;
%steppnormal

%macro  existds(dsn);
%sysfunc(exist(&dsn)) 
%mend existds;

%put  %existds(sashelp.class);
%put  %existds(sashelp.classss);

proc  format ;
  value  category
  Low -< 0  = 'ゼロより小さい値'
  0  = 'ゼロ'
  0 <- high  = 'ゼロより大きい値'
  other  = '欠損値';
run ;
%macro  numcheck(v);
%put  &v ：%sysfunc(putn(&v,category.));
%mend;
%numcheck(0.02)
%numcheck(-0.19)
%numcheck(.)


/***** 3.9  DATA ステップとのインターフェース ***/
data  mathscore ;
input  id $ math  @@ ;
n+1;
if  math  eq  '.'   then err+1;
call  symput('obs' ,  left (put (n , best.))) ;
call  symput('missing' , left (put (err , best. )));
datalines ;
S106  80  S109 .  S110  67  S112  .
;
data  errsummary ;
ds= 'mathscore' ;
total= &obs ;
countmissing = &missing;
;
proc  print ;  run ;


data  _null_ ; 
set  mathscore  end= eof ;
n+1 ;
if  math  eq  '.'  then  err + 1 ;
if  eof  then  call symput('obs' ,  left (put (n , best.))) ;
if  eof  then  call symput('missing' ,  left (put (err , best.))) ;
run ;
%put  Total obs : &obs ; 
%put  missing : &missing;


data  _null_;
call  symputx('  items  ', ' Score for Mathematics   and     English  ');
call  symputx('  y   ',      34.9823423    );
run ;
%put  items = **&items** ;
%put  y = **&y** ;


data  _null_;
   call  symput('mv1' , 'Dog & Cat' ) ;
   call  symput('mv2' , '%macro prnsum ;' ) ;
   call  symput('mv3' , '%let x=23.543 ;' ) ;
run ;
%put  %superq(mv1);  
%put  %superq(mv2); 
%put  %superq(mv3);


%macro prnt;
 proc print data=ex11;
%mend prnt;

data _null_ ;
 call execute('%prnt') ;
 run; 


/***** 3.10   乱数の応用   **********************************/
%macro mranuni;
   %do i = 1 %to 5;
      %let x = %sysfunc (ranuni (0)); 
      %put &x;
   %end;
   %mend mranuni;
%mranuni


%let  x1= 赤 ;
%let  x2= 白 ;
%let  x3= 黄 ;
%let  x4= 青 ;
%let  x5= 緑 ;
%macro mpermute(n, k);
data  _null_;
array x $  x1-x5 ("&x1" "&x2" "&x3" "&x4" "&x5");
 seed = 0;
 put  "** &k 色を選ぶ **"  / ; 
 do  i = 1  to  &n ;
  call  ranperk(seed , &k , of  x1-x5 ) ; 
  put  ' x= ' x1 - x&k;
 end ;
run ;
%mend  mpermute ;
%mpermute(k=3 ,  n=10)


%macro  moutfile(n);
%do  i  =  1  %to  &n ;
   %let  x = %sysevalf( 10**10 * %sysfunc(ranuni(0)) ,  integer ) ;
   %let  fname ="c:\tmp\Tmp&x..txt";
data  _null_ ;
  file  &fname ;
    put  "*** i= &i / &n ***" ; 
    put  "file name = %bquote(&fname)" ; 
 run ;
%end ;
%mend  moutfile;
%moutfile(3)


data pidata ;
length group $ 3.;
keep i x y group ;
pi=0.0 ; rep=50;
do i=1 to rep;
  group='Pi'; x=i/rep; y=sqrt(1-x**2);
  output;
  x=ranuni(0); y=ranuni(0);
  dist=sqrt(x*x + y*y);
 if dist < 1 then group='In';
   else group='Out';
  output;
 end;
run;
title  "50 plots by ranuni function";
title2 h=1.5 "Monte Carlo Methods";
title3 h=1.5 "Created by &sysuserid on &sysdate9 ";
symbol  i=none  v=dot  c=red;
symbol2 i=none  v=trianglefilled  c=blue;
symbol3 i=join  v=none c=black  h=2;
axis1 length=8cm label=none v=(h=1.5) ;
proc gplot data=pidata;
plot y * x = group /
 haxis=axis1 vaxis=axis1;
run; quit;

%let  n= 100; 
data pidata ;
length group $ 3.;
keep  i x y group ;
pi=0.0 ; rep= &n ;
do i=1 to rep;
  group='Pi'; x=i/rep; y=sqrt(1-x**2);
  output;
  x=ranuni(0); y=ranuni(0);
  dist=sqrt(x*x + y*y);
 if dist < 1 then group='In';
   else group='Out';
  output;
 end;
run;
title  "&n plots by ranuni function";
title2 h=1.5 "Monte Carlo Methods";
title3 h=1.5 "Created by &sysuserid on &sysdate9 ";
symbol  i=none  v=dot  c=red;
symbol2 i=none  v=trianglefilled  c=blue;
symbol3 i=join  v=none c=black  h=2;
axis1 length=8cm label=none v=(h=1.5);
proc gplot data=pidata;
plot y * x = group /
 haxis=axis1 vaxis=axis1;
run; quit;

%let  n= 100 ; 
data pidata2(keep= i times pi cin ); 
pi = 0.0; 
retain cin times 0;
 do i=1 to &n ;
   x=ranuni(0);  y=ranuni(0);
   dist=sqrt(x*x + y*y);
   if dist < 1 then cin = cin + 1;
   times = times + 1;
   pi = 4 * cin / times; /* モデル：π = 4 *内側プロット数/総数*/
   put i:  "pi="  pi;  /* ログウィンドウに pi を表示 */ 
   output;
 end;
 run;
title "Simulated pi from ranuni function";
proc print data=pidata2 noobs;
 where times in 
 (1 5 10 50 100 500 600 800 1000 2000 3000 5000 10000) ;
 var times cin pi ;
run;
%let  n= 100 ; 
data pidata2(keep= i times pi cin ); 
pi = 0.0; 
retain cin times 0;
 do i=1 to &n ;
   x=ranuni(0);  y=ranuni(0);
   dist=sqrt(x*x + y*y);
   if dist < 1 then cin = cin + 1;
   times = times + 1;
   pi = 4 * cin / times;   /* モデル：π = 4 *内側プロット数/総数*/
   put i:  "pi="  pi;  /* ログウィンドウに pi を表示 */ 
   output;
 end;
 run;
title "Simulated pi from ranuni function";
proc print data=pidata2 noobs;
 where times in 
 (1 5 10 50 100 500 600 800 1000 2000 3000 5000 10000) ;
 var times cin pi ;
run;


title "Simulatied pi from rauuni function";
symbol i=join c=blue;
proc  gplot  data=pidata2;
 plot  pi * i /  vref=3.14 cv=red;
run;

/****** 3.11  ストアードマクロ   ******************************************/
libname  mylib  "c:\tmp\macro";
options  mstored  sasmstore=mylib; 

%macro  macm (ds, var, stat)  /  store  des='要約統計量マクロ';
title  "Reported on &sysdate" ;
proc  means  data= &ds  &stat ;
  var  &var ;  run ;
%put  ds=&ds  var=&var  stat=&stat ;
%mend  macm;

libname  mylib  "c:\tmp\macro";
options  mstored  sasmstore=mylib ; 
%macm (ex11 , math1 , mean min max )

*options  nomstored ;


options  mstored  sasmstore=sasuser; 
%macro  nncheck(num)  / store  source ;
%if  %sysevalf(&num) >= 10  %then  %put ** 10 以上 ** ;
%else  %put ** 10 未満 **;
%mend  nncheck;

%copy  nncheck  / lib=sasuser  out='c:\tmp\nncheck.sas' src;


/***** 付録 *******************************************************/

%put  _automatic_  ; 

%put  _GLOBAL_  ; 


%macro mmeans(ds, var, stat);
proc means data=&ds &stat;
  var &var;
%put &sysuserid on &sysdate9 ; 
%put データセット： &ds;
%put 統計量：&stat; 
run;
%mend mmeans;
%mmeans(ex11, math1, mean max min)


options  nomprint  nosymbolgen  nomlogic ;




/***** 演習 *******************************************************/

goptions reset=all;

%mnplot ( rannor , 11111, 22222, 5000 )
%mnplot ( rannor , 44444, 33333, 5000 )

%let  x=Tokyo ; 
%let  y=Over the rainbow;
%let  a1= 5;

%put &x;
%put &y;
%let ans1=&x&y;
%put &ans1;
%let ans1=&x &y;
%put &ans1;
%let ans2= &a1 + 1;
%put &ans2 ; 
%let ans2= %eval(&a1 + 1);
%put &ans2 ;

%let n1=2;
%let n2=3;
%let n3=10;
%let n4=30;
%let n5=101;

%let dsn=ex11;
%let varlist=subject grade gender ave;
proc print data=&dsn;
var  &varlist;
run;



%macro n3;
%do i = 1 %to 5 ; 
   %let    y= %eval(&&n&i**3);
  %put  n&i : &&n&i :  *** &y ***  ; 
%end;
%mend n3;
%n3

data n5ci;
mu=1;sigma=2;
do j=1 to 20;
 do i = 1 to 10;
   x= mu + sigma*rannor(0);
   output;
 end;
end;
run;
proc means data=n5ci clm mean std noprint alpha=0.1 ; 
by j;
var x;
output out=t1 lclm=l1 uclm=u1 mean=m1;
run;

proc sgplot data=t1;   
title "95% CI"; 
scatter x=j  y=m1;
highlow x=j  low=l1  high=u1/ legendlabel="95%";
refline 1 / axis=y;
yaxis display=(nolabel);
run;

%macro ciplot(mu, sigma, rep, nsamp, a);
data n5ci;
mu=&mu; sigma=&sigma;
do j=1 to &rep;
 do i = 1 to &nsamp;
   x= mu + sigma*rannor(0);
   output;
 end;
end;
run;
proc means data=n5ci clm mean std noprint alpha=&a ; 
by j;
var x;
output out=t1 lclm=l1 uclm=u1 mean=m1;
run;
proc sgplot data=t1;   
%let confc=%sysevalf(100*(1-&a)) ;
title "&confc % CI"; 
label m1="sample mean";
scatter x=j  y=m1;
highlow x=j  low=l1  high=u1/ legendlabel="&confc %";
refline &mu / axis=y;
yaxis display=(nolabel);
run;
%mend ciplot;

%ciplot(1, 2, 100, 10, 0.05)

%ciplot(1, 2, 100, 5, 0.5)


%ciplot(1, 2 , 100, 50, 0.5)



%macro resample1(inds, outds,n);
    data  &outds;
    set  &inds  nobs=total;
    if  i < &n  then do;
	  a=ranuni(0) ; put a= ;
       if  a < 0.5 then do;
         i+1;
         output;
       end;
     end;
	 drop  i;
    run;
 %mend resample1;

 %resample1(ex11, ex11sample, 4)
proc  print  data=ex11sample ;
run;

%macro resample2(inds,  outds,  n) ;
data  tmp;
set  &inds;
u= ranuni(0); 
run;
proc  sort  data=tmp  out=rs;
by  u ;
run;
data  &outds;
set  rs(obs=4);
*drop u;
run;
%mend  resample2;

%resample2(ex11, ex11sample, 4)
proc  print  data=ex11sample;  run;



%macro resample3(inds,  outds, n);
proc  surveyselect  data=&inds  out=&outds
method=srs  sampsize=&n  seed=0; 
run;
%mend resample3;

%resample3(ex11, ex11sample, 4)
proc  print  data=ex11sample;
run;




