* homework1.sas
  written by Steve Simon
  March 24, 2018;

** preliminaries **;

ods pdf
  file="/folders/myfolders/survival-lecture1/sas/homework1.pdf";

libname survival
  "/folders/myfolders/data";

filename whas500
  "/folders/myfolders/data/wiley/whas500.dat";


data survival.whas500;
  infile whas500 delimiter=' ';
  input
    id
    age 
    gender
    hr
    sysbp
    diasbp
    bmi
    cvd
    afb
    sho
    chf
    av3
    miord
    mitype
    year
    admitdate $
    disdate $
    fdate $
    los
    dstat
    lenfol
    fstat;
  time_yrs=lenfol/365.25;
run;

proc print
    data=survival.whas500 (obs=10);
run;

proc freq
    data=survival.whas500;
  tables fstat / nopercent;
run;

proc means
    data=survival.whas500;
  var time_yrs;
run;

proc lifetest
    notable
    plots=survival
    data=survival.whas500;
  time time_yrs*fstat(0);
  title "Kaplan-Meier curve for WHAS500 data";
run;

** graph including point-wise confidence limits **;

proc lifetest
    notable
    plots=survival(cl)
    data=survival.whas500;
  time time_yrs*fstat(0);
run;

** analysis by gender **;

proc lifetest
    notable
    plots=survival
    data=survival.whas500;
  time time_yrs*fstat(0);
  strata gender / nodetail test=logrank;
  title "Comparison of survival for gender for WHAS500 data";
run;

** analysis by age group **;

proc lifetest
    notable
    plots=survival
    data=survival.whas500;
  time time_yrs*fstat(0);
  strata age(60, 70, 80) / nodetail test=logrank;
  title "Comparison of survival for age groups for WHAS500 data";
run;

ods pdf close;