* survival-lecture-6-2020-version.sas
  written by Steve Simon
  October 21, 2018;

** preliminaries **;

ods pdf file="../results/survival-lecture-6-2020-version.pdf";

libname survival
  "../bin";
  
filename heroin
  "../data/heroin.txt";
  
data survival.heroin;
  infile "../data/heroin.txt" dlm='09'x firstobs=2;
  input id clinic status time prison dose @@;
  time_yrs = time / 365.25;
run;

proc print
    data=survival.heroin(obs=5);
  title1 "List of heroin dataset (first five observations)";
run;

proc lifetest
    notable
    outsurv=km_by_clinic
    plots=survival
    data=survival.heroin;
  time time_yrs*status(0);
  strata clinic;
  title1 "Comparison of survival by clinic";
run;

proc lifetest
    notable
    outsurv=km_by_prison
    plots=survival
    data=survival.heroin;
  time time_yrs*status(0);
  strata prison;
  title1 "Comparison of survival by prison";
run;

proc lifetest
    notable
    outsurv=km_by_dose
    plots=survival
    data=survival.heroin;
  time time_yrs*status(0);
  strata dose(40, 50, 60, 70);
  title1 "Comparison of survival by dose groups";
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
    "../data/transplant1.csv" 
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
    wait_time ??
    transplant
    mismatch ??
    hla_a2 ??
    mscore ??
    reject ??;
run;

proc print
    data=survival.transplant1(obs=10);
  title1 "Listing of transplant1 data set";
run;

data survival.transplant2;
  infile
    "../data/transplant2.csv" 
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

* Analysis of leader data set;

proc import
    datafile="../data/leader1.csv"
    dbms=dlm
    out=survival.leader;
  delimiter=",";
  getnames=yes;
run;

data survival.leader;
  set survival.leader;
  if age ^= .;
  cens=(lost ^= 0);
run;

proc print
    data=survival.leader(obs=10);
  title1 "Leader data set";
  title2 "Partial listing";
run;

proc means
    data=survival.leader;
  var years start age loginc growth pop land literacy;
  title2 "Descriptive statistics";
run;

proc freq
    data=survival.leader;
  tables lost manner military conflict region;
run;

* First, let's look at this model in a binary
  fashion, with lost = "still in power" as
  censored observations and "constitutional
  exit" and "natural death" and 
  "non-constitutional exit" as events.
;

proc lifetest
    notable
    plots=survival
    data=survival.leader;
  time years*cens(0);
  strata manner;
  title2 "Simple KM curves";
run;

proc lifetest
    notable
    plots=survival
    data=survival.leader;
  time years*cens(0);
  strata military;
run;

proc lifetest
    notable
    plots=survival
    data=survival.leader;
  time years*cens(0);
  strata conflict;
run;

proc lifetest
    notable
    plots=survival
    data=survival.leader;
  time years*cens(0);
  strata region;
run;

proc lifetest
    notable
    plots=survival
    data=survival.leader;
  time years*cens(0);
  strata start(1969, 1979);
run;

proc lifetest
    notable
    plots=survival
    data=survival.leader;
  time years*cens(0);
  strata age(39, 59);
run;

* log(200) is approximately 5.3, 
  log(500) is approximately 6.2
;

proc lifetest
    notable
    plots=survival
    data=survival.leader;
  time years*cens(0);
  strata loginc(5.3, 6.2);
run;

proc lifetest
    notable
    plots=survival
    data=survival.leader;
  time years*cens(0);
  strata growth(0, 3.9);
run;

proc lifetest
    notable
    plots=survival
    data=survival.leader;
  time years*cens(0);
  strata pop(1, 10);
run;

proc lifetest
    notable
    plots=survival
    data=survival.leader;
  time years*cens(0);
  strata land(100, 1000);
run;

proc lifetest
    notable
    plots=survival
    data=survival.leader;
  time years*cens(0);
  strata literacy(50, 75);
run;

proc phreg
    data=survival.leader;
  class manner military;
  model years*cens(0)=
    manner military age;
  output
    out=martingale_residuals
    resmart=r_martingale;
  title2 "Model with three independent variables";
run;

* The plot of the Martingale residuals versus
  age (which is already in the model) provides
  an informal assessment as to whether there is
  a nonlinear effect of age above and beyond the
  linear effect already in the model.
  
  You do not need to plot the Martingale residuals
  versus the other two variables in the model,
  military and age, because categorical variables
  cannot have a nonlinear component.
;

proc sgplot
    data=martingale_residuals;
  loess x=age y=r_martingale / clm smooth=0.5;
  title3 "Plot of Martingale residuals";
run;

* When you plot the Martingale residuals versus
  variables not yet in the model, you get an
  informal assessment of whether these variables
  should be added to the model. For those
  variables which are continuous, you also get
  a hint as to whether the relationship is linear
  or nonlinear.
  
  Use boxplots, of course, for categorical variables.
;

proc sgplot
    data=martingale_residuals;
  vbox r_martingale / category=region;
run;  
  
proc sgplot
    data=martingale_residuals; 
  loess x=loginc y=r_martingale / clm smooth=0.5;
