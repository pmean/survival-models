cd "C:\Users\Jeef\OneDrive\Survival Analysis\data files\Stata"

use whas100,clear

*log using "C:\Users\Jeef\OneDrive\Survival Analysis\logs\Module 2 lecture.smcl", replace

********************************************************************
*repeating the example in lecture 1

gen time_yrs=lenfol/365.25

*view first 10 observations
list id  admitdate foldate los lenfol fstat age gender bmi  time_yrs in 1/10



stset time_yrs, fail(fstat)

*sts list // see fails for all data
sts list, by(gender) // fails by gender

*table to see alive vs dead
tab fstat

*table to see alive vs dead by gender
tab2 gender fstat

*Kaplan-Meier curve
sts graph, xlabel(1(1)8) 

*including confidence interval
sts graph, xlabel(1(1)8) ci 


*Kaplan-Meier curve by gender
sts graph, by(gender) xlabel(1(1)8)

stci, by(gender)

*running different tests that Stata offers for Kaplan Meier
sts test gender,logrank
sts test gender,wilcoxon 
sts test gender,cox 
sts test gender,tware 
sts test gender,peto


****************************************************************************
*Cox proportional hazards model
stcox ib1.gender,base // produces the hazard rate, adding the option "base" reminds you who the base is

stcox gender,nohr  base // the nohr option (no hazard) gives you the coefficient
estat ic // information criterian, won't match exactly with othe software values, -2ll will match

*you have to calculate the -2ll manually by taking the ll(model) value and multiply by -2
di -2* -207.2423 // 414.4846

*post estimation command for covarianc
estat vce //covariance is the default

*post estimation command for variance
estat vce, cor 



*********************************************** graph below is used in presentation


* Estimating the baseline cumulative hazard  and survivor functions for all observations


stcox i.gender
predict SOm, basesurv //  baseline survivor function for base index, males
gen SOf=SOm^1.742761 // must exponentiate survivor function of males by hazard ratio of female

* look at the data set after running the above commands and you will see every observation
*has a predict level regardless of their gender

*graphing the survivor function
twoway (line SOm _t, sort lcolor(forest_green) connect(stairstep)) ///
		(line SOf _t, sort lcolor(red) connect(stairstep)), name(survivor,replace)

*shorter code to do the same thing
line SOm SOf _t, c(J J) sort title(short code) name(short,replace)

*another method for graphing results
stcurve, survival at1( gender=0) at2(gender=1) title(third method)



***the hazard curve

stcox i.gender
predict HOm, basechazard // calculates the baseline cumulative hazard function
gen HOf=HOm^1.742761 // must exponentiate cummulative hazard function of males by hazard ratio of female

line HOm HOf _t, c(J J) sort title(short code) name(hazard,replace)

stcurve, cumhaz  at1( gender=0) at2(gender=1) title(third method)



stcoxkm, by(gender)  // produces observed vs predicted

******************* rerunning the Kaplain_Meier curves and the longrank test for age groups

*using same code form lecture 1
*splitting age into categories
gen age_breaks=1 if age<60
replace age_breaks=2 if age>=60 & age<70
replace age_breaks=3 if age>=70 & age<80
replace age_breaks=4 if age>=80 & age!=.

label define ages 1 "<60" 2 "60-69" 3 "70-79" 4 ">=80"
label values age_breaks ages
codebook age_breaks
tab2 age_breaks fstat


*Kaplan Meier
stci, by(age_breaks)
*various options for test
sts test age_breaks,logrank 
sts test age_breaks,wilcoxon 
sts test age_breaks,cox 
sts test age_breaks,tware 
sts test age_breaks,peto

*run Cox proportional model
stcox i.age_breaks
stcox i.age_breaks, nohr
estat ic
di -2* -201.4585

estat vce, cor
estat vce




*graphing by age_breaks
sts graph, by(age_breaks)


*creating the predict value curve without using the predict command and generating predicted values based on hazared ratio
stcurve,survival   at( age_breaks=1) at1( age_breaks=2) at2(age_breaks=3)   at3( age_breaks=4) name(sur_age,replace)
stcurve,cumhaz   at( age_breaks=1) at1( age_breaks=2) at2(age_breaks=3)   at3( age_breaks=4) name(chaz_age,replace)


*viewing the fails by age_breaks
stcox i.age_breaks, base nohr 
sts list, by(age_breaks)

*Cox regression for age as continuous
stcox age
stcox age, nohr

*graphing at various ages
stcurve,survival   at( age=45) at1( age=65) at2(age=85)    name(sur_age,replace)
stcurve,cumhaz   at( age=45) at1( age=65) at2(age=85)    name(ch_age,replace)



log close

cd "C:\Users\Jeef\OneDrive\Survival Analysis\logs"

translate "Module 2 lecture.smcl" "Module 2 lecture.pdf"


*following command closes all open graphs
 window manage close graph  _all
 
 h window
