* survival-lecture-5-2020-version.sas
  written by Steve Simon
  May 15, 2018;

** preliminaries **;

ods pdf file="../results/survival-lecture-5-2020-version.pdf";

libname survival "../bin";

* Before you start, peek at the data to refresh
  you memory about what variables you have and
  how they are coded.
;

proc print
    data=survival.whas100(obs=5);
  title1 "First five rows of data";
run;

* The cres option on the output statement produces
  the Cox-Snell residuals, which for this simple
  model is the same as the cumulative hazard
  function. There is a simple mathematical 
  relationship between the survival function (S)
  and the cumulative hazard function (LAMBDA):

  S(t) = exp(-LAMBDA(t)) or

  -log(S(t)) = LAMBDA(t).
;

proc lifereg
    noprint
    data=survival.whas100;
  model time_yrs*fstat(0)= / d=exponential;
  output
    out=exp
    p=t_exp
    quantile=0.01 to 0.99 by 0.01;
run;

* Let's calculate the estimated survival curve
  for the exponential fit.
;

data exp;
  set exp;
  where t_exp <= 10 & ID=1;
  S_exp = 1-_PROB_;
  model = "exp";
  title1 "Exponential predictions";
run;

proc print data=exp;
run;

proc lifereg
    noprint
    data=survival.whas100;
  model time_yrs*fstat(0)= / d=weibull;
  output
    out=weib
    p=t_weib
    quantile=0.01 to 0.99 by 0.01;
run;

* Let's calculate the estimated survival curve
  for the weibull fit.
;

data weib;
  set weib;
  where t_weib <= 10 & ID=1;
  S_weib = 1-_PROB_;
  model = "weib";
run;

proc print data=weib;
  title1 "Weibull predictions";
run;

* You've already seen how the lifetest procedure
  can produce a survival curve. You can also
  output a new data set with the values of
  the Kaplan-Meier survival estimates.
;

proc lifetest
     noprint
	 outsurv=km
     data=survival.whas100;
  time time_yrs*fstat(0);
run;

data km;
  set km;
  rename SURVIVAL=S_km;
  model="km";
run;

proc print
    data=km(obs=10);
  title1 "Kaplan-Meier predictions (first ten rows)";
run;

* Combine the three data sets so you can 
  overlay them in a single plot.
;

data ewk;
  set exp weib km;
  label 
    S_km="Kaplan-Meier"
    S_weib="Weibull"
	S_exp="Exponential";
run;

* The color_map data set allows you to adjust the
  colors of each line segment
;

data color_map;
length linecolor $ 9;
input ID $ value $ linecolor $;
datalines;
dist exp red
dist weib brown
dist km green
;
run;

proc sgplot
    dattrmap=color_map
    data=ewk;
  step x=time_yrs y=S_km / justify=right attrid=dist group=model;
  series x=t_exp y=S_exp / attrid=dist group=model;
  series x=t_weib y=S_weib / attrid=dist group=model;
  yaxis values=(0 to 1 by 0.25);
  title1 "Comparison of survival functions";
run;

* You've seen with the Cox regression model that
  centering helps with the age by gender 
  interaction. So let's do the same here.
;

data center;
  set survival.whas100;
  age_c=age-68.25;
  bmi_c=bmi-27.04;
run;

proc lifereg
    data=center;
  model time_yrs*fstat(0)=gender age_c bmi_c age_c*gender / d=weibull;
  title1 "Weibull model with covariates and interaction";
run;

proc import
    datafile="../data/rats.csv"
    out=survival.rats
    dbms=csv
    replace;
  getnames=yes;
run;

proc print
    data=survival.rats(obs=10);
  title1 "First ten rows of rats file";
run;

proc freq
    data=survival.rats;
  table sex*status / norow nocol nopercent;
  title1 "Event counts by gender";
run;

proc phreg
    data=survival.rats;
  model time*status(0)=rx;
  where sex="f";
  title1 "Naive model";
run;

proc phreg
    data=survival.rats
	covs(aggregate);
  model time*status(0)=rx;
  id litter;
  where sex="f";
  title1 "Cluster model";
run;

proc phreg
    data=survival.rats
	covs(aggregate);
  class litter;
  model time*status(0)=rx;
  random litter;
  where sex="f";
  title1 "Frailty model";
run;

ods pdf close;
