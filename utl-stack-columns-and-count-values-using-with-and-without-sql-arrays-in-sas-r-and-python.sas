%let pgm=utl-stack-columns-and-count-values-using-with-and-without-sql-arrays-in-sas-r-and-python;

Stack columns and count values using with and without sql arrays in sas r and python

github
https://tinyurl.com/vcp7d3zr
https://github.com/rogerjdeangelis/utl-stack-columns-and-count-values-using-with-and-without-sql-arrays-in-sas-r-and-python

stackoverflow;
https://tinyurl.com/3djpa2f5
https://stackoverflow.com/questions/78909457/count-the-number-of-lines-with-at-least-one-value-for-each-value

%stop_submission;

   SOLUTIONS

     1 sas no sql arrays
     2 sas arrays (not as slow asyou might think)
     3 r sql arrays
     4 python sql arrays
     5 related repos
/*               _     _
 _ __  _ __ ___ | |__ | | ___ _ __ ___
| `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
| |_) | | | (_) | |_) | |  __/ | | | | |
| .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
|_|
*/

 /**************************************************************************************************************************/
 /*                                |                                                              |                        */
 /*          INPUT                 |     PROCESS                                                  |   OUTPUT               */
 /*          =====                 |     =======                                                  |   ======               */
 /*                                |                                                              |                        */
 /*  COL1       COL2       COL3    | TWO STEP PROCESS                                             |    WANT total          */
 /*                                |                                                              |                        */
 /* value_1    value_2    value_3  | GET DISTINCT VALUES BY COLUMN                                |      VALUE     CNT     */
 /* value_2    value_2    value_4  |                                                              |                        */
 /* value_1    value_3    value_3  | COL1                                                         |      value_1     1     */
 /*                                | value_1    value_1                                           |      value_2     2     */
 /*                                | value_2 => value_2                                           |      value_3     2     */
 /*                                | value_1                                                      |      value_4     1     */
 /*                                |                                                              |                        */
 /*                                | COL2                                                         |                        */
 /*                                | value_2    value_2                                           |                        */
 /*                                | value_2 => value_3                                           |                        */
 /*                                | value_3                                                      |                        */
 /*                                |                                                              |                        */
 /*                                | COL3                                                         |                        */
 /*                                | value_3    value_3                                           |                        */
 /*                                | value_4 => value_4                                           |                        */
 /*                                | value_3                                                      |                        */
 /*                                |                                                              |                        */
 /*                                | COUNT VALUES    SOLUTION                                     |                        */
 /*                                | STACK         ===========                                    |                        */
 /*                                |                      COUNT                                   |                        */
 /*                                | value_1                                                      |                        */
 /*                                | value_2       value_1    1                                   |                        */
 /*                                | value_2       value_2    2                                   |                        */
 /*                                | value_3       value_3    2                                   |                        */
 /*                                | value_3       value_4    1                                   |                        */
 /*                                | value_4                                                      |                        */
 /*                                |                                                              |                        */
 /*                                |                                                              |                        */
 /*                                | proc sql;                                                    |                        */
 /*                                |   create                                                     |                        */
 /*                                |      table colunq as                                         |                        */
 /*                                |   select                                                     |                        */
 /*                                |      value                                                   |                        */
 /*                                |     ,count(value) as cnt                                     |                        */
 /*                                |   from                                                       |                        */
 /*                                |      (  /* one line when using sql arrays */                 |                        */
 /*                                |       select distinct col1 as value from sd1.have union all  |                        */
 /*                                |       select distinct col2 as value from sd1.have union all  |                        */
 /*                                |       select distinct col3 as value from sd1.have            |                        */
 /*                                |      )                                                       |                        */
 /*                                |   group                                                      |                        */
 /*                                |      by value                                                |                        */
 /*                                | ;quit;                                                       |                        */
 /*                                |                                                              |                        */
 /*------------------------------------------------------------------------------------------------------------------------*/
 /*                                |                                                              |                        */
 /*                                | DOES THIS R SOLUTION ROLL OFF THE TIP OF YOUR TONGUE         |                        */
 /*                                | In addition i suspect python would not look like this        |                        */
 /*                                |                                                              |                        */
 /*                                | reshape(df,                                                  |                        */
 /*                                |         ids = rownames(df),                                  |                        */
 /*                                |         direction = "long",                                  |                        */
 /*                                |         varying = names(df)[1:3],                            |                        */
 /*                                |         v.names = "values") |>                               |                        */
 /*                                |   aggregate(cbind(n = id)                                    |                        */
 /*                                |    ~ values, data = _, \(x) length(unique(x)))               |                        */
 /*                                |                                                              |                        */
 /*********************************|**************************************************************|*************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/



libname sd1 "d:/sd1";
options validvarname=upcase;
data sd1.have;
  input (col1-col3) ($);
cards4;
value_1 value_2 value_3
value_2 value_2 value_4
value_1 value_3 value_3
;;;;
run;quit;

/*                                           _
/ |  ___  __ _ ___   _ __   ___    ___  __ _| |  __ _ _ __ _ __ __ _ _   _ ___
| | / __|/ _` / __| | `_ \ / _ \  / __|/ _` | | / _` | `__| `__/ _` | | | / __|
| | \__ \ (_| \__ \ | | | | (_) | \__ \ (_| | || (_| | |  | | | (_| | |_| \__ \
|_| |___/\__,_|___/ |_| |_|\___/  |___/\__, |_| \__,_|_|  |_|  \__,_|\__, |___/
                                          |_|                        |___/
*/

 proc sql;
   create
      table want as
   select
      value
     ,count(value) as cnt
   from
      (
       select distinct col1 as value from sd1.have union all
       select distinct col2 as value from sd1.have union all
       select distinct col3 as value from sd1.have
      )
   group
      by value
 ;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* WANT total                                                                                                             */
