/************************************************************************************/
/***** データ解析のためのSAS入門　***************************************************/
/***** バージョン: ２版　　**********************************************************/
/***** 作成： 宮岡悦良, 吉澤敦子  ***************************************************/
/***** 日付:  2014/02/07 ************************************************************/
/************************************************************************************/

/***** 第2章　確 率 分 布 ***********************************************************/

/**** 2.1　離散型確率分布 ***********************************************************/

goptions reset=all;
title ; 


data b1;
p = 0.2;
 do x = 0 to 1;
  pf =(p**x)*(1-p)**(1-x);
  output;
  end;
run;

title1  'Bernoulli Distribution';
title2   'with p=0.2';
symbol1  interpol=needle  width=3  height=1.5  value=star;
axis1  label = ('Probability')  order =(0 to 1 by 0.2) ;
axis2  order = (-0.5 to 1.5 by 0.5)  ;
proc  gplot  data=b1;
 plot  pf *x  / vaxis=axis1  haxis=axis2 ;
run;
quit;

title1  'Bernoulli Distribution';
title2   'with p=0.2';
proc  sgplot  data=b1;
needle  x=x y=pf  / markers  lineattrs=(thickness=3) ;
 xaxis  values = (-0.5 to 1.5 by 0.5);
 yaxis  values =(0 to 1 by 0.2)  label="Probability" ;
run;

data b1r;
 do i = 1 to 1000;
  x = ranbin(0, 1, 0.2);
  output;
 end;
run;
title1  '1000 random observations from';
title2  'Bernoulli Distribution p=0.2';
proc  gchart  data=b1r;
 vbar x / midpoints = 0  1 ;
run;
quit;

data b1r;
call streaminit(0);
p=0.2;
 do i = 1 to 1000;
  x = rand("bernoulli",p);
  output;
 end;
title1  '1000 random observations from';
title2  'Bernoulli Distribution p=0.2';
proc  sgplot  data=b1r;
  vbar  x ;
run;

title;

data;
file  print;
n = 30 ;  k = 3;
do j = 1 to k;
sum = 0;
do  i = 1 to n ;
    y = ranbin(0,1,0.5);
    if  y = 0 then coin = "T" ;
    if  y = 1 then coin = "H" ;
    sum = sum + y ;
    put coin $ @;
  end;
put / @5 "total number of heads= " sum ", out of  " n " trials" /;
end;
run;

data;
file  print;
n = 30 ;  k = 3;
do j = 1 to k;
sum = 0;
do  i = 1 to n ;
    y = rand("bernoulli",0.5); 
    if  y = 0 then coin = "T" ;
    if  y = 1 then coin = "H" ;
    sum = sum + y ;
    put coin $ @;
  end;
put / @5 "total number of heads= " sum ", out of  " n " trials" /;
end;
run;

data;
file  print;
n = 30 ;  k = 3;
do j = 1 to k;
sum = 0;
do  i = 1 to n ;
    y = ranbin(0,1,0.5);
    if  y = 0 then coin = "T" ;
    if  y = 1 then coin = "H" ;
    sum = sum + y ;
    put coin $ @;
  end;
put / @5 "total number of heads= " sum ", out of  " n " trials" /;
end;
run;

data b2;
p = 0.2;  n = 10;
do x = 0 to n;
  if x = 0 | x = n then c = 1;
   else  c = gamma(n+1)/(gamma(x+1)*gamma(n-x+1));
   pf  = c*(p**x)*((1-p)**(n-x));
   output;
  end;
 run;
title1  'Binominal Distribution';
title2  'with p=0.2, n=10';
symbol1  interpol=needle  width=3  height=1.5  value=star;
axis1  label=('Probability')  order=(0 to 1 by 0.2) ;
axis2  offset=(3);
proc  gplot  data =b2;
 plot pf *x / vaxis =axis1  haxis=axis2;
run;
quit;

data b22;
p = 0.2;  n = 10;
do  x = 0 to n;
  pf=pdf("binomial", x, p, n);
  output;
end;
title1  'Binominal Distribution';
title2  'with p=0.2, n=10';
proc  sgplot data=b22;
needle  x=x  y=pf  / markers
       markerattrs=(symbol=asterisk) lineattrs=(thickness=3);
xaxis type=discrete;
yaxis values=(0 to 1 by 0.2) label="Probability";
run; 

