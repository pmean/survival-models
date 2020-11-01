* survival-lecture-1.sas
  written by Steve Simon
  March 24, 2018;

** preliminaries **;

ods html body="survival-lecture-1-sas.html";

ods graphics on
  / imagename="survival-lecture-1-sas-"
    reset=index;

libname survival
  "c:/Users/simons/My Documents/survival-models/bin";

** whas100 **;

* Read the data-dictionary-whas100.txt file in 
  the doc subdirectory for information about 
  this data set.

  Out of respect for the book's copyright, I am
  not reproducing the whas100.txt file in the git
  repository. See README.md in the main folder or
  the data dictionary file mentioned above for
  details about how to download this file.      ;

filename whas100
  "c:/Users/simons/My Documents/survival-models/data/wiley/whas100.dat";

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

proc lifetest
  plots=survival
  data=survival.whas100;
  time time_yrs*fstat(0);
  title "Kaplan-Meier curve for WHAS100 data";
run;

** graph including point-wise confidence limits **;

proc lifetest
    notable
    plots=survival(cl)
    data=survival.whas100;
  time time_yrs*fstat(0);
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

** analysis by age group **;

proc lifetest
    notable
    plots=survival
    data=survival.whas100;
  time time_yrs*fstat(0);
  strata age(60, 70, 80);
  title "Comparison of survival for age groups for WHAS100 data";
run;

