* survival-exercises-4.sas
  written by Steve Simon
  May 15, 2018;

** Page **** Page **** Page **** Page **** Page **** Page **** Page **;

  title1 "Introduction to survival analysis. Exercises 04, SAS";
  title3 "1. Open the WHAS500 data set in the software program";
  title4 "of your choice";

  footnote1 "It is always a good idea to peek at the first few rows";
  footnote2 "of a dataset to orient yourself at the start.";

options orientation=landscape;
ods word file="test.docx";

libname survival  "../data";

data time_recode;
  set survival.whas500;
  time_yrs=lenfol / 365.25;
run;

proc print
    data=time_recode(obs=5);
run;

** Page **** Page **** Page **** Page **** Page **** Page **** Page **;

  title3 "a. Calculate a Cox regression model for systolic blood";
  title4 "pressure (sysbp) by itself"; 

  footnote1 "The p-value is less than 0.05 and the hazard ratio";
  footnote2 "is less than 1. There is evidence of a statistically";
  footnote3 "significant decline in mortality as sysbp increases.";


proc phreg
    data=time_recode;
  model time_yrs*fstat(0)=sysbp;
run;

** Page **** Page **** Page **** Page **** Page **** Page **** Page **;

  title3 "and then adjusted for gender and age.";

  footnote1 "The inclusion of gender and age does not appear to";
  footnote2 "have much effect on the hazard ratio for sysbp.";
  
proc phreg
    data=time_recode;
  model time_yrs*fstat(0)=sysbp gender age;
run;

** Page **** Page **** Page **** Page **** Page **** Page **** Page **;

  footnote1 "Neither gender nor age appears to be associated with sysbp.";

proc sgplot
    data=survival.whas500_mod;
  hbox sysbp / category=gender;
run;


proc sgplot
    data=survival.whas500_mod;
  scatter x=age y=sysbp;
run;


** Page **** Page **** Page **** Page **** Page **** Page **** Page **;

  title3 "Calculate the unadjusted survival curves for patients";
  title4 "with systolic blood pressures of 120, 140, and 160.";

  footnote1 "The unadjusted comparison shows a small decrease";
  footnote2 "in risk of death as sysbp increases.";

data sysbp_unadjusted;
  sysbp=120; output;
  sysbp=140; output;
  sysbp=160; output;
run;

proc phreg
    plots(overlay)=survival
    data=time_recode;
  baseline covariates=sysbp_unadjusted;
  model time_yrs*fstat(0)=sysbp;
run;

** Page **** Page **** Page **** Page **** Page **** Page **** Page **;

  title3 "Then recalculate these survival curves with age set";
  title4 "to the overall average age, and to a population";
  title5 "that is 30% female. Interpret your results.";

  footnote1 "The results are largely unchanged after adjustment.";


data sysbp_adjusted;
  sysbp=120; gender=0.3; age=69.8; output;
  sysbp=140; gender=0.3; age=69.8; output;
  sysbp=160; gender=0.3; age=69.8; output;
run;

proc phreg
    plots(overlay)=survival
    data=time_recode;
  baseline covariates=sysbp_adjusted;
  model time_yrs*fstat(0)=sysbp age gender;
run;

** Page **** Page **** Page **** Page **** Page **** Page **** Page **;

  title3 "b. Calculate cubic spline model for systolic blood";
  title4 "pressure with four degrees of freedom.";

  footnote1 "The spline is statistically significant.";

data sysbp_recode;
  set time_recode;
  sysbp_c = sysbp - 144.7;
run;

* Modeled loosely after
  https://blogs.sas.com/content/iml/2019/10/16/visualize-regression-splines.html;

proc phreg
    data=sysbp_recode;
  effect 
    sysbp_spline5=
      spline(
        sysbp_c
         / details 
           naturalcubic
           knotmethod=equal(5));
  model time_yrs*fstat(0)=sysbp_spline5;
  output out=spline_data xbeta=log_hazard_ratio;
run;

** Page **** Page **** Page **** Page **** Page **** Page **** Page **;

  title3 "Plot this spline and offer an informal assessment";
  title4 "as to whether your spline function deviates markedly";
  title5 "from a linear relationship.";

  footnote1 "The risk is worst for very low values, best around 150";
  footnote2 "and moderately bad for values much larger than this.";

data spline_data;
  set spline_data;
  hazard_ratio=exp(log_hazard_ratio);
run;

proc sgplot
    data=spline_data;
  scatter x=sysbp y=hazard_ratio;
run;

** Page **** Page **** Page **** Page **** Page **** Page **** Page **;

  title3 "c. Calculate the Martingale residuals from your Cox model";
  title4 "with a linear term for systolic blood pressure and for age";
  title5 "and a term for gender. Plot these residuals versus ";
  title6 "diastolic blood pressure.";

  footnote1 "There may be an effect for diastolic blood pressure";
  footnote2 "similar to what you saw for the spline model for";
  footnote3 "systolic blood pressure.";

proc phreg
    noprint
    data=time_recode;
  model time_yrs*fstat(0)=sysbp age gender;
  output out=residual_data resmart=martingale_residual;
run;

proc sgplot
    data=residual_data;
  pbspline x=diasbp y=martingale_residual;
run;

** Page **** Page **** Page **** Page **** Page **** Page **** Page **;

  title3 "Repeat this residual plot analysis";
  title4 "using myocardial infection type (mitype).";

  footnote1 "There appears to be no difference in the residuals";
  footnote2 "for the two different infarction types.";

proc sgplot
    data=residual_data;
  hbox martingale_residual / category=mitype;
run;

ods word close;
