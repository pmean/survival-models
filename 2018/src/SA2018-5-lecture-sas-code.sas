* survival-lecture-5.sas
  written by Steve Simon
  May 15, 2018;

** preliminaries **;

ods html body="survival-lecture-5-sas.html";

ods graphics on
  / imagename="survival-lecture-5-sas-"
    reset=index;

libname survival
  "c:/Users/simons/My Documents/survival-models/bin";

proc print
    data=survival.whas100(obs=20);
run;
** one-at-a-time **;

data work.age;
  input age gender bmi;
datalines;
65 0 25
run;


proc lifereg
    data=survival.whas100
    xdata=work.age;
  model time_yrs*fstat(0)=gender*age bmi / d=exponential;
  probplot;
run;

