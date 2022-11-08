/************* SAS Programming 第４章　SQL **********************/

/************ 1　章より、サンプルデータの作成 ******************/
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
 *put  "tmp= " tmp ;
 if  tmp="s"  then  dept= "数学";
  else  if  tmp="k"  then  dept = "化学";
  else  if  tmp="b"  then  dept = "物理";
  else  dept = "その他";
label  dept="学科" ; 
proc  print  data = ex11a  label;
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



/****** 4.1データ検索と操作     *******/
proc  sql ; 
select  *  from  health  ;

proc sql ; 
select  id , gender , height, weight  from  health ;

select  min(height) as 最小,  max(height) as 最大 ,  nmiss(height) as 欠損値 , 
range(height) as 範囲 ,  std(height) as 標準偏差 ,  sum(height) as 合計, 
var(height) as 分散
from  health ;

select   gender ,  
count(gender)  as 人数 ,  
mean(height) as 平均身長, 
mean(weight) as 平均体重  
from  health
where  height is not null
group by gender ;

select  distinct gender , smoking  from  health  ;

select  id,  gender,  height,  weight,
(height - 100) * 0.9  as 標準体重 ,   weight / (( height /100)**2 )  as  bmi 
from  health  ; 


select  id , age ,  gender , height ,  weight  from  health
order  by  age , gender  ;


title "女子学生データ";
select  id, gender , smoking , nsmoking  from  health
where  gender = 1  ;


title ;
select  *  from  health
where  weight >= 80 ;

select  *  from  health
where  id  in  ("s105", "s106")  ;

select *  from  health
 where  id  like  's%'  ;

select  *  from  health
where  not id  like  's%'  ;

 select *  from  health
 where  id  like  "%_3";

select  *  from  health
 where  id  between  "s100" and "s106" ;


title   "数学科 男子学生の喫煙者";
select  id , gender ,  smoking, nsmoking  from  health
 where smoking =1  and  gender = 0 and id  like "s%"  ;

title ; 
select  *  from  health
where  height is missing  ;

select  *  from  health
where  height is not missing  ;


select  id, age, gender  from  health
group  by  age 
having  count(*)=1;


select gender,  age,  mean(height) as 平均身長
from  health
group by gender, age
having mean(height) >=170;


proc sql;
validate
select  id, age  from  health ;

%put  SQLRC=  &SQLRC ; 
%put  SQLOBS= &SQLOBS ;


proc sql;
select  id, age  from  health ;
%put  SQLRC=  &SQLRC   SQLOBS= &SQLOBS ;

proc  sql ;
select  id,  grade, ave, health. gender,  sleeping, smoking
from  health , ex11
  where  health.id  =ex11.subject ;

select  id , grade ,  ave ,  health. gender ,  sleeping , smoking
from  health ,  ex11
  where  health.id  = ex11.subject
order by  ave descending  ;


title  "学生情報データ" ; 
select  pin, grade, health.gender,  area, ctime, money, sc, career, smoking, sleeping
from  health ,  ex11,  survey 
where  id = subject  and  subject= pin ;



/*** JOIN　結合 *******************************************/
data  lefttabj ;
input  area $  export $  country $ ;  
cards;
東京    衣服雑貨   USA
東京    家電       中国
中国    野菜       韓国
アラブ  石油       日本
;
data  righttabj ;
input  area $  export $  country $ ; 
cards;
EUR       衣服雑貨  日本
東京      電子部品  USA
USA       医薬品    カナダ 
USA       医薬品    日本
中国      衣服雑貨  日本
;
run; 
title;
proc  sql ;
 select  *  from  lefttabj ;
 select  *  from  righttabj ;


select * from  lefttabj , righttabj ;


select * from  lefttabj inner join righttabj 
on  lefttabj.area = righttabj.area ;

select *  from  lefttabj , righttabj  where  lefttabj.area = righttabj.area ;

data alltabj ;
 set  lefttabj  righttabj;
 proc  print  data=alltabj ; 
run;

proc  sort  data=lefttabj  out=lefttabjs;
by  area ;
proc  sort  data=righttabj  out=righttabjs;
by  area;
data  alltabjs;
 set  lefttabjs  righttabjs;
 by  area ;
 proc  print  data=alltabjs; 
 run ;

 proc sql; 
