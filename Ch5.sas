/******  SAS Programming 第5章　IML    *******/



proc  iml;
a = {  1  2 ,
       3  4  }  ; 
b=  {10  20 , 
     10  30  } ;
x= a + b ;
inva = inv(a) ;
print  x  inva;
quit;

proc  iml ;
x = {1 ,  2 ,  5 ,  12 ,  100 } ;
n = nrow( x ) ;
sumx = sum( x )  ;
meanx = sum( x ) /  n ;
print  x  n sumx  meanx  ;
quit ;


/****  5.2　IMLの基本知識 *******/ 
proc  iml ;
a = 123 ;
b = 123.456 ;
c = 12E-3 ;
d = 'one' ;
e= "Yes, We can!" ; 
f = .  ;
g= 1/3 ; 
print  a b c d e f g ;
quit;

proc iml; 
x={ 1  2  3  4  5 } ;
print x ;

y = { 1,  2,  3,  4,  5 } ;
print  y  ;

y = { 1,
      2,
      3,
      4,
      5 };
print  y  ;

w = { abc  'abc'  AbC  'AbC'  "ab C"  abcd5 } ;
print  w  ;

a={ 1  2  3 ,  4  5  6 } ; 
print  a ;

a={  [ 3 ]  "yes"  [ 2 ]  "no"  } ;
b={  [ 3 ]  "yes" ,  [ 3 ]  "no"  } ;
c={ [ 2 ]  1 ,  [ 2 ]  5 } ;
print  a ;
print  b ;
print  c ;

reset  print ;
a8  =  1 : 8 ;
a83  =  8 : 3 ;
aa  =  do  (-2 ,  2 ,  0.5 ) ;
varname  =  "v1"  :  "v5"  ;

quit; 




/*****  5.3　　行列の演算 **************/
proc iml; 
reset  print ; 
a = { 1  2 , 3  4 } ; 
b = { 5  6 , 7  8 } ;

z1 = a + b ; 
z2 = b - a ;
z3 = a +10 ;
z4 = 3 # a ;
z5 = a * b ;
z6 = a` * a ;
z7 = a ## 2 ;
z8 = a @ b ;
z9 = b @ a ;
r = ( a >= 3 ) ;


a = { 1  2 , 3  4 } ;

ae12 = a[ 1 , 2 ];
ae1 = a[ 1 , ] ;
aec1 = a[ , 1 ];


z10 = a ## b ;
z11 = a / b ;
z12 = a # b ;
c = { 2  3 } ;
z13 = a ## c ;
z14 = c ## a ;
z15 = c / a ;
z16 = a # c ;
z17 = c # a ;
z18 = a - c ;
z19 = c - a ;
z20 = a - 4 ;


reset  print ;
a = { 3  5  7 ,  2  4  6  } ;
b = 3 # a ;
c = a // b ;
c [ 1 , 3 ] = 100;
cm = c[ { 2  4 } , { 2  3 } ] ;
d = a || b ;

reset  print ;
ma={1  2  3  ,  4 -5  0 } ;
mb={1  3  0  ,  1 -1  1 } ;
z1 = ma < mb ;
z2 = ma <= mb ;
z3 = ma # mb ;
z4 = ma > 0 ;
z5 = mod(ma,2);
z6 = ma # (ma > 0);

quit;




/***** 5.4 SAS 関数 ***************/
proc iml; 
reset  print ; 
a = { 1  2  3 ,  2  4  5 ,  3  5  6 } ; 
b = { 1  2  3  4  ,  5  6  7  8 } ; 
c =  j(1 , 3 , 1) ;
i4 =  j(4 , 1 , 1) ;
invA = inv (a);
tranA = t (a) ; 
ttA = t (t (a)) ;
r = trace (a) ;
z1 = a * invA ;
z2 = c * a ;
z3 = a * t (c) ; 
z4 = b * i4 ;
da = det (a) ;
ra = round (trace (ginv (a) *a) ) ;
ea = eigval (a) ;
evc = eigvec (a) ;
mm = max (a) ;


one = j ( 1 , 10 , 1 ) ;
one34 = j( 3 , 4 , 1 ) ;
z = one34 * one34` ;
z = one34` * one34 ;
id5 = i( 5 ) ; /* 5次の単位行列 */
d2= diag( { 1   2   3 } );
d3 = diag( { 1 ,  2 ,  3 } );
d4 = diag( { 1  2 ,  3  4 } );
print  d2 d3 d4 ;


m1 = { 1  1 ,  2  2 } ;
m2 = { 3  3 ,  4  4 } ;
m3 = block(m1 , m2) ;
nma = shape( {1  2  3 , 4  5  6 } , 4 , 4) ;
nma = shape( { 1  2  3 , 4  5  6 } , 4 , 4 , 0 ) ;
mat1 = shape( 1 : 12 , 3 , 4 ) ;
dvec = vecdiag( m3 ) ;
mr1 = repeat( m1 , 2 , 4 ) ;


a={  1  2  3  4 ,  5  6  7  8 } ;
n1 = ncol ( a ) ;
one = j( n1 , 1 , 1) ;
rsum = a * one ;
n2 = nrow ( a ) ;
rone = j(1 , n2 , 1) ;
csum = rone * a ;


reset  print ;
x1 = design( { 1 , 1 , 2 , 2 , 5 , 1 } );
x2 = designf( {1 , 1 , 2 , 2 , 5 , 1 } );


z = mod( { 1  2 ,  3  4 } , 4 );


reset  noprint ;
n = 10 ;  p = 0.4 ;
x = 0 : n ;
pm = shape( x , 3 , n + 1 );
pm[ 2 , ]= pdf( "binom" , x , p , n ) ;
pm[ 3 , ]= cdf( "binom" , x , p , n ) ;
pt = pm`  ;
print  pt [ colname = { " x "  " P(X=x) " " P(X < = x) " }  format = 10.5
             label = "Binomial Distribution" ] ;