data b3;
p = 0.2;  n = 10;
do x = 0 to n;
 pf=pdf("binom",x,p,n);
 cdf = cdf("binom", x, p, n);
 output;
end;
proc  print  data=b3;
 var  x  pf  cdf;
 format  pf  cdf 11.9 ;
run;

data b3;
p = 0.2;  n = 10;
do x = 0 to n;
cdf = probbnml(p,n,x);
if x = 0  then  pf = probbnml(p,n,0);
  else  pf = probbnml(p,n,x)- probbnml(p,n,x-1);
output;
end;
proc  print  data=b3;
 var  x  pf  cdf;
 format  pf  cdf 10.9 ;
run;

data b2r;
 p = 0.2;  n = 10;  it = 1000;
  do i = 1 to it;
   x = ranbin(0,n,p);
   output;
  end;

title1  '1000 random observations from';
title2  'Binomial Distribution, n=10, p=0.2';
proc  gchart  data=b2r;
 vbar x / discrete; 
run;
quit;

data b2r;
 p = 0.2;  n = 10;  it = 1000;
  do i = 1 to it;
   x=rand('binom',p,n);
   output;
  end;

title1  '1000 random observations from';
title2  'Binomial Distribution, n=10, p=0.2';
proc  gchart  data=b2r;
 vbar x / discrete; 
run;
quit;

proc sgplot data=b2r;
vbar x;
run;
proc sgplot data=b2r;
histogram  x  / 
  binstart=0  binwidth=1 ;
run;

data p1;
 m=3;
 do x = 0 to 10;
  if x = 0 then pf = poisson(m, x);
   else
    pf = poisson(m,x) - poisson(m,x-1);
    output;
  end;
 run;

title1 'Poisson Distribution';
title2 'with m=3';
symbol1 interpol=needle width=3 height=1.2  width=1.5 value=star;
axis1  label =('Probability')  order =(0 to 1 by 0.2) ;
axis2  offset =(3) ;
proc  gplot  data =p1;
 plot  pf*x / vaxis =axis1  haxis=axis2;
run;
quit;

data p1;
 m=3; n = 10;
do x = 0 to n;
 pf=pdf("poisson", x,m);
 output;
 end;
run;

title1 'Poisson Distribution';
title2 'with m=3';
proc  sgplot data=p1 ;
needle  x=x  y=pf  / markers
       markerattrs=(symbol=asterisk) lineattrs=(thickness=3);
xaxis type=discrete;
yaxis values=(0 to 1 by 0.2) label="Probability";
run;

data p1r;
 m = 3; it = 1000;
 do i = 1 to it;
  x = ranpoi(0,m);
  output;
 end;
run;

title1  '1000 random observations from';
title2  'Poisson Distribution, m=3';
proc  gchart  data=p1r;
vbar  x / discrete  width=8 ;
run;
quit;

data du1;
input x pf ;
  cards;
1 0.2 
2 0.4
3 0.3 
4 0.1
;
run;
title1  'Discrete Distribution';
title2   'with 0.2, 0.4, 0.3, 0.1';
symbol1  interpol=needle  width=3  height=1.5  value=star;
axis1  label = ('Probability') order = (0 to 1 by 0.2);
axis2  offset = (3);
proc  gplot  data = du1;
 plot pf*x / vaxis = axis1  haxis = axis2;
run;
quit;

proc  sgplot data=du1 ;
needle x=x y=pf / markers ; run;

data du1r;
 do i = 1 to 1000;
  x  = rantbl(0, 0.2, 0.4, 0.3, 0.1);
  output;
 end;
run;
title1  '1000 random observations from';
title2  'Discrete Distribution';
proc  gchart  data=du1r;
 vbar  x / discrete  width=8 ;
run;
quit;

data du1r;
 do i = 1 to 1000;
  x  = rand("tabled", 0.2, 0.4, 0.3, 0.1);
  output;
 end;
run;

title1  '1000 random observations from';
title2  'Discrete Distribution';
proc  sgplot data=du1r ;
vbar x;
run;

/******   2.2　連続型確率分布  *********************************/
title ; 
goptions reset=all ;


data n1;
 c = 1/sqrt(2*constant('pi'));
 do  x = -3  to  3  by  0.01;
   pdf = c*exp(-(x**2)/2);
   output;
  end;
run;

