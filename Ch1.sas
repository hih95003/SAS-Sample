/***** SAS Programming 第1章：　利用するデータセット作成 ******/
/***** 作成： 2013   ******************/


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
run ;


title  "Example ex11";
proc  print  data=ex11 ;
run; 
title  "Sorted by the grade" ;
proc  sort  data=ex11  ;
  by  grade;
proc  print  label;
run;


title  "数学1 成績" ; 
proc  means  data= ex11;
var math1;
class  gender ;
proc  gchart  data= ex11;
pie  grade /  group= gender  across=2; 
hbar  gender  / sumvar=math1  type=mean  width=15  ;
run ;


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
proc print data=survey (obs=10) ; 
run;


/***  1.2	データセットの加工   ************/
proc  format ;
value  scfmt 1="大変満足"  2="満足" 3="普通" 4="不満足" 5="大変不満" ; 
value  careerfmt 1="就職"  2="進学" 3="教員" 4="その他" ; 
value  genderfmt  0="男"         1="女" ;
value  smkfmt   0="喫煙歴なし"  1="喫煙" ; 
value $  gfmt   "m"= "男"   "f" = "女" ; 
run;

proc  print  data=survey;
format  sc  scfmt.  career  careerfmt.  ; 
run;


data  health ;
 set  health;
 label  age="年齢"  gender="性別"  height="身長"  weight="体重"
        sleeping="睡眠時間"        smoking="喫煙歴"   nsmoking="１日の喫煙本数" ;
format  gender   genderfmt.  ; 
format  smoking  smkfmt.  ; 
 run;
title  "health data" ;
proc  print  data=health  label;
run;


data survey;
 set survey;
 format sc scfmt.  career  careerfmt. ;
data  ex11;
 set  ex11;
 format   gender  $ gfmt.  ; 
run; 
title "student survey";
proc print data=survey  label; run;
title  "Example ex11";
proc  print  data=ex11  label; run;


proc  format lib=sasuser ;
value  scfmt 1="大変満足"  2="満足" 3="普通" 4="不満足" 5="大変不満" ; 
value  careerfmt 1="就職"  2="進学" 3="教員" 4="その他" ; 
value  genderfmt  0="男"         1="女" ;
value  smkfmt   0="喫煙歴なし"  1="喫煙" ; 
value $  gfmt   "m"= "男"   "f" = "女" ; 
run;

proc  format  lib=sasuser  fmtlib ;
run ;


proc  contents data=survey;
run;
proc  contents  data=survey  varnum ; run;


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


data  s_ex11a  k_ex11a  o_ex11a ; 
drop tmp;
 set  ex11a ;
length  dept  $  6. ;
label  dept="学科" ; 
tmp = substr(subject,1,1);
 if  tmp="s"  then  do; 
  dept= "数学";  
output  s_ex11a; 
 end;
 else  if  tmp="k"  then  do ; 
  dept = "化学";  
output  k_ex11a; 
 end;
else do;  
  dept = "その他";  
output  o_ex11a; 
 end;
 run; 
title "化学科データ" ; 
 proc  print  data=k_ex11a  label;
 run; 


/***** 1.3	　いろいろなタイプのデータ入力  ******/
title ; 
data ; 
file  print ;
 obs= _n_ ;
input  y  ;
 put  "y=" y  "obs= " _n_  ; 
 cards;
  11
  15
  8 
  3
 ;
run:
proc  print ; run;


data ; 
input  y  ;
idno + 1 ;
 cards; 
  11
  15
  8 
  3
  ;
 proc  print ;  run;


data ; 
retain  indo  0 ;
input x ;
indo = indo + 1 ; 
cards;
10
-3
5
9
0
;
proc print;run;


data;
input  x;
x_lag=lag(x);
x_lag2=lag2(x);
x_lag3=lag3(x);
cards;
10
-3
5
9
;
proc print; run;


