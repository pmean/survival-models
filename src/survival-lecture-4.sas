* survival-lecture-4.sas
  written by Steve Simon
  May 15, 2018;

** preliminaries **;

ods html body="survival-lecture-4-sas.html";

ods graphics on
  / imagename="survival-lecture-4-sas-"
    reset=index;

libname survival
  "c:/Users/simons/My Documents/survival-models/bin";

proc print
    data=survival.whas500(obs=20);
run;
** one-at-a-time **;

data work.gender;
  input gender;
datalines;
0
1
run;

proc phreg
    plots(overlay)=survival
    data=survival.whas500;
  baseline covariates=work.gender;
  model time_yrs*fstat(0)=gender;
run;

data work.age;
  input age;
datalines;
45
65
85
run;

proc phreg
    plots(overlay)=survival
    data=survival.whas500;
  baseline covariates=work.age;
  model time_yrs*fstat(0)=age;
run;

proc phreg
    data=survival.whas500;
  model time_yrs*fstat(0)=gender age;
run;

proc sort
    data=survival.whas500;
  by gender;
run;

proc means 
    data=survival.whas500;
  var age;
run;

proc means 
    data=survival.whas500;
  by gender;
  var age;
run;

proc print data=work.gender_means;
run;

proc sgplot
    data=survival.whas500;
  hbox age / category=gender;
run;

data work.unadjusted_comparison;
  input gender age;
datalines;
0 66.6
1 74.7
run;

proc phreg
    plots(overlay)=survival
    data=survival.whas500;
  baseline covariates=work.unadjusted_comparison;
  model time_yrs*fstat(0)=gender age;
run;

data work.adjusted_comparison;
  input gender age;
datalines;
0 69.8
1 69.8
run;

proc phreg
    plots(overlay)=survival
    data=survival.whas500;
  baseline covariates=work.adjusted_comparison;
  model time_yrs*fstat(0)=gender age;
run;

data work.bmi;
  input bmi;
datalines;
20
30
40
run;

proc means
    data=survival.whas500;
  var bmi;
run;

proc means
    data=survival.whas500;
  by gender;
  var bmi;
run;

proc sgplot
    data=survival.whas500;
  hbox bmi / category=gender;
run;

proc sgplot
    data=survival.whas500;
  scatter x=age y=bmi;
run;

proc phreg
    plots(overlay)=survival
    data=survival.whas500;
  baseline covariates=work.bmi;
  model time_yrs*fstat(0)=bmi;
run;

data work.bmi_adjusted;
  input bmi;
  gender=0.4;
  age=69.8;
datalines;
20
30
40
run;

proc phreg
    plots(overlay)=survival
    data=survival.whas500;
  baseline covariates=work.bmi_adjusted;
  model time_yrs*fstat(0)=bmi age gender;
run;

proc phreg
    data=survival.whas500;
  model time_yrs*fstat(0)=gender age gender*age;
  hazardratio gender / at (age=40 to 100 by 5);
run;

proc phreg
    nosummary
    data=survival.whas500;
  model time_yrs*fstat(0)=gender;
  ods select ParameterEstimates; 
run;

proc phreg
    nosummary
    data=survival.whas500;
  model time_yrs*fstat(0)=gender age;
  ods select ParameterEstimates; 
run;

proc phreg
    nosummary
    data=survival.whas500;
  model time_yrs*fstat(0)=gender age bmi;
  ods select ParameterEstimates; 
run;

proc phreg
    nosummary
    data=survival.whas500;
  model time_yrs*fstat(0)=gender;
  ods select FitStatistics; 
run;

proc phreg
    nosummary
    data=survival.whas500;
  model time_yrs*fstat(0)=gender age;
  ods select FitStatistics; 
run;

proc phreg
    nosummary
    data=survival.whas500;
  model time_yrs*fstat(0)=gender age bmi;
  ods select FitStatistics; 
run;

proc phreg
    noprint
    data=survival.whas500;
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
