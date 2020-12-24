* class1.sas
  written by Steve Simon
  March 24, 2018;

** preliminaries **;

ods pdf
 file="/folders/myfolders/survival-lecture1/sas/class1.pdf";
 
libname survival
  "/folders/myfolders/data";

filename whas100
  "/folders/myfolders/data/wiley/whas100.dat";

** whas100 **;

* Read the whas100.txt file for 
  information about this data set.               ;

data survival.whas100;
  infile whas100 delimiter=' ';
  input
    id
    admitdate $
    foldate $
    los
    lenfol
    fstat
    age
    gender
    bmi;
  time_yrs=lenfol/365.25;
run;

* It's always a good idea to print the first few
  observations to see if there are any obvious
  problems with the data                               ;

proc print
    data=survival.whas100(obs=10);
run;

* Always run a count on the censoring variable to
  make sure you have a reasonable number of events
  (50 is a good rule of thumb). It is okay if the
  number of censored observations is smaller than 50 ;
  
proc freq
    data=survival.whas100;
  tables fstat / nopercent;
run;

* Also make sure that the range of your time variable
  is reasonable                                        ;
  
proc means
    data=survival.whas100;
  var time_yrs;
run;

* The lifetest procedure produces Kaplan-Meier curves
  and estimates. The notable option suppresses the
  printout of the Kaplan-Meier survival probabilities,
  as this table is very long. You have to explicitly
  request a plot of the survival curve.
  
  The time statement tells SAS what your time variable
  is and what your censoring variable is. The value in
  parentheses is the value indicating censoring         ;
  
 proc lifetest
     notable
     plots=survival
     data=survival.whas100;
  time time_yrs*fstat(0);
  title "Kaplan-Meier curve for WHAS100 data";
run;

* You can get confidence limits using the survival(cl) option ;

proc lifetest
    notable
    plots=survival(cl)
    data=survival.whas100;
  time time_yrs*fstat(0);
run;

* You can compare two or more groups using the strata statement ;

proc lifetest
    notable
    plots=survival
    data=survival.whas100;
  time time_yrs*fstat(0);
  strata gender / nodetail test=logrank;
  title "Comparison of survival for gender for WHAS100 data";
run;

* Since age is a continuous variable, you can only analyze
  it using cutpoints. The three cutpoints listed here
  divide age into four groups: 
    under 60
    60 to 69
    70 to 79
    80 and above                                            ;

proc lifetest
    notable
    plots=survival
    data=survival.whas100;
  time time_yrs*fstat(0);
  strata age(60, 70, 80) / nodetail test=logrank;
  title "Comparison of survival for age groups for WHAS100 data";
run;

ods pdf close;
