/************************************************************************************/
/***** データ解析のためのSAS入門　 **************************************************/
/***** バージョン: ２版　　**********************************************************/
/***** 作成： 宮岡悦良, 吉澤敦子  ***************************************************/
/***** 日付:  2014/02/07 　**********************************************************/
/************************************************************************************/

/**** 第1章　　SASへの入門 **********************************************************/

/**** 1.1　SASへの招待**************************************************************/

data ex111;
input id gender $ height weight;
 hyoujun = (height - 100) * 0.9;
bmi = weight/((height / 100)**2) ;
himando1 = (weight - hyoujun) / hyoujun * 100;
if himando1 > 20 then himan1 = 1;
  else himan1 = 0;
cards;
1  m  160  70
2  m  176  78
3  f  153  50
4  f  167  55
5  m  158  53
6  f  163  52
7  f  167  72
8  m  174  83
9  m  176  92
10 f  152  54
;
run;
proc print data=ex111;
run;

proc means data = ex111  n  mean  std  var  min  max  range  maxdec=3 ;
    var  height  weight;
proc freq  data = ex111;
    tables  gender  himan1;
run;

proc  means  n  mean  std ;
    var  height  weight;
  class gender;
run;


title; 
data ex112;
length  smoking $ 10;
input cancer $ smoking $ count;
cards;
no  smokers 32
no  nonsmokers 11
yes smokers 60
yes nonsmokers 3
;
run;
proc freq  data = ex112;
 tables  cancer * smoking;
 weight  count;
run;

title; 
data ex113;
 do x =  -3 to 3 by 0.01;
   y = sin(cos(-x**2));
   output;
 end;
 run;
proc  gplot  data=ex113;
 plot  y*x;
 symbol i=join  v=none;
run; 
quit;

data ex114;
do  x =  -3 to 3 by 0.1;
  do  y =  -3 to 3 by 0.1;
   z = sin(sqrt(x**2 + y**2));
   output;
  end;
end;
run;
proc g3d data=ex114;
plot  y*x = z / rotate=30 tilt=45 ;
run; 
quit;

data rnorm1;
 do i = 1 to 1000;
   z  = rannor(12345);
 output;
 end;
run;
title    '1000 random observations from';
title2   'Standard Normal Distribution';
proc  gchart  data= rnorm1;
 vbar z ;
run;

/***  1.2　SASプログラミング  ******************************************************/
title ; 
data;
input  A1 a2 aB abC;
cards;
1 2 3 4
;
proc  print;
var  a1 A2 ab ABC;
run;

data ex121;
 input  x  y1  y2  z  $;
cards;
 1   2   3  a 
-1  -2  -3  b 
 0   1  10  c 
 5  12  29  c
;
run;
title 'Result of program 1.2.2.1'; 
proc  print data=ex121;
 var  y1  z ;
run;

data;
length  name $ 20;
input  name & $;
cards;
abcdefgh ijklmnopqrstuvwxyz
;
title 'Result by program 1.2.2.2'; 
proc  print;
run;

data; 
 input  @1 v1 1.  @2 v2 1.  @3 v3 1.
  @4 v4 1.  @6 age 2.  @9 gender $1.;
cards;
1231 23 F
2143 19 F
2214 18 M
3111 20 M
2144 22 F
;
run;
title 'Result by program 1.2.2.3';
proc  print;
run;

data; 
input  v1  1  v2  2  v3  3  v4  4  age 6-7  gender $ 9;
cards;
1231 23 F
2143 19 F
2214 18 M
3111 20 M
2144 22 F
;
title 'Result by program 1.2.2.6';
proc print;
run;

data; 
input #1 (id) (3.) @5 (v1-v4) (1.) 
  #2 @6 (age) (2.) @9 (gender) ($1.);
cards;
001 1231 
001  23 F
002 2143 
002  19 F
003 2214
003  18 M
004 3111
004  20 M
005 2144 
005  22 F
 ;
title 'Result by program 1.2.2.7';
proc print;
run;

data;
input  @1 name $  @10  birthday yymmdd10.  @22  salary comma6.;
cards;
Randy    1963/07/29  75,000
Tom      1975/03/16  65,000
;
title 'birthday and salary data';
proc  print ;
run;

proc print ;
format  birthday nengo. ;  /* 年号で表示する */
run;

