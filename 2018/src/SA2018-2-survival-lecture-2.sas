* survival-lecture-2.sas
  written by Steve Simon
  April 29, 2018;

** preliminaries **;

ods html body="survival-lecture-2-sas.html";

ods graphics on
  / imagename="survival-lecture-2-sas-"
    reset=index;

libname survival
  "c:/Users/simons/My Documents/survival-models/bin";

** overall survival **;

proc lifetest
    notable
    plots=survival
    data=survival.whas100;
  time time_yrs*fstat(0);
  title "Kaplan-Meier curve for WHAS100 data";
run;

** analysis by gender **;

proc lifetest
    notable
    plots=survival
    data=survival.whas100;
  time time_yrs*fstat(0);
  strata gender;
  title "Comparison of survival for gender for WHAS100 data";
run;

proc phreg
    plots=(cumhaz survival)
    data=survival.whas100;
  model time_yrs*fstat(0)=gender;
run;

** analysis by age group **;

data temp;
  set survival.whas100;
  age_gp = " 0-59";
  if (age > 60) then age_gp = "60-69";
  if (age > 70) then age_gp = "70-79";
  if (age > 80) then age_gp = ">=80";
run;

proc lifetest
    notable
    plots=survival
    data=temp;
  time time_yrs*fstat(0);
  strata age_gp;
  title "Comparison of survival for age groups for WHAS100 data";
run;

proc phreg
    data=temp;
  class age_gp;
  model time_yrs*fstat(0)=age_gp;
run;

proc phreg
    data=survival.whas100;
  model time_yrs*fstat(0)=age;
run;


