/********   SAS Programming   付録  D　                          ****************/


/*****  D.1  health データセット作成　                   *******/
/*****　　および、フォーマット作成プログラム          *******/
/*                                                                */
/************************************************/

/***** health データセットの作成プログラム           ********/
data health;
input  id $  age  gender height	weight	sleeping  smoking  nsmoking;
cards; 
s001        20     1      162	  50	   7	   0	     0
s002 	    20 	   0	    .	   .	   7	   0	     0
s003	    20	   0 	  178	  74	   4	   1	    10
s004   	    20	   1	  165	  66	   5	   1	     5
s005	    20     0	  173	  85	   8	   1	     7
s006	    21	   1	  170	  65	   8       0	     0
s007	    21	   0	  180	  78	   5	   1	     5
s008  	    23	   0	  181	  75	   7	   1	     3
s009 	    23     1	  166	  54	   6	   0	     0
s010	    20     0	  175	  59	   8	   0	     0
s011	    21     0	  174	  65	   8	   0	     7
s012	    21 	   1	  155	  47	   6	   1	     5
s013	    21 	   0	  166	  57	   8	   1	     3
s014	    20	   1	    .	   .	   6	   0	     0
s015	    23     0	  165	  60	   6	   1	    10
k021	    20     0	    .	  75	   8	   0	     0
k022	    21	   0	  167	  68	   9	   0	     0
k023	    21	   1	  160	  50	   7	   0	     0
k024	    23	   0	  170	  78	   6	   1	     3
b025	    25	   0	  171	  45	   5	   1	    15
k026	    22	   1	  159	  53	   6	   1	     5
s103	    41     0	  172	  80	   5	   1	    40
s104	    29	   0	  177	  69	   7	   0	     0
s105	    30     0	  166	  58	   5	   1	    20
s106	    31	   0	  169	  57	   6	   1	    30
;
run;
/***********************************************************/

/***  フォーマットカタログ作成 ***********************************/
/***  生成したフォーマットを health データセットに割り当てる *******/
proc  format ;
value  genderfmt  0="男"         1="女" ;
value  smkfmt   0="喫煙歴なし"  1="喫煙" ; 
run;

data  health ;
 set  health;
 label  age="年齢"  gender="性別"  height= "身長"  weight="体重"
        sleeping= "睡眠時間"        smoking="喫煙歴"   
        nsmoking= "１日の喫煙本数" ;
format  gender   genderfmt.  ; 
format  smoking  smkfmt.  ; 
 run;
/***********************************************************/

/***  health データセットの内容を表示する *************************/
title  "health data" ;
proc  print  data=health  label;
run;
/**********************************************************/

title; 


/*****     SASデータセット作成プログラム                     ******/
/*****     D. 2   survey　データセットの作成                  ******/
/*****         survey 用フォーマット作成                        ******/
/**************************************************/


/*****    survey　データセットの作成                       *******/
data  survey;
input  pin $  area $  ctime  money  sc  career ; 
label  pin="学籍番号"   area="住所"   ctime="通学時間"
       money="所持金"   sc="満足度"   career="進路"  ; 
informat  money  comma.  ; 
format    money  yen.  ; 
cards;
s001    東京          60   1,000       1       1
s002    埼玉          90     300       1       2
s003    東京          70   3,000       1       2
s004    神奈川        65   5,000       1       1
s005    東京           5     300       4       1
s006    東京          15   3,000       5       2
s007    千葉          30  10,000       5       4
s008    神奈川        80  15,000       5       4
s009    その他       105   2,000       3       1
s010    埼玉          55   5,000       4       1
s011    埼玉          60  20,000       3       4
s012    群馬         100   8,000       1       1
s013    栃木         100   3,000       3       4
s014    その他        90  13,000       2       1
s015    東京          50     500       1       1
k021    東京          40   5,000       2       2
k022    東京          45   5,000       4       2
k023    栃木         105  13,000       3       4
k024    千葉          60  10,000       1       1
k025    その他        90   2,000       3       1
k026    東京          30   4,000       4       2
s103    神奈川        45  20,000       2       3
s104    神奈川        35  30,000       3       4
s105    埼玉          60  45,000       4       1
s106    東京          10   5,000       2       2
;
run;
/***********************************************************/



/***  survey 用フォーマットカタログ作成と  **************************/
/***  フォーマットの survey　データセットへの割り当て 　　　*********/
proc  format ;
value  scfmt 1="大変満足"  2="満足" 3="普通" 4="不満足" 5="大変不満" ; 
value  careerfmt 1="就職"  2="進学" 3="教員" 4="その他" ; 
run;

data survey;
 set survey;
 format sc scfmt.  career  careerfmt. ;
run;
/************************************************************/


/***** survey データセットの内容の表示 ****************************/
title "student survey";
proc print data=survey  label; 
run;
/************************************************************/

title; 
