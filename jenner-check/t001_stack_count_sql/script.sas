options validvarname=upcase;
data sd1.have;
  input (col1-col3) ($);
cards4;
value_1 value_2 value_3
value_2 value_2 value_4
value_1 value_3 value_3
;;;;
run;quit;

/* Stack the three columns and count distinct values per value */
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

proc print data=want;
run;quit;
