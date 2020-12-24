* survival-lecture-2.sas
  written by Steve Simon
  April 29, 2018;

** preliminaries **;

ods pdf
 file="/folders/myfolders/survival-lecture2/sas/class2.pdf";
 
libname survival
  "/folders/myfolders/data";


** print the first few rows 
   to make sure you have the
   right data                 ;

proc print
    data=survival.whas100(obs=10);
run;

* You've laready run an overall survival curve, but
  it doesnt hurt to run this again as a cross check   ;

proc lifetest
    notable
    plots=survival
    data=survival.whas100;
  time time_yrs*fstat(0);
  title "Kaplan-Meier curve for WHAS100 data";
run;

* You've also already run Kaplan-Meier curves for
  gender, but it's worth seeing them next to the
  survival curves created by Cox regresion            ;

proc lifetest
    notable
    plots=survival
    data=survival.whas100;
  time time_yrs*fstat(0);
  strata gender;
  title "Comparison of survival for gender for WHAS100 data";
run;

* You use the phreg procedure for Cox regression. 
  The model statement specifies the survival time
  and censoring variable on the left side of the
  equal sign and the covariate(s) on the right.

  I normally skip the estimated cumulative hazard 
  and survival plots in phreg, but include them
  here for pedagogic reasons. Notice how SAS provides
  a single survival curve at the "average gender."    ;

proc phreg
    plots=(cumhaz survival)
    data=survival.whas100;
  model time_yrs*fstat(0)=gender;
run;

* You can get estimates of survival for particular 
  levels of your covariate(s) by creating a special
  data set.                                           ;
  
data covariate_values;
  input gender id $;
  datalines;
0 Male
1 Female  
run;

proc phreg
    plots=(cumhaz survival)
    data=survival.whas100;
  model time_yrs*fstat(0)=gender;
  baseline covariates=covariate_values / rowid=id;
run;

* You can't insert cut points directly into phreg
  like you did for lifetest, so you need to create
  a temporary data set                                ;

data temp;
  set survival.whas100;
  age_gp = " 0-59";
  if (age >= 60) then age_gp = "60-69";
  if (age >= 70) then age_gp = "70-79";
  if (age >= 80) then age_gp = ">=80";
run;

proc phreg
    data=temp;
  class age_gp;
  model time_yrs*fstat(0)=age_gp;
run;

* You include a continuous variable directly into
  the model statement, and the hazard ratio 
  represents the ratio of the hazard functions
  for any specific age compared to age+1              ;

proc phreg
    data=survival.whas100;
  model time_yrs*fstat(0)=age;
run;

ods pdf close;
