* survival-lecture-1.sas;
* written by Steve Simon;
* March 24, 2018;

libname survival
  "c:/Users/simons/My Documents/survival-models/data";
filename table21
  "c:/Users/simons/My Documents/survival-models/data/table21.txt";
run;
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
* note: you need to ods graphics to see the Kaplan-Meier curve;
ods graphics on;
* the (attisk) tells SAS to place the number of patients at risk;
* at each tick mark in the graph. For this example, it is trivial,;
* but for larger data sets, it can help you tell when the data;
* is getting thin.;
proc lifetest
  plots=survival(atrisk)
  data=survival.table21;
  time Time*Censor(0);
run;
