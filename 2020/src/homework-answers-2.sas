* homework2.sas
  written by Steve Simon
  September 9, 2018;

** preliminaries **;

ods pdf
  file="/folders/myfolders/survival-lecture2/sas/homework2.pdf";

libname survival
  "/folders/myfolders/data";

proc print
    data=survival.whas500(obs=10);
run;

proc freq 
    data=survival.whas500;
  tables fstat;
run;

proc lifetest
    notable
    plots=survival
    data=survival.whas500;
  time time_yrs*fstat(0);
  title "Kaplan-Meier curve for WHAS500 data";
run;

** analysis by gender **;

proc lifetest
    notable
    plots=survival
    data=survival.whas500;
  time time_yrs*fstat(0);
  strata gender;
  title "Comparison of survival for gender for WHAS500 data";
run;

proc phreg
    plots=(cumhaz survival)
    data=survival.whas500;
  model time_yrs*fstat(0)=gender;
run;

** analysis by age group **;

data temp;
  set survival.whas500;
  age_gp = " 0-59";
  if (age >= 60) then age_gp = "60-69";
  if (age >= 70) then age_gp = "70-79";
  if (age >= 80) then age_gp = ">=80";
run;

proc lifetest
    notable
    plots=survival
    data=temp;
  time time_yrs*fstat(0);
  strata age_gp;
  title "Comparison of survival for age groups for WHAS500 data";
run;

proc phreg
    data=temp;
  class age_gp;
  model time_yrs*fstat(0)=age_gp;
run;

proc phreg
    data=survival.whas500;
  model time_yrs*fstat(0)=age;
run;

ods pdf close;