data;
input x 3.1 @7 y 4.;
cards;
123   123
12.3  12.3
;
title 'Result by program 1.2.2.9';
proc print; run;

data;
input  y  $char7.  z  $;
cards;
a b cd   e
a b  cd   e
;
run; 
title 'Result by program 1.2.2.10';
proc  print;  run;

data;
input id 1-3   x  5  y  7-8  z 10  x1  12  x2  14  x3  16 ;  
cards;
 001 2 34 5 7 8 9
;
run;

data;
input  x  y  @@ ;
cards;
1 2 3 4 5 6
; 
title 'Result by program 1.2.2.11';
proc  print;  run;

data;
input x  @;
input y  @;
input z;
cards;
1 2 3 4 5 6
;
title 'Result by program 1.2.2.12';
proc  print;  run;

data ex122;
infile  'student.txt';
input x y1  y2  z $;
run;
title  'Report of student score'; 
title2 'from student.txt';
proc  print  data = ex122;
 var  y1  z ;
run;

data;
infile 'student.csv' delimiter = ',';
input  v1-v4  age  gender $ ;
run;
title  'Report of Student score';
title2 'from student.csv';
proc  print;
run;

/***  1.3　データ加工  ******************************************************/
title; 

data ex131;
length  city $ 10;
input  city $  temp;
 temF = 32 + temp*9/5;
cards;
Tokyo 22
NewYork 17
Sydney 3 
Honolulu 30
;
title 'temperature list by city';
proc  print ;
run;

data ex132;
input  gender $  height  weight  age;
if gender = "m" then
  cal = 66 + 13.7*weight + 5*height - 6.8*age;
 else if gender = "f" then
  cal = 655 + 9.6*weight + 1.7*height - 7*age;
cards;
m 160 70 25
m 170 65 30
m 155 52 16
f 155 40 21
f 160 58 35
;
title 'basal metabolism rate';
proc  print;
run;

data;
input  x  y  $ ;
if  y in ('a','c') then z=10 ; else z=0;
cards;
1 a
2 a
3 b
4 b
5 c
;
title 'Result by program 1.3.1.3';
proc  print;  run;

data;
input x ;
select(x);
 when(1)  z = 10 ;
 when(2)  z = 20 ;
 when(3)  z = 30 ;
 otherwise  z = 0 ;
end;
cards;
1
2
3
4
5
;
title 'Result by program 1.3.1.4';
proc  print; run;

data ex133;
do  i = 1 to 5;
  i2 = i**2 ;
  output ;
end;
title;
proc  print;
run;

title; 

data ex134;
do  k = 1  to  5  by  3 ;
i2 = k**2 ;
output;
end;
proc  print;
run;

data out1 out2;
do  i = 1 to  5 ;
  output out2 ;
end;
proc  print data=out2; run;

data ex135;
do  i = 1 to 3;
  do  j = 2 to 5;
    x = i + j ;
    output;
  end;
end;
proc  print;
run;

data;
k = 0;
do while (k<=3);
  k2 = k**2;
  output;
  k = k+1;
end;
proc print; run;

data;
k = 0;
do until (k>3);
  k2 = k**2;
  output;
  k = k+1;
end;
proc print; run;

/***** 1.4　データセットの操作 ****************************************************/
title; 

data old;
input  x  y;
datalines;
1 2
3 4
;
data new;
set old;	
z = x + y ;
drop x;
run;
proc print data=new; run;


data s1;
input a b;
cards;
1 22
3 12
7 34
3 76
4 65
2 56
;
title 's1 dataset';
proc print data=s1 ;
run;
proc sort data=s1 out=s2;
by a;
title 's2 dataset - sorted data';
proc print  data=s2;  run;

proc sort  data=s1  out=d1;
by  descending  a;
title 'd1 dataset to sort by descending variable a';
proc  print  data=d1;
run;

title; 
data one;
input  x  y ;
cards;
1 2
3 4
;
data two;
input  x  y ;
cards;
9 8
7 6
;
data  both;
set one two;
run;
title 'both dataset (concatenation)'; 
proc print  data=both; 
run;

title;
data one;
input  x  y ;
cards;
1 2
3 4 
;
data two;
input  z  w ;
cards;
9 8 
7 6 
;
data three;
 merge  one  two ;
run;
title 'three dataset (merge)';
proc print  data=three; run;

