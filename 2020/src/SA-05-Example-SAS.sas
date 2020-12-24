* class5.sas
  written by Steve Simon
  May 15, 2018;

** preliminaries **;

%let path=/folders/myfolders;
%let xpath=c:/Users/simons/Documents/SASUniversityEdition/myfolders;

ods pdf file="&path/survival-lecture5/sas/class5.pdf";

libname survival
  "&path/data";

* Before you start, peek at the data to refresh
  you memory about what variables you have and
  how they are coded.
;

proc print
    data=survival.whas100(obs=5);
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
    data=survival.whas100;
  model time_yrs*fstat(0)= / d=exponential;
  output out=exp cres=LAMBDA_exp;
run;

* Let's calculate the estimated survival curve
  for the exponential fit using the relationship
  shown above.
;

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
    data=survival.whas100;
  model time_yrs*fstat(0)= / d=weibull;
  output out=weib cres=LAMBDA_weib;
run;

* Let's calculate the estimated survival curve
  for the weibull fit using the relationship
  shown above.
;

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

* You've already seen how the lifetest procedure
  can produce a survival curve. You can also
  output a new data set with the values of
  the Kaplan-Meier survival estimates.
;

proc lifetest
     notable
	 outsurv=km
     data=survival.whas100;
  time time_yrs*fstat(0);
  title "Kaplan-Meier curve for WHAS100 data";
run;

* Let's calculate the cumulative hazard function
  using the above equation.
;

data km;
  set km(keep=time_yrs SURVIVAL);
  LAMBDA_km = -log(SURVIVAL);
  rename SURVIVAL=S_km;
  model="km";
run;

proc print
    data=km(obs=10);
run;

* Combine the three data sets so you can 
  overlay them in a single plot.
;

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
  step x=time_yrs y=s_km / justify=right attrid=dist group=model;
  series x=time_yrs y=s_exp / attrid=dist group=model;
  series x=time_yrs y=s_weib / attrid=dist group=model;
  yaxis values=(0 to 1 by 0.25);
  title1 "Comparison of survival functions";
run;

proc sgplot
    dattrmap=color_map
    data=ewk;
  step x=time_yrs y=LAMBDA_km / justify=right attrid=dist group=model;
  series x=time_yrs y=LAMBDA_exp / attrid=dist group=model;
  series x=time_yrs y=LAMBDA_weib / attrid=dist group=model;
  title1 "Comparison of cumulative hazards";
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

ods pdf close;