* input-data-sas-code.sas
  written by Steve Simon
  2020-12-28;

ods pdf
 file="input-data-sas-output.pdf";
 
libname survival
  ".";

** Import fly1.txt **;

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

proc contents
    varnum
    data=survival.fly1;
run;

** Import fly2.txt **;

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

proc contents
    varnum
    data=survival.fly2;
run;

** Import fly3.txt **;

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

proc contents
    varnum
    data=survival.fly3;
run;

** Import grace1000.dat **;

filename grace
  "grace1000.dat";

title1 "Creating SAS binary file for grace1000";

data survival.grace1000;
  infile grace delimiter=' ';
  input
    id
	days
	death
	revasc
	revascdays
	los
	age
	sysbp
	stchange
;
run;

proc print
    data=survival.grace1000(obs=5);
run;

proc contents
    varnum
    data=survival.grace1000;
run;

** Import heart.csv **;

filename heart
  "heart.csv";

title1 "Creating SAS binary file for heart";

proc import 
  datafile=heart
        out=survival.heart
        dbms=csv
        replace;
     getnames=yes;
run;

proc print
    data=survival.heart(obs=5);
run;

proc contents
    varnum
    data=survival.heart;
run;

** Import heroin.txt **;

filename heroin
  "heroin.txt";

title1 "Creating SAS binary file for heroin";

data survival.heroin;
  infile heroin delimiter='09'x firstobs=2;
  input
    id
	clinic
	status
	time
	prison
	dose @@
;
run;

proc print
    data=survival.heroin(obs=5);
run;

proc contents
    varnum
    data=survival.heroin;
run;

** Import leader.txt **;

filename leader
  "leader.txt";

title1 "Creating SAS binary file for leader";

proc import 
  datafile=leader
        out=survival.leader
        dbms=dlm
        replace;
     delimiter=" ";
     getnames=yes;
run;

proc print
    data=survival.leader(obs=5);
run;

proc contents
    varnum
    data=survival.leader;
run;

** Import psychiatric-patients.txt **;

filename psych
  "psychiatric-patients.txt";

title1 "Creating SAS binary file for psychiatric";

proc import 
  datafile=psych
        out=survival.psychiatric
        dbms=tab
        replace;
     getnames=yes;
run;

proc print
    data=survival.psychiatric(obs=5);
run;

proc contents
    varnum
    data=survival.psychiatric;
run;

** Import rats.csv **;

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

proc contents
    varnum
    data=survival.rats;
run;

** Import transplant.txt **;

filename trans
  "transplant.txt";

title1 "Creating SAS binary file for transplant";

proc import 
  datafile=trans
        out=survival.transplant
        dbms=tab
        replace;
     getnames=yes;
run;

proc print
    data=survival.transplant(obs=5);
run;

proc contents
    varnum
    data=survival.transplant;
run;

** Import transplant1.csv **;

filename trans1
  "transplant1.csv";

title1 "Creating SAS binary file for transplant1";

proc import 
  datafile=trans1
        out=survival.transplant1
        dbms=csv
        replace;
     getnames=yes;
run;

proc print
    data=survival.transplant1(obs=5);
run;

proc contents
    varnum
    data=survival.transplant1;
run;

** Import transplant2.csv **;

filename trans2
  "transplant2.csv";

title1 "Creating SAS binary file for transplant2";

proc import 
  datafile=trans2
        out=survival.transplant2
        dbms=csv
        replace;
     getnames=yes;
run;

proc print
    data=survival.transplant2(obs=5);
run;

proc contents
    varnum
    data=survival.transplant2;
run;

** Import whas100.dat **;

filename whas100
  "whas100.dat";

title1 "Creating SAS binary file for whas100";

data survival.whas100;
  infile whas100 delimiter=' ';
  input
    id
	admit $
	foldate $
	los
	lenfol
	fstat
	age
	gender
	bmi
  ;
  admitdate = input(admit, mmddyy10.); 
run;

proc print
    data=survival.whas100(obs=5);
run;

proc contents
    varnum
    data=survival.whas100;
run;

** Import whas500.dat **;

filename whas500
  "whas500.dat";

title1 "Creating SAS binary file for whas500";

data survival.whas500;
  infile whas500 delimiter=' ';
  input
    id
	age
	gender
	hr
	sysbp
	diasbp
	bmi
	cvd
	afb
	sho
	chf
	av3
	miord
	mitype
	year
	admitdate $
	disdate $
	fdate $
	lis
	dstat
	lenfol
	fstat
  ;
run;

proc print
    data=survival.whas500(obs=5);
run;

proc contents
    varnum
    data=survival.whas500;
run;

ods pdf close;
