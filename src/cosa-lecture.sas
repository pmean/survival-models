* cosa-lecture.sas
  written by Steve Simon
  July 10, 2018;

** preliminaries **;

ods html body="cosa-lecture-sas.html";

ods graphics on
  / imagename="cosa-lecture-sas-"
    reset=index;

libname survival
  "c:/Users/simons/My Documents/survival-models/bin";

** fly1 **;

filename fly1
  "c:/Users/simons/My Documents/survival-models/data/fly1.txt";

data survival.fly1;
  infile fly1 delimiter=' ';
  input time;
  censor=1;
run;

proc lifetest
  plots=survival
  data=survival.fly1;
  time time*censor(0);
  title "Kaplan-Meier curve for fruit fly data";
run;

** fly2 **;

filename fly2
  "c:/Users/simons/My Documents/survival-models/data/fly2.txt";

data survival.fly2;
  infile fly2 delimiter=' ';
  input time censor;
run;

proc lifetest
  plots=survival
  data=survival.fly2;
  time time*censor(0);
  title "Kaplan-Meier curve for fruit fly data, first modification";
run;

** fly3 **;

filename fly3
  "c:/Users/simons/My Documents/survival-models/data/fly3.txt";

data survival.fly3;
  infile fly3 delimiter=' ';
  input time censor;
run;

proc lifetest
  plots=survival
  data=survival.fly3;
  time time*censor(0);
  title "Kaplan-Meier curve for fruit fly data, first modification";
run;

** leader **;

filename leader
  "c:/Users/simons/My Documents/survival-models/data/leader.txt";

data survival.leader;
  infile 
    leader
    delimiter=' '
    firstobs=2;
  input 
    years
    lost
    manner
    start
    military
    age
    conflict
    loginc
    growth
    pop
    land
    literacy
    region;
run;

proc lifetest
  plots=survival
  data=survival.leader;
  time years*lost(0);
  title "Kaplan-Meier curve for leader data";
run;

data const;
  set survival.leader;
  event=(lost=1);
  type=1;
run;

data nat;
  set survival.leader;
  event=(lost=2);
  type=2;
run;

data noncon;
  set survival.leader;
  event=(lost=3);
  type=3;
run;

data combine;
  set const nat noncon;
run;

proc lifetest 
    plots=survival
    data=combine;
	time years*event(0);
  strata type;
run;