title  'Standard Normal Distribution';
symbol1  interpol=join  value=none  width=1.5  c=black;
axis1 label =('Density')  order =(0 to 0.4 by 0.1) ;
proc  gplot data = n1;
 plot  pdf*x / vaxis = axis1;
run;  quit;

title 'Standard Normal Distribution';
proc  sgplot data = n1;
series x=x y=pdf;
yaxis label ='Density' 
 values =(0 to 0.4 by 0.1) ;
run;

title 'Standard Normal CDF';
data n3;
do x = 0 to 3 by 0.1;
  cdf = probnorm(x);
  output;
end;
run;
proc  print  data=n3;
 var  x  cdf;
run; 
quit;

title 'Standard Normal CDF';
data n3;
do x = 0 to 3 by 0.1;
  cdf = cdf("normal",x, 0, 1);
  output;
end;
run;
proc  print  data=n3;
 var  x  cdf;
run; 
quit;

data n1r;
do i = 1 to 1000;
  x = rannor(0);
  output;
end;
run;

title1   '1000 random observations from';
title2   'Standard Normal Distribution';
proc  gchart  data=n1r ;
 vbar x / space=0  width=8;  
run;
quit;

data n1r1;
do i = 1 to 1000;
  x = rand('normal');
  output;
end;

title1    '1000 random observations from';
title2   'Standard Normal Distribution';
proc sgplot data=n1r1;
histogram  x / scale=count;
run;

data n2;
do v = 0.5 , 1 , 3 ;
  c = 1/sqrt(2*constant('pi')*v);
   do x = -4 to 4 by 0.01;
     pdf = c*exp(-(x**2)/(2*v));
     output;
   end;
 end;

title1   'Normal Distribution';
title2   'mean=0, var=0.5, 1, 3';
symbol1  interpol=join  value=none  l=1  w=1.5  c=black;
symbol2  interpol=join  value=none  l=2  w=1.5  c=black;
symbol3  interpol=join  value=none  l=4  w=1.5  c=black;
axis1  label = ('Density') order = (0 to 0.6 by 0.1);
proc  gplot  data=n2;
 plot  pdf*x = v / vaxis = axis1;
run; quit;

title1  'Normal Distribution';  
title2  'mean=0, var=0.5, 1, 3';  
proc  sgplot data=n2;
 series  x=x  y=pdf / 
  group=v  groupdisplay=overlay;
yaxis  label ='Density';
run;

data n3;
do m = -1, 0, 2;
  c = 1/sqrt(2*constant('pi'));
  do x = -4 to 4 by  0.01;
    pdf = c*exp(-((x-m)**2)/2);
    output;
   end;
 end;

title1  'Normal Distribution';
title2  ' mean=-1, 0, 2, var=1';
symbol1  interpol=join  value=none  l=1  w=1.5  c=black;
symbol2  interpol=join  value=none  l=2  w=1.5  c=black;
symbol3  interpol=join  value=none  l=4  w=1.5  c=black;
axis1  label = ('Density')  order = (0 to 0.4 by 0.1);
proc  gplot  data=n3;
plot  pdf*x = m / href=0  lhref=20 
 vaxis = axis1;
run;
quit;

title1 'Normal Distribution';  
title2 'mean=0, var=0.5, 1, 3';  
proc sgplot data=n3;
series x=x  y=pdf/ 
  group=m groupdisplay=overlay;
yaxis  label ='Density';
run;

data n2r;                                        
 do i = 1 to 1000;
   x =  rand('normal',1, sqrt(4));
   output;
 end;
title1  '1000 random observations from';
title2  'Normal Distribution, m=1, s=2';
proc  sgplot  data=n2r;
 histogram  x / scale=count;
run;

data e1;
do m = 0.5, 1, 1.5;
 c = m;
  do x = 0 to 4 by 0.01;
   pdf = c*exp(-c*x);
   output;
  end;
 end;

title   'Exponential Distribution';
symbol1  interpol=join   value=none  l=1  c=black;
symbol2  interpol=join   value=none  l=2  c=black;
symbol3  interpol=join   value=none  l=4  c=black;
axis1  label=('Density') order =(0 to 1.4 by 0.2) ;
axis2   offset=(3) ;
proc  gplot  data=e1;
 plot  pdf*x = m /  href=0  lhref=20
      vaxis = axis1 haxis= axis2;
run;  quit;

title 'Exponential Distribution';
title2 'm=0.5, 1, 1.5';
proc  sgplot data = e1;
series x=x  y=pdf /
 group=m  groupdisplay=overlay;