reset  noprint ;
z = do ( 0 , 3 , 0.1 ) ;
zt = t( z );
pt = t (cdf ( "normal" , z , 0 , 1 ) );
print  zt [ format = 5.2  label = "z"]  pt [ format = 10.5  label = "P (Z<=z)" ];


p = { 0.8 , 0.9 , 0.95 , 0.975 , 0.99 , 0.995 } ;
z1 = quantile ( "normal" ,  p , 0 , 1 );
p = p * 100 ;
print  p  [ format=4.3  label = "percent" ]  z1 [format =10.3 ]  ;


reset  print ;
rn = normal ( repeat( 0 , 3 , 2 ) );
ru = uniform ( repeat( 0 , 3 , 2 ) ) ;
pr = ranpoi ( repeat( 0 , 3 , 2 ) ,  3 );
rb = ranbin ( repeat( 0 , 3 , 2 ) ,  10 ,  0.3) ;
re = ranexp ( repeat( 0 , 3 , 2 ) ) ;
rt =rantbl ( repeat( 0 , 2 , 5 ),  0.1,  0.3,  0.1,  0.5 ) ;


reset  noprint ; 
r = j (5 , 1 , . ) ; 
call  randgen ( r , 'ber' , 0.2 ) ;
print  r ;

runi = j (5 , 1 , . ) ; 
call  ranuni( 0 , runi );
print  runi ;


