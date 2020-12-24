* survival-lecture-3.sas
  written by Steve Simon
  September 23, 2018;

** preliminaries **;

ods pdf
 file="/folders/myfolders/survival-lecture3/sas/class3.pdf";

* I will use the data step to calculate power
  and run simulations, but the data step is
  not the ideal way to run simulations. In
  particular, the data step includes a lot
  of quality control and error checking that
  can slow things down. For the simple work
  I am illustrating here, it is not a problem,
  but for large scale simulations, you should
  consider something like IML.
;

* Consider a clinical trial where you have two
  groups and a survival endpoint. You want to
  get a sufficiently large sample size to insure
  that you can detect a hazard ratio of 2.0 with
  a power of 0.80. You want a two sided alpha
  level of 0.05. You expect to see roughly
  twice as many deaths in one group as in the
  other.
;

data sample_size;
  pi = 0.33;
  theta = log(2);
  z_alpha = probit(0.975);
  z_beta = probit(0.8);
  m = (z_alpha+z_beta)**2/(theta**2*pi*(1-pi));
  output;
run;

proc print data=sample_size;
run;

* Round this up to 75 deaths total, 25 in one group,
  and 50 in the other group.
  
  So, how many patients do you need to follow and for
  how long in order to get 75 deaths total?

  You need to account for deaths that you never see 
  
  * because they occur after your study ends, or
  * becuase of early dropouts.

  You need to start making assumptions. In this example,
  assume that 

  * you follow the average patient for three years, and
  * you will have a 20% early dropout rate,
  * deaths follow an exponential distribution, and
  * the baseline hazard rate is 0.4.

  You can (and should) modify these assumptions to
  check sensitivity.
;

data adjustment;
  m1 = 25;
  m2 = 50;
  lambda = 0.4;
  t = 3;
  dropout_rate = 0.2;
  adj1 = (1 - dropout_rate) * (1 - exp(-lambda*t));
  adj2 = (1 - dropout_rate) * (1 - exp(-2*lambda*t));
  n1 = m1 / adj1;
  n2 = m2 / adj2;
  output;
run;

proc print data=adjustment;
run;

* 
  To keep things simple, you might wish to use the larger
  of the two sample sizes in both groups.

  As mentioned earlier, the data step is not the best way
  to run a simulation. But it is simple to follow. To make
  things even easier, I will split the work into several
  different data steps.
  
  First, generate random entry times for each patient. For
  this simulation, I am assuming that successive patient arrival
  times exponentially distributed with a rate parameter of 
  1/50 (one patient every 50 days on average). 
;

data simulation_step1;
  call streaminit(45231);
  n = 22;
  entry_time = 0;
  seed=45321;
  do i=1 to n;
    entry_time = entry_time + rand('exponential') / (0.02*365);
    group = 1 + rand('bernoulli', 0.5);
    output;
  end;
run;

proc print data=simulation_step1;
  var entry_time group;
run;

* 
  The patients in this study are not very ill, so the event rate
  is rather low, 0.05 per year in the first group and 0.10 in the
  second group.
;

data simulation_step2;
  set simulation_step1;
  event_time = entry_time + rand('exponential') / (0.05*group);
run;

proc print data=simulation_step2;
  var entry_time event_time group;    
run;

*
  Notice how long many of these event times are. The study has to
  end ten years after the start, so many of the events will be
  censored.
;

data simulation_step3;
  set simulation_step2;
  censor_code = 0;
  if event_time <= 10 then censor_code = 1;
  event_time = min(event_time, 10);
run;

proc print data=simulation_step3;
  var entry_time event_time censor_code group;    
run;

*
  Some patients will drop out before the study closes. Model
  the drop out time using an exponential distribution with a
  rate of 0.06. When the early drop out time is less than 
  the event time, then you substitute the drop out time for
  the event time and remark the observation as censored.
  
  Note that if an observation was censored at 10 years AND
  had a drop out time less than 10 years, the observation
  remains censored, but is censored at a smaller value.
;

data simulation_step4;
  set simulation_step3;
  dropout_time = entry_time + rand('exponential') / 0.06;
  if dropout_time < event_time then censor_code=0;
  event_time = min(event_time, dropout_time);
run;

proc print data=simulation_step4;
  var entry_time event_time censor_code group;
run;

*
  This is just one simulation. You should run at least a
  thousand simulations and you should re-run your simulation
  using a varying number of input parameters as a sensitivity
  analysis.
;

*
  Date calculations are tricky in SAS (or in any statistical
  package). SAS stores date values as the number of days since
  January 1, 1960.
;

data test_dates;
  baseline_date = input("01/01/1960", mmddyy10.);
  output;
run;

proc print data = test_dates;
  format baseline_date mmddyy10.;
run;

*
  If you print the date without a format statement,
  you see the underlying numeric representation.
;

proc print data = test_dates;
run;

ods pdf close;