yaxis label ='Density' ;
run;

data e1r;
m = 2;
do i = 1 to 1000;
  x = m*ranexp(0);
output; 
end;
run;

title1   '1000 random observations from';
title2   'Exponential Distribution, m=2';
proc  gchart  data=e1r;
 vbar x /space=0  width=8 ;
run;
quit;

data u1;
 do x = 0 to 1 by 0.01;
  pdf = 1;
  output;
 end;
run;
title   'Uniform Distribution';
symbol1  interpol=join  value=none  c=black ;
axis1  label=('Density')  order=(0 to 1.2 by 0.1)  ;
axis2   offset=(3);
proc  gplot  data=u1;
 plot  pdf*x / href=0  lhref=20
      vaxis=axis1  haxis=axis2 ;
run;

title   'Uniform Distribution';
proc sgplot data=u1;
series  x=x  y=pdf ;
yaxis  label ='Density';
run;

data u1r;
do i = 1 to 1000;
  x = ranuni(0);
  output;
end;
run;

title1 '1000 random observations from';
title2 'Uniform Distribution';
proc  gchart  data=u1r ;
vbar x / space=0  ;
run;
quit;

data u1r;
do i = 1 to 1000;
  x = rand('uniform');
  output;
end;
title1 '1000 random observations from';
title2 'Uniform Distribution';
proc  sgplot  data=u1r ;
histogram x / scale=count  ;
run;

data mnormal;
 r = 0;
 c = 2*constant('pi') * sqrt(1-r**2);
 do x =  -3  to  3  by 0.1;
   do y =  -3  to  3  by 0.1;
     z = (1/c)*exp(-(x**2-2*r*x*y+y**2)/(2*(1-r**2)));
     output;
   end;
 end;
run; 
title    'Bivariate Normal Distribution';
proc  g3d  data=mnormal;
 plot y*x = z / rotate=60 tilt=45 ;
run; 
quit;

data mnormal;
 r = 0.9;
 c = 2*constant('pi')*sqrt(1-r**2);
 do x =  -3  to 3  by 0.1;
   do y =  -3  to 3  by 0.1;
     z= (1/c)*exp(-(x**2-2*r*x*y+y**2) / (2*(1-r**2)));
     output;
   end;
end;
run;
title   'Bivariate Normal Distribution';
proc  g3d  data=mnormal;
 plot  y*x=z / rotate=60  tilt=45 ;
run; 
quit;

title  'Bivariate Normal Distribution';
proc  gcontour  data=mnormal;
   plot  y*x = z / levels = 0  0.05  0.1  0.15  0.2  0.25  0.3  0.35 ;
run;

data bnm(type=cov);
input  _type_  $ 1-4  _name_  $  6-8  x1 x2 x3 ;
cards;
cov  x1 2 1 0 
cov  x2 1 3 0
cov  x3 0 0 4
mean    1 2 0
run; 
proc print; run;
proc simnormal data = bnm  outsim=rbnm  nr=100  seed=123 ;
var   x1- x3;
run;
proc print data=rbnm; 
run;

data bnm(type=cov);
input _type_ $ 1-4 _name_ $ 6-8 x1 x2  ;
cards;
cov  x1  1 0.9 
cov  x2  0.9 1 
mean       0 0
run; 
proc simnormal data =bnm outsim=rbnm nr=100 seed=123;
var x1 x2;
run;
proc print data=rbnm; run;
proc sgplot data=rbnm;
 scatter  x=x1 y=x2;
 run;
proc corr data=rbnm;
var x1 x2 ;
run;

/***** 付　　録 *************************************************/
title ; 
goptions reset=all ;

data;
df = 5;
q = quantile('t',.95,df);
c = cdf('t',1.96,df);
p = pdf('t',1.96,df);
r = rand('t',df) ;
file print;
put q c p r;
do x = -4  to  4  by  0.01;
  y1 = cdf('t',x,df);
  y2 = pdf('t',x,df);
  output;
end;
run;
proc  gplot;
plot (y1 y2)*x / overlay;
symbol1  i=join  l=1;
symbol2  i=join  l=5;
run;
quit;

data;
it = 10000; df = 5;
do i = 1 to it;
  r = rand( 't',df) ;
  output;
end;
run;
proc univariate  noprint ;
var  r;
histogram  r;
run;


