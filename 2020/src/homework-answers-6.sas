* survival-exercises-6.sas
  written by Steve Simon
  May 15, 2018;
  
** Page **** Page **** Page **** Page **** Page **** Page **** Page **;

  title1 "Introduction to survival analysis. Exercises 06, SAS";
  title3 "1. Open the WHAS500 data set in the software program";
  title4 "of your choice";

  footnote1 "It is always a good idea to peek at the first few rows";
  footnote2 "of a dataset to orient yourself at the start.";

options orientation=landscape;
ods word file="survival-exercises-6.docx";

libname survival  "../bin";

data time_recode;
  set survival.whas500;
  time_yrs=lenfol / 365.25;
run;

proc print
    data=time_recode(obs=5);
run;

** Page **** Page **** Page **** Page **** Page **** Page **** Page **;

  title3 "a. Calculate and graph on the same graph a Kaplan-Meier curve";
  title4 "for the three cohorts associated with year. Does it appear as";
  title5 "if these survival curves differ? If so, do they appear to
  title6 "violate the assumption of proportional hazards?";

  footnote1 "The survival curves ...";

proc lifetest
    notable
    outsurv=km_by_year
    plots=survival
    data=time_recode;
  time time_yrs*status(0);
  strata year;
run;

** Page **** Page **** Page **** Page **** Page **** Page **** Page **;

  title3 "b. Calculate and interpret the complementary log-log plots.";

  footnote1 "These plots ...";

data km_by_year;
  set km_by_year;
  if survival > 0 and survival < 1 then cloglog = log(-log(SURVIVAL));
run;

proc sgplot
    data=km_by_year;
  series x=time_yrs y=cloglog / group=year;
run;

** Page **** Page **** Page **** Page **** Page **** Page **** Page **;

  title3 "c. Calculate, plot, and interpret the Schoenfeld residuals";
  title4 "from a Cox regression model with year as the only independent";
  title5 "variable.";
  
  footnote1 "The Schoenfeld residuals ...";
  
proc phreg
    data=time_recode;
  model time_yrs*status(0)=year;
  output out=schoenfeld
    ressch=s_year;
run;

proc sgplot
    data=schoenfeld;
  scatter x=time_yrs y=s_year;
  pbspline x=time_yrs y=s_year / clm;
run;

** Page **** Page **** Page **** Page **** Page **** Page **** Page **;

  title3 "d. Fit a Cox regression model with gender as an independent";
  title4 "variable and include year as a strata. Create estimated 
  title5 "survival plots for each strata comparing males to females.";

  footnote1 "The survival plots ...";

data augment;
  set time_recode(keep=time_yrs);
  do genderf=1 to 2;
    do year=1 to 3;
      status=.; output;
    end;
  end;
run;

proc sort
    data=augment;
  by time_yrs;
run;

data augment;
  set augment time_recode;
run;

proc phreg
    data=augment;
  model time_yrs*status(0)=gender;
  strata year;
  output out=surv_data survival=s;
run;

proc print
    data=surv_data(obs=5);
run;

proc sgplot
    data=surv_data;
  where status=. and year=1;
  step x=time_yrs y=s / group=gender;
  yaxis min=0;
  title1 "Survival comparison by prison for year=1";
run;

ods word close;
