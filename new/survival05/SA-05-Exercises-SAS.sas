* hw5.sas was originally written by Steve Simon
  in October 2018.
;

** preliminaries **;

%let path=/folders/myfolders;
%let xpath=c:/Users/simons/Documents/SASUniversityEdition/myfolders;

ods pdf file="&path/survival-lecture5/sas/hw5.pdf";

libname survival
  "&path/data";

* 1. Open the WHAS500 data set in the software
  program of your choice.

  a. Calculate and graph on the same graph an
  overall Kaplan-Meier survival curve, a survival
  curve for an exponential model with no
  independent variables, and a survival curve for
  a Weibull model with no independent variables. 
  Does there appear to be a difference between 
  the exponential model and the Weibull model? 
  Does either model match the Kaplan-Meier curve?
;

proc print
    data=survival.whas500(obs=5);
run;

proc lifereg
    data=survival.whas500;
  model time_yrs*fstat(0)= / d=exponential;
  output out=exp cres=LAMBDA_exp;
run;

data exp;
  set exp(keep=time_yrs LAMBDA_exp);
  S_exp = exp(-LAMBDA_exp);
  model = "exp";
run;

proc sort 
    data=exp;
  by time_yrs;
run;

proc print data=exp(obs=10);
run;

proc lifereg
    data=survival.whas500;
  model time_yrs*fstat(0)= / d=weibull;
  output out=weib cres=LAMBDA_weib;
run;

data weib;
  set weib(keep=time_yrs LAMBDA_weib);
  S_weib = exp(-LAMBDA_weib);
  model = "weib";
run;

proc sort 
    data=weib;
  by time_yrs;
run;

proc print data=weib(obs=10);
run;

proc lifetest
     notable
	 outsurv=km
     data=survival.whas500;
  time time_yrs*fstat(0);
  title "Kaplan-Meier curve for WHAS500 data";
run;

data km;
  set km(keep=time_yrs SURVIVAL);
  LAMBDA_km = -log(SURVIVAL);
  rename SURVIVAL=S_km;
  model="km";
run;

proc print
    data=km(obs=10);
run;

data ewk;
  set exp weib km;
  label 
    s_km="Kaplan-Meier"
    s_weib="Weibull"
	s_exp="Exponential"
    LAMBDA_km="Kaplan-Meier"
    LAMBDA_weib="Weibull"
	LAMBDA_exp="Exponential";
run;

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
  step x=time_yrs y=s_km /
    justify=right attrid=dist group=model;
  series x=time_yrs y=s_exp / 
    attrid=dist group=model;
  series x=time_yrs y=s_weib / 
    attrid=dist group=model;
  yaxis values=(0 to 1 by 0.25);
  title1 "Comparison of survival functions";
run;

proc sgplot
    dattrmap=color_map
    data=ewk;
  step x=time_yrs y=LAMBDA_km / 
    justify=right attrid=dist group=model;
  series x=time_yrs y=LAMBDA_exp / 
    attrid=dist group=model;
  series x=time_yrs y=LAMBDA_weib / 
    attrid=dist group=model;
  title1 "Comparison of cumulative hazards";
run;

* b. Calculate a Weibull regression model with
  bmi, age, gender, and a age by gender 
  interaction. Estimate the impact of a 5 unit
  change in BMI on the survival percentiles,
  holding all of the other variables constant.

  c. Calculate a confidence interval for the 
  scale parameter of the Weibull model. 
  Interpret this interval.
;

data center;
  set survival.whas500;
  age_c=age-68.25;
  bmi_c=bmi-27.04;
run;

proc lifereg
    data=center;
  model time_yrs*fstat(0) = 
    gender age_c bmi_c age_c*gender / d=weibull;
  title1 "Weibull model with covariates and interaction";
run;

ods pdf close;