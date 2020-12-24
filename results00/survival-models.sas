* survival-lecture-1.sas
  written by Steve Simon
  March 24, 2018;

libname survival
  "c:/Users/simons/My Documents/survival-models/bin";
filename fly1
  "c:/Users/simons/My Documents/survival-models/data/fly1.txt";
* The  fly1 data set is intended to illustrate how easy it would    
  be for you to estimate a survival curve if you had no censoring. ;
data survival.fly1;
  infile fly1;
  input time;
  censor=1;
run;
* To get the program to work properly, you need a variable that    
  equals one for every observation, since every observation        
  represents a time at death rather than a censoring time.         ;
proc print data=survival.fly1;
  title "Fruit fly survival data, no censoring";
run;
proc lifetest
  plots=survival(atrisk)
  data=survival.fly1;
  time time*censor(0);
run;
filename fly2
  "c:/Users/simons/My Documents/survival-models/data/fly2.txt";
* The fly2 data set illustrates what happens to the data if a      
  scientist accidentally let all the flies still alive at day 70   
  escape.                                                          ; 
data survival.fly2;
  infile fly2 delimiter=" ";
  input time censor;
run;
proc print data=survival.fly2;
  title "Fruit fly survival data, censoring all values > 70";
run;
proc lifetest
  plots=survival(atrisk)
  data=survival.fly2;
  time time*censor(0);
run;
filename fly3
  "c:/Users/simons/My Documents/survival-models/data/fly3.txt";
* The fly3 data set illustrates what happens to the data if a      
  scientist accidentally let some (but not all) of the flies       
  escape at day 70.                                                ; 
data survival.fly3;
  infile fly3 delimiter=" ";
  input time censor;
run;
proc print data=survival.fly3;
  title "Fruit fly survival data, censoring some values > 70";
run;
proc lifetest
  plots=survival(atrisk)
  data=survival.fly3;
  time time*censor(0);
run;
filename table21
  "c:/Users/simons/My Documents/survival-models/data/table21.txt";
run;
* Table 2.1 of Hosmer, Lemeshow, and May has a very small data     
  set that you can use to calculate the Kaplan-Meier curve by      
  hand. This code shows how SAS software would generate the graph, 
  just so you can double check your work.                          ;
proc import
    datafile=table21
    dbms=dlm
  out=survival.table21 replace;
  delimiter=',';
  getnames=yes;
run;
proc print
    data=survival.table21;
  title "Printout of table21";
run;
* note: you need to ods graphics to see the Kaplan-Meier curve    ;
ods graphics on;
* the (attisk) tells SAS to place the number of patients at risk
  at each tick mark in the graph. For this example, it is trivial, 
  but for larger data sets, it can help you tell when the data
  is getting thin.                                                ;
proc lifetest
  plots=survival(atrisk)
  data=survival.table21;
  time time*censor(0);
run;
filename whas100
  "c:/Users/simons/My Documents/survival-models/data/wiley/whas100.dat";
* This is a rather trivial example. Let’s look at a larger data 
  set. Read the data-dictionary-whas100.txt file in the doc 
  subdirectory for information about this data set.

  Out of respect for the book’s copyright, I am not reproducing
  the whas100.txt file in the git repository. See README.md in
  the main folder or the data dictionary file mentioned above
  for details about how to download this file.                    ;

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
  plots=survival(atrisk)
  data=survival.whas100;
  time time_yrs*fstat(0);
run;