data;
input  x ;
x_dif=dif(x);  
x_dif2=dif2(x); 
x_dif3=dif3(x);
cards;
10 
 -3 
 5 
 9
;
proc print; run;


data  repeat;
input  id  gender$  y1  y2  y3;
array  n_y{*}  _numeric_  ;
do i=1  to  dim(n_y);
  time=i;
  y= n_y(i);
  output;
  end;
keep  id  gender  time  y;
cards; 
001 M  1 2 3
002 F   0 4 5
003 F   10 11 12
;
run;
proc print data=repeat; run;


data one;
input  x  y ;
cards ;
 1  2
 ;
proc  print  data=one;  run;

 data two;
 if  _n_=1 then set one;
 input z;
 cards;
 10
 11
 12
 ;
 proc  print  data=two; run;


data  two;
merge  one;
 input z;
 cards;
 10
 11
 12
 ;
proc  print  data=two;
run;


data  two;
 if  _n_=2  then  set one;
 input  z ;
 cards;
 10
 11
 12
 ;
 proc  print  data=two;  run;


data  set1 ;
input  id $  name $ ;
cards;
s201  a
s202  b
s203  c
s205  e
s208  h
;
proc  print  data= set1;  run;

data  set2; 
input  id $  score;
cards;
s201   80
s202   67
s205   92
s207   100
;
proc  print  data= set2;  run;

proc  sort  data= set1;
by  id  ; 
proc  sort  data= set2;
by  id ;
data  set3; 
merge  set1  set2;
by  id;
proc  print  data= set3; run;


data  set4 ;
merge  set1(in=mis1)  set2 (in=mis2) ;
by  id;
put  mis1=   mis2=  ; 
if  mis1  and  mis2;
run; 
proc  print  data=set4 ;  run;


data  master;
input  name $  x  y ;
cards;
a  11  30
b  8   45
c .     20
e  15  50
; 
proc  print  data=master;  run;


data  new;
input  name $  x  z ;
cards;
a   3    100
c   5    110
d  55    130
;
proc  print  data=new; run;

proc  sort  data=master;
by  name;
proc  sort  data=new;
by  name;
data  now; 
update  master  new ;
by  name ;
run;
proc  print  data= now;  run;


data  comb;
set  master  new;
by  name ; 
run;
proc  print  data=comb;  run;

data  two;
 if  _n_=2  then  set  one;
 input  z ;
 cards;
 10
 11
 12
 ;
 proc  print  data=two;  run;



data  one;
input  group $  x;
cards;
 A 10
 B 14
 A 11
 C 19
 A 22
 C 25
 A 12
 A 13
 B 33
 C 35
 ; 
 proc sort data=one;
 by group;
 run;
proc  print  data=one;  run;

data  two; 
set  one;
by group;
first = first.group;
last = last.group;

proc  print  data=two;
run;


data  three;
set  two;
if  first=1  then  num=0; 
num+1 ;
if  last=1  then  output;
keep  group  num;
run;
proc  print  data=three; 
run;


data one; 
input  id  period  x ;
cards;
1  1  -4
1  2  -2
1  3   4
2  1  -2
2  2  1
3  1  1
3  2  5
4  1  -1
;
proc  sort  data=one;
by  id  period;
proc  print  data=one;
run;

data  two;
set  one;
by  id;
if  first.id=1  then  count=0; 
if  x>0  then  count+1;
if  last.id=1  then  output;
drop  x;
run;
proc  print  data=two; run;


data a;
   do  block = 1  to  3 ;
      do  site = 1  to  4 ; 
         x = ranuni(0); 
         output;
      end;
   end;
proc  sort; 
by  block  x ;
data c ;  set a ;
   trt = 1 + mod(_N_ - 1, 4);	
/* mod = remainder of _N_/4 */
proc sort;
 by  block  site ;
proc  print ;
   var  block  site  trt ;
run;