/*                                                                                                                        */
/*   VALUE     CNT                                                                                                        */
/*                                                                                                                        */
/*   value_1     1                                                                                                        */
/*   value_2     2                                                                                                        */
/*   value_3     2                                                                                                        */
/*   value_4     1                                                                                                        */
/*                                                                                                                        */
/**************************************************************************************************************************/

 %array(_vr,values=%utl_varlist(data=sd1.have));

 %put &=_vr1; * _VR1 = COL1 ;
 %put &=_vr2; * _VR2 = COL2 ;
 %put &=_vr3; * _VR3 = COL3 ;
 %put &=_vrn; * _VRN = 3    ;

 proc sql;
   create
      table want as
   select
      value
     ,count(value) as cnt
   from
      (
       %do_over(_vr,phrase=%str(
         select distinct ? as value from sd1.have)
         ,between=union all)
      )
   group
      by value
 ;quit;

%arraydelete(_vr);

/**************************************************************************************************************************/
/*                                                                                                                        */
/* WANT total                                                                                                             */
/*                                                                                                                        */
/*   VALUE     CNT                                                                                                        */
/*                                                                                                                        */
/*   value_1     1                                                                                                        */
/*   value_2     2                                                                                                        */
/*   value_3     2                                                                                                        */
/*   value_4     1                                                                                                        */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*____                    _
|___ /   _ __   ___  __ _| |   __ _ _ __ _ __ __ _ _   _ ___
  |_ \  | `__| / __|/ _` | |  / _` | `__| `__/ _` | | | / __|
 ___) | | |    \__ \ (_| | | | (_| | |  | | | (_| | |_| \__ \
|____/  |_|    |___/\__, |_|  \__,_|_|  |_|  \__,_|\__, |___/
                       |_|                         |___/
*/

%array(_vr,values=%utl_varlist(data=sd1.have));

%put &=_vr1; * _VR1 = COL1 ;
%put &=_vr2; * _VR2 = COL2 ;
%put &=_vr3; * _VR3 = COL3 ;
%put &=_vrn; * _VRN = 3    ;

proc datasets lib=sd1 nodetails nolist;
 delete rwant;
run;quit;

%utl_submit_r64x(resolv e("
 library(sqldf);
 library(haven);
 source('c:/oto/fn_tosas9x.R');
 have<-read_sas('d:/sd1/have.sas7bdat');
 want<-sqldf('
  select
     value
    ,count(value) as cnt
  from
     (
      %do_over(_vr,phrase=
        select distinct ? as value from have
        ,between=union all)
     )
  group
     by value
  ');
 want;
 fn_tosas9x(
       inp    = want
      ,outlib ='d:/sd1/'
      ,outdsn ='rwant'
      );
"));

%arraydelete(_vr);

proc print data=sd1.rwant;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  R                                                                                                                     */
/*                                                                                                                        */
/*  tosas9x( inp = want ,outlib ='d:/sd1/' ,outdsn ='rwant' );                                                            */
/*      value cnt                                                                                                         */
/*  1 value_1   1                                                                                                         */
/*  2 value_2   2                                                                                                         */
/*  3 value_3   2                                                                                                         */
/*  4 value_4   1                                                                                                         */
/*                                                                                                                        */
/* SAS                                                                                                                    */
/*                                                                                                                        */
/* Obs    ROWNAMES     VALUE     CNT                                                                                      */
/*                                                                                                                        */
/*  1         1       value_1     1                                                                                       */
/*  2         2       value_2     2                                                                                       */
/*  3         3       value_3     2                                                                                       */
/*  4         4       value_4     1                                                                                       */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*  _                 _   _                             _
| || |    _ __  _   _| |_| |__   ___  _ __    ___  __ _| |  __ _ _ __ _ __ __ _ _   _ ___
| || |_  | `_ \| | | | __| `_ \ / _ \| `_ \  / __|/ _` | | / _` | `__| `__/ _` | | | / __|
|__   _| | |_) | |_| | |_| | | | (_) | | | | \__ \ (_| | || (_| | |  | | | (_| | |_| \__ \
   |_|   | .__/ \__, |\__|_| |_|\___/|_| |_| |___/\__, |_| \__,_|_|  |_|  \__,_|\__, |___/
         |_|    |___/                                |_|                        |___/
*/
proc datasets lib=sd1 nodetails nolist;
 delete rwant;
run;quit;

%array(_vr,values=%utl_varlist(data=sd1.have));

%put &=_vr1; * _VR1 = COL1 ;
%put &=_vr2; * _VR2 = COL2 ;
%put &=_vr3; * _VR3 = COL3 ;
%put &=_vrn; * _VRN = 3    ;

%utl_submit_py64_310x(resolve('
 import pyperclip;
 import os;
 from os import path;
 import sys;
 import subprocess;
 import time;
 import pandas as pd;
 import pyreadstat as ps;
 import numpy as np;
 import pandas as pd;
 from pandasql import sqldf;
 mysql = lambda q: sqldf(q, globals());
 from pandasql import PandaSQL;
 pdsql = PandaSQL(persist=True);
 sqlite3conn = next(pdsql.conn.gen).connection.connection;
 sqlite3conn.enable_load_extension(True);
 sqlite3conn.load_extension("c:/temp/libsqlitefunctions.dll");
 mysql = lambda q: sqldf(q, globals());
 have, meta = ps.read_sas7bdat("d:/sd1/have.sas7bdat");
 exec(open("c:/temp/fn_tosas9.py").read());
 print(have);
 want = pdsql("""
  select
     value
    ,count(value) as cnt
  from
     (
      %do_over(_vr,phrase=
        select distinct ? as value from have
        ,between=union all)
     )
  group
     by value
 """);
 print(want);
 fn_tosas9(
    want
    ,dfstr="pwant"
    ,timeest=3
    );
'));

libname tmp "c:/temp";
proc print data=tmp.pwant;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  PYTHON                                                                                                                */
/*                                                                                                                        */
/*       value  cnt                                                                                                       */
/*  0  value_1    1                                                                                                       */
/*  1  value_2    2                                                                                                       */
/*  2  value_3    2                                                                                                       */
/*  3  value_4    1                                                                                                       */
/*                                                                                                                        */
/* SAS                                                                                                                    */
/*                                                                                                                        */
/*  Obs     VALUE     CNT                                                                                                 */
/*                                                                                                                        */
/*   1     value_1     1                                                                                                  */
/*   2     value_2     2                                                                                                  */
/*   3     value_3     2                                                                                                  */
/*   4     value_4     1                                                                                                  */
/*                                                                                                                        */
/**************************************************************************************************************************/
REPO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
https://github.com/rogerjdeangelis/utl-adding-sequence-numbers-and-partitions-in-SAS-sql-without-using-monotonic
https://github.com/rogerjdeangelis/utl-create-equally-spaced-values-using-partitioning-in-sql-wps-r-python
https://github.com/rogerjdeangelis/utl-find-first-n-observations-per-category-using-proc-sql-partitioning
https://github.com/rogerjdeangelis/utl-macro-to-enable-sql-partitioning-by-groups-montonic-first-and-last-dot
https://github.com/rogerjdeangelis/utl-partitioning-your-table-for-a-big-parallel-systask-sort
https://github.com/rogerjdeangelis/utl-pivot-long-pivot-wide-transpose-partitioning-sql-arrays-wps-r-python
https://github.com/rogerjdeangelis/utl-pivot-transpose-by-id-using-wps-r-python-sql-using-partitioning
https://github.com/rogerjdeangelis/utl-top-four-seasonal-precipitation-totals--european-cities-sql-partitions-in-wps-r-python
https://github.com/rogerjdeangelis/utl-transpose-pivot-wide-using-sql-partitioning-in-wps-r-python
https://github.com/rogerjdeangelis/utl-transposing-rows-to-columns-using-proc-sql-partitioning
https://github.com/rogerjdeangelis/utl-transposing-words-into-sentences-using-sql-partitioning-in-r-and-python
https://github.com/rogerjdeangelis/utl-using-DOW-loops-to-identify-different-groups-and-partition-data
https://github.com/rogerjdeangelis/utl-using-sql-in-wps-r-python-select-the-four-youngest-male-and-female-students-partitioning
https://github.com/rogerjdeangelis/utl_partition_a_list_of_numbers_into_3_groups_that_have_the_similar_sums_python
https://github.com/rogerjdeangelis/utl_partition_a_list_of_numbers_into_k_groups_that_have_the_similar_sums
https://github.com/rogerjdeangelis/utl_scalable_partitioned_data_to_find_statistics_on_a_column_by_a_grouping_variable
 /*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