title  "left join " ;
select  *  from  lefttabj  left join  righttabj 
on  lefttabj.area = righttabj.area ;

select  *  from  lefttabj as l left join righttabj as r
on  l.area=r.area;


data  righttabj2; 
input  area2 $  export2 $  country2 $ ; 
cards;
EUR      衣服雑貨   日本
東京     電子部品   USA
USA      医薬品     カナダ 
USA      医薬品     日本
中国     衣服雑貨   日本
;
proc  print  data= righttabj2;
run;

data mergetab ;
 merge lefttabj  righttabj2 ;
run;
proc  print ;
run;

proc sql; 
title  "right join";
select *  from  lefttabj as l  right join  righttabj  as r
on l.area = r.area ;


title "full join ";
select  *  from  lefttabj  as l full join  righttabj  as r
on  l.area = r.area;


data  alltabj;
 set  lefttabj  righttabj2;
 proc  print  data=alltabj;
 run;

 
data  csum;
length  product  $ 10 ;
input  store $  product  $   customer $ ; 
cards; 
新宿  封筒           東洋食品
銀座  コピー用紙     南銀行
銀座  ノート         西村出版
板橋  ボールペン     専門学校
;
data  price;
length  product  $ 10 ;
input  product  $   price;
cards;
ノート         80
コピー用紙    800
ボールペン    100
封筒           50
;
data  amount ;
input  customer $  quantity ;
cards;
西村出版  100
南銀行    500
東洋食品  300
専門学校  100
;
title ;
proc  sql ;
select * from  csum ; 
select * from  price ;
select * from  amount ;


title "顧客別売り上げ" ;
select  c.customer ,  p.product ,  p.price format=yen. , a.quantity , 
a.quantity * p.price  as  Total format=yen.
from  csum as c  join  price as p  on ( c.product=p.product) JOIN  amount  as  a 
 on ( c.customer=a.customer) ; 


title "製品別売り上げ" ;
select  p.product ,  p.price format=yen. ,  a.quantity ,  
a.quantity*p.price as Total format=yen.
from  csum  as  c  join  price  as  p  on ( c.product = p.product) JOIN  amount as  a 
on ( c.customer=a.customer) ; 

 

proc  sql ;
title  "成績Aの学生データ" ;
select  id, gender, sleeping, smoking  from  health 
where  "A"  in 
( select  grade  from  ex11a  where  health.id  =ex11a.subject ) ;

select  id, gender, sleeping, smoking from  health 
  where exists
 (select * from  ex11 where grade ="A"  and health.id =ex11.subject ) ;


proc sql;
select  "成績A", id, gender, sleeping, smoking from  health 
  where exists
   (select * from ex11 where grade ="A" and health.id  =ex11.subject ) 
 union
select "成績B", id, gender, sleeping, smoking from  health 
where exists
   (select * from ex11 where grade ="B" and health.id  =ex11.subject ) ;


title; 
proc sql;
select  id, gender, sleeping, smoking from  health 
  where exists
   (select * from ex11 where grade ="A" and health.id  =ex11.subject ) 
except
select  id, gender, sleeping, smoking from  health 
where exists
   (select * from ex11 where  substr(id,1,1)="k" and health.id  =ex11.subject ) ;


/***** 4.2  テーブルの作成と削除   ****************/
title; 
proc sql;
create  table  stdinfo  as
select  id,   health. gender, grade, ave, sleeping , smoking
from  health , ex11
  where  health.id  =ex11.subject ;
select  *  from  stdinfo  ; 


proc  sql ;
create  table  stdresult  as
select   gender ,  
count(gender)  as n , mean(weight) as m_weight ,  mean(height) as m_height 
from  health
 where  height is not null
 group by gender ;
proc print data=stdresult ; run;


proc sql ;
create  table  a (x char, y numeric, z numeric);
insert  into  a
 set  x= 'Tokyo' ,   y=300,  z=0.23
 set  x= 'Chiba' ,   y=125
 set  x= 'Saitama' ,  z=3.14
;
select  *  from  a ;