data  weight2;  
infile  datalines  missover; 
input  IDnumber $  Week1  Week16;  
WeightLoss2 = Week1 - Week16;
datalines;  
2477 195  163
2431 
2456 173  155
2412 135  116
;     
proc print data=weight2; 
run; 


data  m999;
array  d{*}  x1  x2  y1  y2  z ;
input      x1  x2  y1  y2  z ;
do  i =1 to 5;
if  d{i} = 999  then  d{i}= .  ;
end;
drop i ; 
cards;
2 0 999 1 1
1  2  3 4  999
3 11 12 13 14
;
run; 
proc  print  data=m999;
run;


data m999NA; 
input  x  $  x1 y1 y2 z;
array  n_d{*}  _numeric_ ;
array  c_d{*}  _character_ ;
do  i=1 to  dim(n_d);
if  n_d{i}=999  then  n_d{i}= .  ;
end;
do  j=1 to dim(c_d);
if  c_d{j}  in ('NA' 'na')  then  c_d{j}= " "  ;
end;
drop  i  j ;
cards;
a 0 999 1 1
NA  2  3 4  999
na 11 12 13 14
;
run;
proc print data=m999NA;
run;




data  investment; 
   begin = '01JAN2001'd;
   end =  '31DEC2012'd;
   cap=1000;
   do  year  = year(begin)  to  year(end);  
      cap=cap + 0.1*cap;
      output;
   end;
put  "The number of DATA step iterations is " _n_; 
run; 

proc  print  data=investment ;
   format  Cap  dollar12.2 ; 
run; 



data  dage;
input  @1 dob  mmddyy10.  @13  dos  mmddyy8.  ;
format  dob  dos  mmddyy10.  ;
age1 = int((dos-dob) / 365.25) ;
age2 = int(yrdif(dob , dos, 'actual' ));
age3 = int(yrdif(dob , dos, 'age' ));
age4 = int(yrdif(dob , '01jan2013'D , 'actual' ));
age5 = int(yrdif(dob , today(), 'age' ));
age6=intck('year', dob, dos);age3 = int(yrdif(dob , '01jan2013'D , 'actual' ));
datalines;
10/08/1955  03102012
01/01/1960  06082011
09/21/1975  08122012
01/13/1966  01132013
;
proc print data=dage; run; 


data  money;
input  cost  $10. ;
numcost= input(cost, yen7.); 
put  numcost= comma.; 
datalines;
\1,000
\23,450
;
run;

data  datedata;
input  date  $10. ;
ndate= inputn(date, 'yymmdd10.');
put  ndate= yymmdds.  ndate= nldate. ; 
datalines; 
2001/10/26
2013/01/13
;
run;


/*****  1.4	  Excel ファイルへの出力   ********/
proc  export data= ex11 
outfile = "C:\math\math_score.xls" 
dbms=EXCEL  LABEL REPLACE;
sheet="数学成績データ";
run;


options  noxwait  noxsync;
x  "C:\sas_study\randata.xls";
filename  random dde  'excel|sheet1!r1c1:r10c2';
data  ran ;
file  random;
   do  i=0 to 10 ;
      y=ranuni(i) ; 
      put  i  y ; 
   end;
run;


/********* 1 演習  *******************/

proc  import  out= ex13a
            datafile= "C:\sas_study\ex15a.csv" 
            dbms=csv  REPLACE;
         getnames=YES; 
	 datarow=3;
run;
proc print data=ex13a;run;


proc  format ;
value  avegf 0="F"  1="C" 2="B" 3="A"  ; 
run;
data  ex11g;
set  ex11;
if  math1 ne .  then  aveg=(ave ge 80)+(ave ge 70)+(ave ge 60) ; 
format  aveg  avegf. ;
run:
proc  print  data=ex11g; run;

data; 
retain  idno  5 ;
input  x ;
idno= idno+1 ;
cards; 
10
-3
5
9
0
;
proc print; run;

data; 
*retain  idno  0 ;
input  x ;
idno= idno+1 ;
cards; 
10
-3
5
9
0
;
proc print; run;


