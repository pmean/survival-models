* class6.sas
  written by Steve Simon
  October 21, 2018;

** preliminaries **;

%let path=/folders/myfolders;
%let xpath=c:/Users/simons/Documents/SASUniversityEdition/myfolders;

ods pdf file="&path/survival-lecture6/sas/class6.pdf";

libname survival
  "&path/data";
  
filename heroin
  "&path/data/heroin.txt";
  
data survival.heroin;
  infile "&path/data/heroin.txt" dlm='09'x firstobs=2;
  input id clinic status time prison dose @@;
  time_yrs = time / 365.25;
run;

proc print
    data=survival.heroin(obs=5);
run;

proc lifetest
    notable
    outsurv=km_by_clinic
    plots=survival
    data=survival.heroin;
  time time_yrs*status(0);
  strata clinic;
  title "Comparison of survival by clinic";
run;

proc lifetest
    notable
    outsurv=km_by_prison
    plots=survival
    data=survival.heroin;
  time time_yrs*status(0);
  strata prison;
  title "Comparison of survival by prison";
run;

proc lifetest
    notable
    outsurv=km_by_dose
    plots=survival
    data=survival.heroin;
  time time_yrs*status(0);
  strata dose(40, 50, 60, 70);
  title "Comparison of survival by dose groups";
run;

* Peek at one data set to orient yourself
;

proc print
    data=km_by_dose(obs=5);
  title1 "Kaplan-Meier values";
run;

* Compute the complementary log-log transformation
;

data km_by_clinic;
  set km_by_clinic;
  if survival > 0 and survival < 1 then cloglog = log(-log(SURVIVAL));
run;

data km_by_prison;
  set km_by_prison;
  if survival > 0 and survival < 1 then cloglog = log(-log(SURVIVAL));
run;

data km_by_dose;
  set km_by_dose;
  if survival > 0 and survival < 1 then cloglog = log(-log(SURVIVAL));
run;

proc sgplot
    data=km_by_clinic;
  series x=time_yrs y=cloglog / group=clinic;
  title1 "Complementary log-log plot for clinic";
run;

proc sgplot
    data=km_by_prison;
  series x=time_yrs y=cloglog / group=prison;
  title1 "Complementary log-log plot for prison";
run;

proc sgplot
    data=km_by_dose;
  series x=time_yrs y=cloglog / group=dose;
  title1 "Complementary log-log plot for dose groups";
run;

* Compute the Schoenfeld residuals
;

proc phreg
    data=survival.heroin;
  model time_yrs*status(0)=clinic prison dose;
  output out=schoenfeld
    ressch=s_clinic s_prison s_dose;
  title1 "Cox regression model";
run;

proc sgplot
    data=schoenfeld;
  scatter x=time_yrs y=s_clinic;
  pbspline x=time_yrs y=s_clinic / clm;
  title1 "Schoenfeld residuals for clinic";
run;

proc sgplot
    data=schoenfeld;
  scatter x=time_yrs y=s_prison;
  pbspline x=time_yrs y=s_prison / clm;
  title1 "Schoenfeld residuals for prison";
run;

proc sgplot
    data=schoenfeld;
  scatter x=time_yrs y=s_dose;
  pbspline x=time_yrs y=s_dose / clm;
  title1 "Schoenfeld residuals for dose";
run;

* stratify by clinic
;

data augment;
  set survival.heroin(keep=time_yrs);
  do clinic=1 to 2;
    do prison=0 to 1;
      status=.; dose=60; output;
    end;
  end;
run;

proc sort
    data=augment;
  by time_yrs;
run;

proc print
    data=augment(obs=10);
  title1 "Test";
run;

data augment;
  set augment survival.heroin;
run;

proc phreg
    data=augment;
  model time_yrs*status(0)=prison dose;
  strata clinic;
  output out=surv_data survival=s;
run;

proc sort
    data=augment;
  by time_yrs;
run;

proc print
    data=surv_data(obs=5);
run;

proc sgplot
    data=surv_data;
  where status=. and clinic=1;
  step x=time_yrs y=s / group=prison;
  yaxis min=0;
  title1 "Survival comparison by prison for clinic 1";
run;

proc sgplot
    data=surv_data;
  where status=. and clinic=2;
  step x=time_yrs y=s / group=prison;
  yaxis min=0;
  title1 "Survival comparison by prison for clinic 2";
run;

* model clinic as a time varying covariate
;

proc phreg
    data=survival.heroin;
  model time_yrs*status(0)=clinic prison dose clinic_by_time;
  clinic_by_time=clinic*time_yrs;
run;

 
data survival.transplant1;
  infile
    "&path/data/transplant1.csv" 
    firstobs=2
    dlm=",";
  informat 
    birth_dt $10.
    accept_dt $10.
    tx_date $10.
    fu_date $10.;
  input
    birth_dt $
    accept_dt $
    tx_date $
    fu_date $
    fustat
    surgery
    age
    futime
    wait_time
    transplant
    mismatch
    hla_a2
    mscore
    reject;
run;

proc print
    data=survival.transplant1(obs=10);
  title1 "Listing of transplant1 data set";
run;

data survival.transplant2;
  infile
    "&path/data/transplant2.csv" 
    firstobs=2
    dlm=",";
  input
    id
    start
    stop
    event
    transplant
    age
    year
    surgery;
run;

proc print
    data=survival.transplant2(obs=10);
  title1 "Listing of transplant2 data set";
run;

data transplant3;
  set survival.transplant1;
  id=_n_;
  if transplant=0 | wait_time=0 then do;
    start=0;
    stop=futime;
    event=fustat;
    output;
  end;
  else do;
    start=0;
    stop=wait_time;
    event=0;
    transplant=0;
    output;
    start=wait_time;
    stop=futime;
    event=fustat;
    transplant=1;
    output;
  end;
run;

proc print
    data=transplant3(obs=10);
  var id start stop event transplant;
  title1 "Recalculation of data set";

proc phreg
    data=survival.transplant1;
  model futime*fustat(0)=transplant age surgery;
  title1 "Naive analysis";
run;

proc phreg
    data=survival.transplant1;
  model futime*fustat(0)=transplant age surgery;
  if futime ^= . & futime < wait_time then transplant=0;
  title1 "Time varying model";
run;

proc phreg
    data=survival.transplant2;
  model (start,stop)*event(0)=transplant age surgery;
  title1 "Start/Stop version of time varying model";
run;

ods pdf close;