reset  noprint ; 
seed = 0; 
c = j(10 , 1 , seed) ; 
md = j(10 , 1 , 1) ;
b = uniform( c ) ; 
saikoro = md + int( 6 # b ) ;   
print  b  saikoro ;


reset  noprint ; 
md = j( 10 , 1, 1) ;
ranu = j(10 , 1, .) ;
call  randgen(ranu , 'UNIFORM' ) ;  
saikoro = md + int( 6 # ranu) ;   
print  ranu  saikoro;

quit; 


/***** 5.5　 行列成分   ****************/
proc iml; 	
reset  print ; 
x = { 1  2  3 ,   4  5  6  ,  7  8  9  } ;

x31 = x[ 3 , 1 ] ;
x23 = x[ 2 , 3 ] ;
row1 = x[ 1 ,  ] ;
col1 = x[ , 1 ] ;
row3 = x[ 3 ,  ] ;
col3 = x[ , 3 ] ;
y = x[ { 1  3 } , { 1  2 } ] ;  
y2 = x[ 2 , 1 : 3 ] ;
xsum = x[ + , ] ;
ysum = x[ , + ] ;
xmean = x[ : ] ;
xsummax = x[ <> , + ] ;
xmind = x[ , >< ] [ + , ]  ;


reset  print ;
mat = {1  2  3  ,  4  5  0  , -1 -2 -3  } ;
r1 = mat[ { 1  2 } , + ] ;
r2 = mat[ , <> ] ;
r3 = mat[ >< , + ] ;
r4 = mat[ <> , ];
r5 = mat[ <> , ] [ , + ];
r6 = mat[  , : ] ;
r7 = mat[ : , ];
r8 = mat[ : ] ;
r9 = mat[  , <:> ];
r10 = mat[ , ## ];

quit; 


/******   5.6 数学の応用   *******************/
proc iml ; 
reset print;
a = polyroot( { 4  -6  -4  } ) ;
a = polyroot( { 1  1  0  6  -8 } ) ;


reset  print ;
i2 = j( 2 , 1 ) ;
i3 = j( 3 , 1 ) ;
i23 = i2 @ i3 ;
ii = i( 2 ) @ i3 ;
x = i23 || ii ;
r1 = round( trace(ginv(x) * x)) ;
r = echelon( x ) ;
r = (r ^= 0)[ , + ] ;
r2 = (r ^= 0 )[+ , ] ;

xx=x`*x;
r=trace( hermite(xx)) ;

proc iml;
reset print; 
a= { 3  -1  2 , 
     2  -2  3 , 
     4  1  -4 } ; 
c= { 8 , 2 , 9} ; 
r = det( a ) ;
x1 = inv( a ) * c ;
x2 = solve( a , c ) ;
c1 = a*x1 ;
c2 = a * x2 ;


a = { 1  2  1 ,  2  4  -1  ,  1  2  2  } ;
c = {1 ,  8 , -1 } ;
r = det ( a ) ;
ac = a || c ; 
w = echelon ( ac ) ;


reset  print ;
a = {1 2 1, 2 4 -1, 1 2 2};
c = {1, 8 , -1};
agi = ginv( a );
x = ginv(a)*c;
cc = a * x ;
reset  fuzz ;
z = i(3) -ginv(a)*a;
h = { 5, 4 , 1};
x1 = ginv(a) * c + z * h ;
cc = a * x1 ;


reset  print ;
a = { 1  2 -1  , 2  3 -1 ,  1  2  3  } ;
z = det ( a );
ai = inv ( a );
i3 = i( 3 );
ai3 = a  ||  i3 ;
ia = echelon ( ai3 );
ia3= ia[ , 4 : 6];


reset  print ;
a = { 1  1  1  2  ,  1  0  1  0  ,  2  1  2  2  } ;
r1 = round ( trace ( ginv( a ) * a ) ) ;
x = homogen( a );
xx = x` * x ;
reset  fuzz ;
c1 = a * x[ , 1 ] ;
c2 = a * x[ , 2 ] ;


reset  noprint ;
a = { 1  2  2 ,  2  1  2 ,  2  2  1 } ;
 eva = eigval ( a ) ;
 evec = eigvec ( a );
 print  a  ,,  eva  ,,  evec ;
 ax1 = a * evec [ ,1 ] ;
 ax2 = a * evec [ ,2 ] ;
 ax3 = a * evec [ ,3 ] ;
 lx1 = eva [ 1, ] # evec[ ,1 ] ;
 lx2 = eva [ 2, ] # evec[ ,2 ] ;
 lx3 = eva [ 3, ] # evec[ ,3 ] ;
 print  ax1  lx1  ,,  ax2  lx2  ,,  ax3  lx3 ;


call  eigen ( evac , evecc , a ) ;
print   a  ,,  evac  ,,  evecc ; 


reset  fuzz ;
print ( evec` * evec ) ;


reset  noprint ;
a = { 1   0   0 , 
      0	  0  -1 , 
      0   1   0  } ;
 eva = eigval( a ) ;
 evec = eigvec( a );
 reset  fuzz ;
 print  a  ,,  eva ,, evec ;
 call  eigen( evac , evecc , a ) ;
 print  a ,, evac ,, evecc  ;

quit; 



/******   5.7 統計の応用   *******************/
proc iml;

x = { 67  89 ,  55  64 ,  85  90 ,  46  74 ,  87  67 ,
      93  95 ,  46  55 ,  77  88 ,  65  58 ,  85  80 } ;
cn = { math  eng } ;
mattrib   x  colname = cn ;
print  x ;


mmath = x[ : , 1 ];
meng = x[ : , 2 ];
mall = x[ : ];
print  "mean "  mmath  [ format=7.2] 
      meng [ format= 7.2] 
      mall  [ format= 10.3] ;


vmath = ssq( x[, 1 ] - mmath ) / nrow( x ) ;
smath = sqrt( vmath ) ;
veng = ssq( x[ , 2 ] - meng ) / nrow( x ) ;
seng = sqrt( veng ) ;
print  " variance " " standard deviation"  ,,
        vmath   smath  ,,
        veng    seng ;


qmath = quartile ( x [ , 1 ] ) ;
qeng =  quartile ( x [ , 2 ] ) ;
print  qmath  qeng ;


summary = j( 8 , 2 ) ;
n = nrow ( x ) ;
summary[ 1 , ] = x[ : , ] ;
summary[ 2 , ] = (x-x[:,]) [##,] / n ;
summary[ 3 , ] = sqrt( summary[ 2 , ] ) ;
summary[ 4 : 8 , ] = quartile( x ) ;
print  summary  [ rowname = { mean  var  sd  min  q1  q2  q3  max }
       colname = cn  format = 12.3 ] ;


m = t (mean ( t(x) ) )  ;
rm = rank( m ) ;
print  m  rm  ;


call  sort( m , 1 ) ;
 print  m ;


x = { 1 , 2 , 3 , 4 , 5 } ;
n = nrow( x ) ;
v1 = ssq( x - x[ : ] ) / n ;
v2 = ( x[ ## ] - n * x[ : ] * x [ : ] ) / n ;
v3 = ( x[ ## ] - x[ + ] * x[ + ] / n ) / n ;
print   v1  v2  v3 ;


x = { 67  89 , 55  64 , 85  90 , 46  74 ,  87  67 , 93  95 , 
     46  55 , 77  88 , 65  58 , 85  80 } ;
cn = { math  eng } ;
mattrib  x  colname = cn ;
n = nrow( x );
jn = j ( n , 1 ) ;
jjn = j ( n , n ) ;
mx = jn` * x / n ;
ss = ( x`*( I ( n ) - ( 1 / n ) * jjn ) * x ) / n ;
print  x  jn  jjn  ;
print  "mean "  mx  [colname = cn  format=10.2 ] ;
print  ss [ label = "Covariance"  rowname=cn  colname=cn  format=12.3 ] ;


sd = diag ( 1 / sqrt( vecdiag ( ss ) ) ) ;
cor = sd * ss * sd ;
print  cor  [label =" Correlation " rowname =cn colname =cn format =8.3] ;


x = { 12.1  13.5  10.8  14.6  16.2 } ;
y = { 11.9  15.2  14.7  18.8  19.4 } ;
n = ncol ( x ) ;
dif = x - y ;
df = n - 1 ;
mdif = dif [ : ] ;
vdif = ssq( dif- mdif ) / df ;
sdif = sqrt( vdif ) ;
t = mdif / sqrt( vdif / n ) ;
pval = 2 * ( 1- cdf( "T" , abs( t ) , df ) ) ;
print  mdif [format=10.3]  sdif [format=10.3]  df  
       t [format=10.3]   pval [format=10.4]  ;

alpha = 0.05 ;
tq = quantile ( 't' , 1- alpha / 2 , df ) ;
lower = mdif - tq * sqrt ( vdif / n ) ;
upper = mdif + tq * sqrt ( vdif  / n ) ;
print  ( ( 1-alpha ) * 100 )  " % confidence interval " ,, 
       lower  [format=10.3]  upper  [format=10.3] ;


x = { 12.1  13.5  10.8  14.6  16.2 } ;
y = { 11.9  15.2  14.7  18.8  19.4 } ;
n = ncol ( x ) ;
dif = x -y ;
df = n - 1 ;
mdif = dif [ : ] ;
vdif = ssq( dif- mdif ) / df ;
sdif = sqrt( vdif ) ;
t = mdif / sqrt( vdif / n ) ;
pval = 2 * ( 1- cdf( "T" , abs( t ) , df ) ) ;
print  mdif [format=10.3]  sdif [format=10.3]  df  
       t [format=10.3]   pval [format=10.4]  ;


alpha = 0.05 ;
tq = quantile ( 't' , 1- alpha / 2 , df ) ;
lower = mdif - tq * sqrt ( vdif / n ) ;
upper = mdif + tq * sqrt ( vdif  / n ) ;
print  ( ( 1-alpha ) * 100 )  " % confidence interval " ,, 
       lower  [format=10.3]  upper  [format=10.3] ;


data;
input  x  y ;
d = x - y ;
cards;
12.1  11.9
13.5  15.2
10.8  14.7
14.6  18.8
16.2  19.4
;
proc  ttest  alpha=0.05 ;
var   d ;
run ; 


proc  iml ;
reset  print ;

x = { 1  1  1 ,
      1  2  4  ,
      1  3  9  ,
      1  4  16  ,
      1  5  25  }  ;
y = { 1  ,  5  ,  9  ,  23  ,  36  }  ;

b = inv(x`* x)*x`*y;

yhat = x * b ;
resid = y-yhat ;
sse = ssq (resid) ;
df = nrow (x)- ncol(x) ;
mse = sse / df  ;
sst = ssq (y - y[ : ] ) ;
ssm = sst - sse ;
r2 = ssm / sst ;

x = {1  1  1,
     1  2  4 ,
     1  3  9 ,
     1  4  16, 
     1  5  25 };
y = { 1 ,  5 ,  9 ,  23,  36 } ;
n = nrow( x );
jjn = j (n , n , 1 );
hat = x * inv( x` * x ) * x` ;
er = ( i ( n ) - hat ) * y;
sse = y` * ( i ( n ) - hat)* y ;
sst = y` * ( i ( n ) - ( 1 / n ) * jjn ) * y;
ssm = y` * ( hat- ( 1 / n ) * jjn ) * y ;
ss = ssm // sse // sst ;
dfm = ncol( x ) -1 ;
dfe = nrow( x )-ncol( x ) ;
dft = nrow( x ) - 1 ;
df = dfm // dfe // dft ;
msm = ssm / dfm ;
mse = sse / dfe ;  
ms = msm // mse ;
fv = msm / mse ;
pv = 1-cdf("f",fv,dfm,dfe) ;
r2 = ssm / sst ;
source = { " model " , " error  " , " total  " } ;
print " ANOVA table " ,,
  source ss [ format = 10.3 ]  df  [ format = 4.0]  ms [ format = 10.2 ]
  fv [ format=6.2 ]  pv [ format=6.4 ] ;
rootmse = sqrt ( mse ) ;
print mse [format = 10.4]  rootmse [format=10.4]  r2 [format=10.4] ;
bhat = inv(x`* x) * x`* y ;
vb = mse * inv(x`* x);
seb = sqrt (vecdiag(vb));
t = bhat / seb ;
pt = 2*(1-probt(abs(t),dfe));
print bhat [format=10.3]  (j(ncol(x),1,1)) seb [format=10.3] 
 t [format=10.3]  pt[format=10.5] ;


data ;
input  x1  x2  y ;
cards;
1  1  1
2  4  5
3  9  9
4  16  23
5  25  36
;
proc  reg ;
model  y = x1  x2 ;run;


proc iml ;
y = { 101 , 105 , 94 , 84 , 88 , 32 } ;
a = { 1 , 1 , 1 , 2 , 2 , 3 } ;
xp = design( a );
n = nrow( y ) ;
x = j(n , 1 , 1) || xp ;
rankx = round( trace( ginv( x ) * x)) ;
jjn = j ( n , n , 1) ;
hat = x * ginv( x ) ;
yhat = hat * y ;
er = ( i ( n )-hat ) * y ;
sse = y` * ( i ( n ) - hat ) * y ;
sst = y` * ( i ( n ) - ( 1 / n ) * jjn ) * y ;
ssm = y` * ( hat - ( 1 / n ) * jjn ) * y ;
ss = ssm // sse // sst ;
dfm = rankx -1 ;
dfe = nrow( x ) -rankx;
dft = nrow( x ) -1 ;
df = dfm // dfe // dft ;
msm = ssm / dfm ;
mse = sse / dfe ;
ms = msm // mse ;
fv = msm / mse ;
pv = 1-cdf("f",fv,dfm,dfe) ;
rootmse = sqrt(mse) ;
r2 = ssm / sst ;
source = { " model " , " error  " , " total  " } ;
print  " ANOVA table "  ,,
source  ss  [ format=10.3]  df  [format=4.0]  ms  [format=10.2]
fv  [format=6.2]  pv [format=6.4] ;
print  mse [format=10.4]  rootmse  [format=10.4]  r2  [format=10.4] ;


reset print;
h = {0,0,1,-1};
rankh = round(trace(ginv(h)*h));
bhat=ginv(x)*y;
hb = h`*bhat;
num = hb`*inv(h`*ginv(x`* x)* h)*hb/rankh ;
fv = num /mse ;
pv = 1-probf(fv,rankh ,n-rankx);
print  rankh  num [ format=10.4 ]  fv [ format=10.4 ]  pv [ format=10.4 ] ;


h = { 0  0 ,  1  0 ,  -1  1 , 0  -1 } ;
m = { 10 , 50 } ;
rankh = round( trace( ginv( h ) * h ) ) ;
bhat = ginv( x ) * y;
hb = h` *  bhat ;
num = ( hb -m )` * inv( h` * ginv( x` * x) * h ) * ( hb - m ) / rankh ;
fv = num / mse;
pv = 1 -probf ( fv , rankh , n -rankx ) ;
print  rankh  num  [ format=10.4 ]  fv  [ format=10.4 ]  pv [ format=10.4 ] ;

title;
data ;
input  method  $  y ;
cards ;
a  101
a  105
a  94
b  84
b  88
c  32
;
proc  anova ;
class  method ;
model  y = method ;
run;


/****  5.8　SAS/IML プログラミング  ************/
title;
proc  iml ;
a = {1  2 , -1  -3 } ;
if  a <0  then  a1 = abs (a) ;
else  a1 = a ;
print  a1 ;
if  a <= 2  then  a2 = abs (a) ;
else  a2 = a ;
print  a2 ;
quit ;

proc iml;


x=floor(10*uniform(0))+1;
y=floor(10*uniform(0))+1;
if x < y then
do ;
 z1=y ; z2=x ;
end ;
else  do ;
 z1 =x ; z2=y ;
end ;
print x  y  ,,  z1  z2 ;


seed= 12345 ;
z = j (5, 3, 1) ;
do  i  =  1  to  5 ;
   do  j  =  1  to  3 ;
      z[ i , j ] = 1 + 3 * normal ( seed ) ;
    end ;
end ;
print  z  [ format= 10.5 ]  ,,  ( z[ : ] ) ;


a = 2 ;
x = a / 2 ;
do i = 1 to 100 ;
x = ( x + a / x ) / 2 ;
end ; 
n = i-1 ;
print  "n= "  n  ,, "  root"  a  " = "  x  [ format =16.13 ] ;
z = sqrt( a ) ;
print  "sqrt (" a ") =  "  z  [ format = 16.13 ] ;


quit;





/******  5.9 　IMLモジュール  *************************/
proc iml; 
start  sq  (a) ; 
  asqrt = sqrt ( a ) ;
  print  " sqrt  of  " a  " =  "  asqrt ;
finish  sq ;
 
run  sq(4) ;
call  sq(5) ;


start ex(x , p);
c = x`*p ;
return( c ) ;
finish ;
start varp(x,p) ;
x2 = x ##2 ;
c = x2`*p-(x`* p)##2 ;
return( c ) ;
finish ;


p = { 0.2 , 0.1 , 0.4 , 0.3 } ;
x = { 1 , 3 , -2 , 4 } ;
evalue = ex ( x , p ); 
varp = varp ( x , p );
print evalue  varp;


reset  noprint ;
n = 10  ;  p= 0.4 ; 
x = 0 : n ;
pxx = pdf ("binomial" , x , p , n ) ;
print   ( x` ) ( pxx` ) [ format = 10.5 ] ;
z1 = ex( x` , pxx`); 
z2 = varp( x`, pxx`);
print  z1  z2 ;


start  regress  ;                  /***** regress モジュールの作成開始 */
beta = solve( t(x) * x , t(x) * y ) ;           /*  パラメータ推定値   */
 yhat = x * beta ;                                       /*  予測値    */
 resid = y -yhat ;                                        /*  残差     */
sse = ssq ( resid ) ;                             /*  sse (平均平方)   */
 n = nrow( x ) ;                                   /*  サンプルサイズ  */
 df = nrow( x ) - ncol( x ) ;                        /*  誤差の自由度  */
 mse = sse/df;                                               /*  mse   */
 cssy = ssq( y - sum( y ) / n ) ;              /*  修正済誤差の平方和  */
 rsquare= ( cssy - sse ) / cssy ;                         /*  R-Square */
print  , "Regression Results " ,                             /*  出力  */
   sse  df  mse  rsquare ;

stdb = sqrt( vecdiag( inv( t(x) * x ))* mse ) ;    /* 推定値の標準誤差 */
t= beta / stdb ;                                            /*  t 値   */
prob=1- probf(t#t,1,df);                                     /*  p 値  */

print,"Parameter Estimate" ,,  beta  stdb  t  prob ;
print ,  y  yhat  resid ;
finish  regress ;                 /****  regress モジュールの作成終了 ***/

x={  1  1  1 ,  1  2  4 ,  1  3  9 ,  1  4  16 ,  1  5  25  }  ;
y={ 1 ,  5 ,  9 ,  23 ,  36 } ;
reset  noprint ;
run  regress ; 


quit; 



/***** 付録 **************************************/



proc iml; 
a = {123.456789  123456.78};
print "a= "  a  [format=7.4] ,, "a +1000 ="( a+1000 ) [ format=8.4 ] ;
   
ma={ 1  2  3  4 , 5  6  7  8 ,  0  -1  -2.4  -3.123 } ;
print  ma ;
rn = { a , b , c } ;
print  ma  [ rowname=rn ];
cn= { c1  c2  c3  c4 } ;
print  ma [rowname=rn  colname=cn  format=5.3  label="Matrix ma" ] ;


proc  iml ;
reset  noprint;
a={  1e-13   1e-12   1e-11   1e-10  
     123456789012345   1234567890123456  }  ;
print  a ;
reset  fuzz  fw=15  nocenter;
print  a ;
reset  nofuzz  fw=12  center;
print  a ;
show  options ;
ma = { 1  2  3  4  ,  5  6  7  8  ,  0  -1  -2.4  -3.123 } ;
reset  autoname ;
print  ma ;

reset  autoname ;
rows='Tokyo1':'Tokyo3' ; 
print rows ; 
cols = {Jan  Feb  Mar  Apr  May } ; 
print  cols ; 
A={ 1 1 1 , 2  2  2 , 3  3  3 };
B={ 0.1  0.2  0.3 , 1.01 0.02  0.03 , 0 1 10 } ;
mattrib  A  rowname=rows colname=cols label={'matrix  A'} 
B label = {'matrix  B'}  format=6.3  ; 
print  A  , , B ;

mattrib  A  rowname = ( rows [ 1 : 3 ] ) 
  colname = ( cols [ 3 : 5] )
  label = { 'matrix A of  Mar , Apr , May' } 
  format = 5.2  ; 
print A ; 

quit;



proc iml;
indep = {15 43 31 22 32  3 21 34 45 66 56 19}`;
dep= {5 4 1 2 2 2 3  7 5 14 16 9  }`;
print  indep  dep;
create  ds var {"indep", "dep"};
append;
close ds;

submit;
proc  means  data=ds noprint;
var  indep  dep;
output  out=outds  mean(indep)=meanx  mean(dep)=meany ;
run;
endsubmit;

use outds;
read all var {"meanx","meany"};
close outds;
print  meanx  meany ;

submit;
proc sgplot data=ds;
title "SGPLOT";
reg y=dep   x=indep;
run;
endsubmit;


quit;


proc iml;
call randseed(0);
data='A1' : 'A7';
p={0.3, 0.3, 0.1, 0.05, 0.05, 0.1, 0.1};
rdata=ranperm(data);
rsamp5=ranperk(data, 5);
rs1=sample(data, 5,"replace", p);
rs2=sample(data, 5,"wor");
rsampb=ranperm({A B C D}, 2);
print data, rdata,  rsamp5, rs1, rs2,  rsampb;
quit;
