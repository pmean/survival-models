* input-data-sas-code.sas
  written by Steve Simon
  2020-12-28;

ods pdf
 file="input-data-sas-output.pdf";
 
libname survival
  ".";

** fly1 **;

filename fly1
  "fly1.txt";

title1 "Creating SAS binary file for fly1";

data survival.fly1;
  infile fly1 delimiter=' ';
  input
    day;
run;

proc print
    data=survival.fly1(obs=5);
run;

** fly2 **;

filename fly2
  "fly2.txt";

title1 "Creating SAS binary file for fly2";

data survival.fly2;
  infile fly2 delimiter=' ';
  input
    day
    cens
  ;
run;

proc print
    data=survival.fly2(obs=5);
run;

** fly3 **;

filename fly3
  "fly3.txt";

title1 "Creating SAS binary file for fly3";

data survival.fly3;
  infile fly3 delimiter=' ';
  input
    day
    cens
  ;
run;

proc print
    data=survival.fly3(obs=5);
run;

** rats **;

filename rats
  "rats.csv";

title1 "Creating SAS binary file for rats";

proc import 
  datafile=rats
        out=survival.rats
        dbms=csv
        replace;
     getnames=yes;
run;

proc print
    data=survival.rats(obs=5);
run;

ods pdf close;