data one;
input  a  b  c $ ;
cards;
1 25 blue
2 26 white
3 27 black
;
data two;
input  a  x  y  $ ;
cards;
1 51 m
2 52 m
3 53 f
;
proc sort  data=one;
 by  a ;
proc sort  data=two;
 by  a;
data three;
 merge  one  two;
 by  a;
proc print data=three;  run;


/*** 付　　録 ***********************************************************/
title;
options  validvarname = any ;

data totals;
   length  部署 $ 5  地域 $ 4 ;
   input  部署  地域  四半期  売り上げ ;
cards;
第1課   東京   1 70430
第1課   大阪　 1 82255
第1課   福岡   1 55436
;
run;
title  '地域別売り上げ';
proc  gchart  data=totals ;  
  format  売り上げ yen8. ; 
  vbar3d  地域 / sumvar = 売り上げ  width=20 ; 
run; quit; 

title; 
data ex1out;
 set  ex111;
file  "c:\tmp\out.txt";
put  id @3  gender $  @5 height  @10  weight  @14  hyoujun  4.3  @20 
      bmi  6.3  @30  himando1  6.3  @40  himan1;
run;

data _null_;
input x;
file  print;
put @5 'x=' +2 x 5.3;
cards;
23.45
;
run;

data data1;
filename  stdfile  'c:\tmp\student.dat' ;   /* ファイル参照名の割り当て */
infile  stdfile ;
input  x  y1  y2  z  $ ;
run;
proc print data= data1;
run;

data data2;
infile 'c:\tmp\studentm.dat' missover ;
input  x  y1  y2  z ;
run;
proc print  data= data2;
run;

data data3;
infile 'c:\tmp\studentm2.csv'  delimiter=',';
input  v1-v4  age  gender $ ;
run;
proc print data=data3;
run;

data data3;
infile 'c:\tmp\studentm2.csv'  delimiter=',' dsd;
input  v1-v4  age  gender $ ;
run;
proc print data=data3;
run;

data data4;
infile 'c:\tmp\sample1.dat'  truncover;
input  a  5.  @7  b  5.2;
run;
proc print data=data4;
run;

data student;
input  subject $  tanaka  yoshida  kato  sasaki  nishi ;
cards;
math   80 75 80 90 85  
eng     85 90 75 80 65  
kokugo  65 65 70 90 90  
;
proc print  data=student;  run;
proc transpose  data=student  out=new ;
run;
proc print data=new; run;

proc transpose  data=student  out=new1  name=namae;
 id  subject;
run;
proc print; run;

data one;
input  a  b  c  $;
cards;
1 25 blue
2 26 white
3 27 black
;
data two;
input  a  b  c  $;
cards;
1 25 blue
2 26 white
3 23 black
4 30 orange
;
proc  compare  base=one compare=two ;
run;

proc  contents  data=three ;
run;

data  ex1f;
 input name $  number ;
 cards;
 TANAKA 23 
 SUZUKI  . 
 NAKADA  19 
 NAKAMURA 13 
 nakada  22
 SUZUDA  33
 suzuda . 
 ;
 proc print data=ex1f;run;

proc print  data= ex1f;
where  substr(name,1,4)='NAKA';
run;

/****  1章・演習問題 *********************************************************/
title ;
goptions reset= all ;

data;
fact = 1;
do  i = 1  to  10 ;
fact = fact*i ;
output;
end;
proc print;  run;


data;
input x1 - x3 ;
 m = mean(of  x1 - x3 );
datalines;
1 2 3
2 4 5
3 8 .
8 . 4
;
proc print;  run;

data;
k = 2;  m = 1;
y = poisson(1, k) ;
file  print ;
put  "P(Y <= " k ")="  y;
run;

data;
k = 2 ; m = 1;
t = date();
x = mdy(1,1,1961);
d = day(x); m = month(x);  y = year(x);
file print;
put  "date()="  t;
put  "mdy(1,1,1961)="  x;
put  "day(x)="  d;
put  "month(x)="  m;
put  "year(x)="  y;
run;

data;
infile  datalines  dlm=',';
input id x y $;
datalines;
111, 1,ab
112,2, cd
;
proc print;run;

data;
input city $ x;
if  city =:'y'  then  x=x+100;
cards;
tokyo 90
yokohama 80
yoyogi 80
mejiro 70
;
proc print; run;


