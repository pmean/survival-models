cd "C:\Users\Jeef\OneDrive\Survival Analysis\data files\Stata"

use whas100,clear

*log using "C:\Users\Jeef\OneDrive\Survival Analysis\logs\Module 1 lecture.smcl", replace

*glance of the data set
list in 1/10

codebook, compact


*create new variable for time in years
gen time_yrs=lenfol/365.25

*Declare data to be survival-time data, time variable = time_yrs, failure event = fstat
stset time_yrs, fail(fstat)

*graph
sts graph, xlabel(1(1)8)


*estimate quartiles, SE and 95% CI, estimate matches Hosmer-Lemeshow table 2.5 but not the SE
stci, p(25)
stci, median
stci, p(75)

*you can also generate quantiles using the "xtile" command, then run stci by the variable that you created for quantiles
xtile quantile=time_yrs
stci, by(quantile)

*adding confidence interval
sts graph, ci

*graphing the 1st quantile
sts graph if quantile==1, ci

*graphing the 2nd quantile
sts graph if quantile==2, ci


*stci by gender
stci, by(gender)

*graph by gender
sts graph, by(gender)


*logrank test
sts test gender,logrank

*splitting age into categories
gen age_breaks=1 if age<60
replace age_breaks=2 if age>=60 & age<70
replace age_breaks=3 if age>=70 & age<80
replace age_breaks=4 if age>=80 & age!=.

label define ages 1 "<60" 2 "60-69" 3 "70-79" 4 ">=80"
label values age_breaks ages
codebook age_breaks

stci, by(age_breaks)
sts test age_breaks,logrank

*test for trend
sts test age_breaks,trend

log close

cd "C:\Users\Jeef\OneDrive\Survival Analysis\logs"

translate "Module 1 lecture.smcl" "Module 1 lecture.pdf"