run;
  
proc sgplot
    data=martingale_residuals; 
  loess x=growth y=r_martingale / clm smooth=0.5;
run;
  
proc sgplot
    data=martingale_residuals; 
  loess x=pop y=r_martingale / clm smooth=0.5;
run;
  
proc sgplot
    data=martingale_residuals; 
  loess x=land y=r_martingale / clm smooth=0.5;
run;
  
proc sgplot
    data=martingale_residuals; 
  loess x=literacy y=r_martingale / clm smooth=0.5;
run;
  
* Update your multivariate model;

proc phreg
    data=survival.leader;
  class manner military region;
  model years*cens(0)=
    manner military age loginc region;
  output
    out=schoenfeld_residuals
    ressch=r_manner r_military r_age r_loginc r_region1 r_region2 r_region3;
  title2 "Model with five independent variables";
run;

* The Schoenfeld residuals help you assess whether
  a variable in the model meets the assumptions
  of proportional hazards.
  
  You plot the Schoenfeld residuals versus time
  (or possibly log(time)).  Anything other than a
  flat trend indicates a possible problem.
;

proc sgplot
    data=schoenfeld_residuals; 
  loess x=years y=r_manner / clm smooth=0.5;
  title3 "Plot of Schoenfeld residuals";
run;
  
proc sgplot
    data=schoenfeld_residuals; 
  loess x=years y=r_military / clm smooth=0.5;
run;
  
proc sgplot
    data=schoenfeld_residuals; 
  loess x=years y=r_age / clm smooth=0.5;
run;
  
proc sgplot
    data=schoenfeld_residuals; 
  loess x=years y=r_loginc / clm smooth=0.5;
run;
  
proc sgplot
    data=schoenfeld_residuals; 
  loess x=years y=r_region1 / clm smooth=0.5;
run;
  
proc sgplot
    data=schoenfeld_residuals; 
  loess x=years y=r_region2 / clm smooth=0.5;
run;
  
proc sgplot
    data=schoenfeld_residuals; 
  loess x=years y=r_region3 / clm smooth=0.5;
run;
  
* Competing risks analysis;

* You could analyze the Kaplan Meier curve for
  each event separately and then consider
  alternative events as censored. But this
  produces an overestimate of the probability
  of individual causes. In fact, if you sum
  up the cumulative probabilities for each
  individual event, you could end up with a
  total probability larger than 1.
  
  You can partition the probabilities up
  properly using the cumulative incidence
  function.
;

* Note that this code follows the code in
  Example 74.4 Nonparametric Analysis of
  Competing-Risks Data in the SAS 9.4
  documentation.
;

proc phreg
    data=survival.leader;
  model years*lost(0)= / eventcode=1;
  output out=cif1 cif=p1;
run;

proc sort
    nodupkey
    data=cif1
    out=cif1a(keep=years p1);  
  by years;

proc phreg
    data=survival.leader;
  model years*lost(0)= / eventcode=2;
  output out=cif2 cif=p2;
run;

proc sort
    nodupkey
    data=cif2
    out=cif2a(keep=years p2);  
  by years;

proc phreg
    data=survival.leader;
  model years*lost(0)= / eventcode=3;
  output out=cif3 cif=p3;
run;

proc sort
    nodupkey
    data=cif3
    out=cif3a(keep=years p3);  
  by years;

data cif;
  merge
    cif1a
    cif2a
    cif3a;
  by years;
  constitutional_means=p1;
  natural_death=p1+p2;
  nonconstitutional_means=p1+p2+p3;
run;

proc sgplot
    data=cif;
  step x=years y=constitutional_means;
  step x=years y=natural_death;
  step x=years y=nonconstitutional_means;
  yaxis min=0 max=1;
run;

* Repeat these steps, but on the subgroup where
  manner=nonconstitutional ascent
;

proc phreg
    data=survival.leader;
  model years*lost(0)= / eventcode=1;
  output out=cif1 cif=p1;
  where manner=1;
  title3 "Subgroup manner=nonconstitutional ascent";
run;

proc sort
    nodupkey
    data=cif1
    out=cif1a(keep=years p1);  
  by years;

proc phreg
    data=survival.leader;
  model years*lost(0)= / eventcode=2;
  output out=cif2 cif=p2;
  where manner=1;
run;

proc sort
    nodupkey
    data=cif2
    out=cif2a(keep=years p2);  
  by years;

proc phreg
    data=survival.leader;
  model years*lost(0)= / eventcode=3;
  output out=cif3 cif=p3;
  where manner=1;
run;

proc sort
    nodupkey
    data=cif3
    out=cif3a(keep=years p3);  
  by years;

data cif;
  merge
    cif1a
    cif2a
    cif3a;
  by years;
  constitutional_means=p1;
  natural_death=p1+p2;
  nonconstitutional_means=p1+p2+p3;
run;

proc sgplot
    data=cif;
  step x=years y=constitutional_means;
  step x=years y=natural_death;
  step x=years y=nonconstitutional_means;
  yaxis min=0 max=1;
run;

ods pdf close;
