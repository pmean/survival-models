* survival-lecture-4.sas
  written by Steve Simon
  May 15, 2018;

** preliminaries **;

options orientation=landscape;

ods pdf
  file="../results/survival-lecture-4-sas.pdf";

libname survival
  "../data";

proc print
    data=survival.whas500(obs=10);
run;
** one-at-a-time **;

data survival.whas500_mod;
  set survival.whas500;
  time_yrs=lenfol/365.25;
run;

data work.gender;
  gender=0; output;
  gender=1; output;
run;

proc phreg
    plots(overlay)=survival
    data=survival.whas500_mod;
  baseline covariates=work.gender;
  model time_yrs*fstat(0)=gender;
run;

data work.age;
  age=45; output;
  age=65; output;
  age=85; output;
run;

proc phreg
    plots(overlay)=survival
    data=survival.whas500_mod;
  baseline covariates=work.age;
  model time_yrs*fstat(0)=age;
run;

proc phreg
    data=survival.whas500_mod;
  model time_yrs*fstat(0)=gender age;
run;

proc sort
    data=survival.whas500_mod;
  by gender;
run;

proc means 
    data=survival.whas500_mod;
  var age;
run;

proc means 
    data=survival.whas500_mod;
  by gender;
  var age;
  output out=gender_means mean=age;
run;

proc print data=gender_means;
run;

proc sgplot
    data=survival.whas500_mod;
  hbox age / category=gender;
run;

data work.unadjusted_comparison;
  gender=0; age=66.6; output;
  gender=1; age=74.7; output;
run;

proc phreg
    plots(overlay)=survival
    data=survival.whas500_mod;
  baseline covariates=work.unadjusted_comparison;
  model time_yrs*fstat(0)=gender age;
run;

data work.adjusted_comparison;
  gender=0; age=69.8; output;
  gender=1; age=69.8; output;
run;

proc phreg
    plots(overlay)=survival
    data=survival.whas500_mod;
  baseline covariates=work.adjusted_comparison;
  model time_yrs*fstat(0)=gender age;
run;

data work.bmi;
  bmi=20; output;
  bmi=30; output;
  bmi=40; output;
run;

proc means
    data=survival.whas500_mod;
  var bmi;
run;

proc means
    data=survival.whas500_mod;
  by gender;
  var bmi;
run;

proc sgplot
    data=survival.whas500_mod;
  hbox bmi / category=gender;
run;

proc sgplot
    data=survival.whas500_mod;
  scatter x=age y=bmi;
run;

proc phreg
    plots(overlay)=survival
    data=survival.whas500_mod;
  baseline covariates=work.bmi;
  model time_yrs*fstat(0)=bmi;
run;

data work.bmi_adjusted;
  bmi=20; gender=0.4; age=69.8; output;
  bmi=30; gender=0.4; age=69.8; output;
  bmi=40; gender=0.4; age=69.8; output;
run;

proc phreg
    plots(overlay)=survival
    data=survival.whas500_mod;
  baseline covariates=work.bmi_adjusted;
  model time_yrs*fstat(0)=bmi age gender;
run;

proc phreg
    data=survival.whas500_mod;
  model time_yrs*fstat(0)=gender age gender*age;
  hazardratio gender / at (age=40 to 100 by 5);
run;

proc phreg
    nosummary
    data=survival.whas500_mod;
  model time_yrs*fstat(0)=gender;
  ods select ParameterEstimates; 
run;

proc phreg
    nosummary
    data=survival.whas500_mod;
  model time_yrs*fstat(0)=gender age;
  ods select ParameterEstimates; 
run;

proc phreg
    nosummary
    data=survival.whas500_mod;
  model time_yrs*fstat(0)=gender age bmi;
  ods select ParameterEstimates; 
run;

proc phreg
    nosummary
    data=survival.whas500_mod;
  model time_yrs*fstat(0)=gender;
  ods select FitStatistics; 
run;

proc phreg
    nosummary
    data=survival.whas500_mod;
  model time_yrs*fstat(0)=gender age;
  ods select FitStatistics; 
run;

proc phreg
    nosummary
    data=survival.whas500_mod;
  model time_yrs*fstat(0)=gender age bmi;
  ods select FitStatistics; 
run;

proc phreg
    noprint
    data=survival.whas500_mod;
  model time_yrs*fstat(0)=gender age bmi;
  output out=work.martingale resmart=r;
run;

proc print data=work.martingale(obs=10);
run;

proc sgplot
    data=work.martingale;
  pbspline x=age y=r / clm smooth=1E4;
run;

proc sgplot
    data=work.martingale;
  pbspline x=sysbp y=r / clm smooth=1E4;
run;

proc sgplot
    data=work.martingale;
  hbox r / category=chf;
run;

ods pdf close;