data  repeat;
input  id  gender $  y1  y2  y3;
array  n_y{*}  _numeric_  ;
do  i= 2  to  dim(n_y);
  time= i;
  y= n_y(i);
  output;
  end;
keep  id  gender  time  y;
cards; 
001 M  1 2 3
002 F   0 4 5
003 F   10 11 12
;
run;
proc  print  data=repeat ;  run;

data  repeat;
input  id  gender $  y1  y2  y3;
array  n_y{*}  y1-y3  ;
do  i= 1  to  dim(n_y);
  time= i;
  y= n_y(i);
  output;
  end;
keep  id  gender  time  y;
cards; 
001 M  1 2 3
002 F   0 4 5
003 F   10 11 12
;
run;
proc  print  data=repeat ;  run;



data  one;
input  x  y ;
cards ;
 1  2
 ;
proc  print  data=one;  run;

data  two;
 if  _n_=2  then  set  one ;
 input  z;
 cards;
 10
 11
 12
 ;
 proc  print  data=two;  run;



data  one;
input  x  y ;
cards ;
 1  2
 ;
proc  print  data=one;  run;

data  two;
 *if  _n_=1  then  set  one ;
 input  z;
 cards;
 10
 11
 12
 ;
 proc  print  data=two;  run;


data ex18(drop=i);
input gender $  height   weight ; 
array  hc{*}  height  weight ;
do i = 1 to 2;
  if hc{i}=-99 then hc{i}=. ;
end;
cards ;
F         156     50
M         160    -99
F         162     52
M        -99      71
;
proc print data=ex18;
run; 


data  dage;
input  @1  dob  mmddyy10.  @13  dos  mmddyy8.  ;
*format  dob  dos  mmddyy10.  ;
age1 = int ((dos-dob) / 365.25) ;
age2 = int (yrdif (dob ,  dos ,  'actual' ));
age3 = int (yrdif (dob ,  dos ,  'age' ));
age4 = int (yrdif (dob ,  '01jan2013'D ,  'actual' ));
age5 = int (yrdif (dob ,  today() ,  'age' ));
age6=intck ('year' , dob ,  dos);
datalines;
10/08/1955  03102012
01/01/1960  06082011
09/21/1975  08122012
01/13/1966  01132013
;
proc print data=dage; run; 



data  mova;
input  y @@;
time+1;
y0= y;
y1= lag(y);
y2= lag2(y);
y3= lag3(y);
if  _n_  ge 4  then do;
movav= mean(of y0-y3);
output;
end;
drop  y0-y3;
cards;
1 3 4 8 10 9 5 3 3
;
proc  print  data=mova; run;




data  a ;
input  id  x  y  z $ ;
cards;
1  10  .    m
2  13  100  m
3  15  130  f
;
run;


data  b ; 
input  id  x  z  $ w ;
cards;
1  11   f   56
3  14   m  57
4  19   f   58
5  19   m  59
;
run ;
proc print data=a;
proc print data=b;
run;
/*c1*/
proc  sort  data= a;
by  id  ; 
proc  sort  data= b;
by  id ;
data  c1; 
merge  a b ;
by  id;
proc  print  data= c1; run;
/*c1*/

/*c3*/
data c1;
set a b ;
run;
proc print data=c1;
run; 
/*c3*/



data samp (drop= size  i  u);
size=6; 
do i= 1 to size;
u= ranuni(0);
k= ceil(n*u);
set ex11 point=k nobs=n;
output;
end;
stop;
run;
proc print data=samp; run;


data samp2(drop= size  u left  p);
size= 6;
left= n;
do while(size > 0);
k+1;
u=ranuni(0);
p=size/left;
if u<p then do;
 set ex11 point=k nobs=n;
 output;
     size= size-1;
   end;
 left= left-1;
 end ;
 stop ;
 run;
 proc print data=samp2; run;
