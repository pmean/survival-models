cd "C:\Users\Jeef\OneDrive\Survival Analysis\data files\Stata\"

use whas500,clear

*log using  "C:\Users\Jeef\OneDrive\Survival Analysis\logs\Module 1 exercises.smcl", replace

*check over the data set to look for any potential problems
codebook,compact



*1a. Produce a table of counts for fstat, to indicate which patients have died and which have been censored.

codebook fstat
tab fstat

*Declare data to be survival-time data, time variable = time_yrs, failure event = fstat
stset lenfol, fail(fstat)


*1b. Draw a Kaplan-Meier plot for overall survival.
sts graph, xlabel(1(1)7)

*1c. Estimate the 25th, 50th, and 75th quantiles for overall survival
stci, p(25)
stci, median
stci, p(75)


*2a. Produce a crosstabulation of fstat and gender. Are you comfortable with the number of deaths in each group?

tab2 gender fstat, chi


*2b. Draw Kaplan-Meier curves for males and females.
sts graph, by(gender) 

*2 c. Calculate median survival with confidence intervals for males and females.
stci, p(25) by(gender)
stci, median by(gender)
stci, p(75) by(gender)

*2d. Calculate the log rank test for males versus females.  Interpret your result.
sts test gender,logrank

*3a. Produce age groups <60, 60-69, 70-79, and >=80. 
gen age_breaks=1 if age<60
replace age_breaks=2 if age>=60 & age<70
replace age_breaks=3 if age>=70 & age<80
replace age_breaks=4 if age>=80 & age!=.

label define ages 1 "<60" 2 "60-69" 3 "70-79" 4 ">=80"
label values age_breaks ages
codebook age_breaks

*Compute a crosstabulation of this variable with fstat.  Are you comfortable with the number of deaths in each group?
tab2 age_breaks fstat, chi

*3b. Draw Kaplan Meier curves for each age group.
sts graph, by(age_breaks) 

*3c. Calculate the median survival time with confidence intervals for each age group.
stci, median by(age_breaks)

*3d. Calculate the log rank test for each group.  Interpret your result.
sts test age_breaks,logrank

clear
input id time fstat
1	1	0
2	1	0
3	1	0
4	1	0
5	1	0
6	1	0
7	1	0
8	1	0
9	1	1
10	1	1
11	2	0
12	2	0
13	2	1
14	2	1
15	3	0
16	3	1
17	4	0
18	4	1
19	5	0
20	5	0
21	5	0
22	5	0
23	5	0
24	5	1
25	5	1
26	5	1
27	6	1
28	6	1
29	7	1
30	10	1
31	10	1
32	12	1
33	12	1
34	13	1
end

stset time, fail(fstat)

sts list


*values used are from table
/*

           Beg.          Net            Survivor      Std.
  Time    Total   Fail   Lost           Function     Error     [95% Conf. Int.]
-------------------------------------------------------------------------------
     1       34      2      8             0.9412    0.0404     0.7847    0.9850
     2       24      2      2             0.8627    0.0647     0.6706    0.9469
     3       20      1      1             0.8196    0.0745     0.6145    0.9220
     4       18      1      1             0.7741    0.0831     0.5585    0.8935
     5       16      3      5             0.6289    0.1013     0.4001    0.7908
     6        8      2      0             0.4717    0.1227     0.2275    0.6829
     7        6      1      0             0.3931    0.1249     0.1622    0.6192
    10        5      2      0             0.2359    0.1142     0.0617    0.4728
    12        3      2      0             0.0786    0.0746     0.0051    0.2941
    13        1      1      0             0.0000         .          .         .
-------------------------------------------------------------------------------
*/

*@1 
di 0.9412 
di %6.4fc 1-(2/34)  //formats to 4 places

*@2
di %6.4fc 0.8627/0.9412
di %6.4fc 1-(2/24)

*@3
di %6.4fc 0.8196/0.8627 
di %6.4fc 1-(1/20)

*@4
di %6.4fc 0.7741/0.8196
di %6.4fc 1-(1/18) 

*@5
di %6.4fc 0.6289/0.7741 
di %6.4fc 1-(3/16) 

*@6
di %6.4fc 0.4717/0.6289
di %6.4fc 1-(2/8)  

*@7
di %6.4fc 0.3931/0.4717 
di %6.4fc 1-(1/6) 

*@10
di %6.4fc 0.2359/0.3931 
di %6.4fc 1-(2/5) 

*@12
di %6.4fc 0.0786/0.2359 
di %6.4fc 1-(2/3) 

*@13
di %6.4fc 0.0/0.0786 
di %6.4fc 1-(1/1) 

log close

cd "C:\Users\Jeef\OneDrive\Survival Analysis\logs"

translate "Module 1 lecture.smcl" "Module 1 exercises.pdf"   
