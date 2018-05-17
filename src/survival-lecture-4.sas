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

proc phreg
    zph
    plots=survival
    data=survival.whas500;
  model time_yrs*fstat(0)=gender;
run;

proc phreg
    data=survival.whas500;
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
  by gender;
  var age;
run;
