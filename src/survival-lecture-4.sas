* survival-lecture-4.sas
  written by Steve Simon
  May 15, 2018;

** preliminaries **;

ods html body="survival-lecture-2-sas.html";

ods graphics on
  / imagename="survival-lecture-2-sas-"
    reset=index;

libname survival
  "c:/Users/simons/My Documents/survival-models/bin";

filename whas500
  "c:/Users/simons/My Documents/survival-models/data/wiley/whas500.dat";

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
    admitdate
    disdate
    fdate
    los
    dstat
    lenfol
    fstat
  ;
  time_yrs=lenfol/365.25;
run;

** one-at-a-time **;

proc phreg
    data=survival.whas100;
  model time_yrs*fstat(0)=gender;
run;

proc phreg
    data=survival.whas100;
  model time_yrs*fstat(0)=age;
run;

proc phreg
    data=survival.whas100;
  model time_yrs*fstat(0)=gender age;
run;

proc sort
    data=survival.whas100;
  by gender;
run;

proc means 
    data=survival.whas100;
  by gender;
  var age;
run;