insert  into  a(x , y , z)
  values('Osaka' , 400, 0.53)
  values('Nagoya', 366, . , )
  values('Kyoto' , . , 1.15)
;
select  *  from  a ;

proc sql; 
create  table  b 
( employee  char(16) label ="社員名" ,
  emppref  char(10) label="在住都市" ,
  dept    char (12)   label="部署" ,
  etrdate  date  label="入社日"   format = nengo.
   ) ; 
insert  into  b (employee,  emppref ,  dept ,  etrdate )
  values('田中一郎' ,   '埼玉県' , '営業部' ,    '10Jan2010'd)
  values('小宮山和子' , '東京都' , '商品開発部', '01Apr 2001'd)
;
select  *  from  b ;


proc sql ;
create  table  new_health  like  health;
insert  into  new_health (id , age , gender , height , weight , smoking )
values("k101" ,  25,  1,  155,  50, 0)
values("s111" ,  26,  0, .  ,  68, 1);
select  *  from  new_health; 

proc  sql;
drop  table  new_health ;

select * from new_health;

/******* 4.3  既存のテーブルへの行の追加や削除   ***********************/
proc  sql;
insert  into  health
set  id= 's301' , gender=1 , weight=47 , age=33
set  id= 's302' , gender=0 , smoking=0, height=169, weight=62 , age=25;
select * from  health;


insert  into  health  
values ("k301", 25 , 0 , 169, 58, 8, 0, 0 )
values ("k302", 30,  1,  . ,  . , 9 , 1, . )  
;
select * from health;


delete  from  health
where  id in ("s301", "s302", "k301","k302") ; 
select * from health;


/****** 演習 ***********************************************/
proc  sql ;
select pin, dept, area, career, grade  from ex11a, survey
where ex11a.subject=survey.pin  and career=2 ;


proc  sql ;
select pin, dept, area, career, grade  from ex11a, survey
where ex11a.subject=survey.pin  and career=2 
union
select pin, dept, area, career, grade  from ex11a, survey
where ex11a.subject=survey.pin  and career=3 ;


proc  sql;
select pin, dept, area, career, grade  from ex11a, survey
where ex11a.subject=survey.pin  and career=2 
outer union
select pin, dept, area, career, grade  from ex11a, survey
where ex11a.subject=survey.pin  and career=3 ;


proc  sql; 
create  table product
( prdname char(14)  label ="商品名" ,
  cost   num  label="原価"  format = yen. ,
  price  num  label="定価"  format = yen.
   ) ;

insert  into  product  (prdname, cost, price)
 values("中華弁当", 600, 1000)
 values("幕の内弁当", 700, 1200)
 values("懐石御膳", 1000, 1600)
 values("すきやき弁当", 700, 900)
;
select  *  from  product ;
quit;


data samp ;
n=100;
do id=1 to n;
output;
end;
drop n;
run;
proc print data=samp;run;
proc sql;
create table rsamp(where= (monotonic() le 10)) as 
select *, ranuni(0) as random from samp order by random ;
quit;
proc print data=rsamp;run;



data test;
input id $ date gender  $ age math eng kokugo;
informat date nldate11. ;
format  date yymmdds10. ;
cards;
s01 05APR2010 m  18 85 90 80
s01 06OCT2010 m  18 90 75 85
s01 15APR2011 m  19 92 78 81
s02 15APR2011 f  20  85 81 78
s02 11OCT2012 f  21  86 68 90
k01 21SEP2012 f  20  67 87 92
k03 07APR2013 m  18 75 80 82
k04 10APR2012 f 18  70 75 80
k04 07APR2013 f 19  80 75 90
;
proc print data=test;run;

proc  sql;
title  "# tests";
create  table test1 as
select id ,
   count(id) as ntest
   from  test
   group  by  id;
   quit;
proc print data=test1;run;

proc  sql ;
title  "test 1 cases";
select  *  from  test
group  by  id
having  count(id)=1; 
quit;

proc  sql ;
title  "summary";
select  id,
  count(id) as ntest,
  count(math) as nmath,
  count(eng) as neng,
  count(kokugo) as nkokugo,
  avg(math) as m_math,
  avg(eng) as m_eng,
  avg(kokugo) as m_kokugo
from test
group by id;
quit;
