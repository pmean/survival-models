cd "C:\Users\Jeef\OneDrive\Survival Analysis\data files\Stata"

use heroin,clear
gen time_years=time/365.25

stset time_years, fail(status)

*graph survival estimates by clinic
sts graph, by(clinic)  ylabel(, angle(horizontal))


*graph survival estimates by prison record
sts graph, by(prison)  ylabel(, angle(horizontal))


*graph survival estimates by dose group
gen dose_group=.
replace dose_group= 1 if dose<41
replace dose_group= 2 if dose > 40 & dose<51
replace dose_group= 3 if dose > 50 & dose<61
replace dose_group= 4 if dose > 60 & dose<71
replace dose_group= 5 if dose > 70 & dose<111
label define dg 1 "20 to 40" 2 "45 to 50" 3  "55 to 60" 4  "65 to 70" 5 "75 to 110"
label values dose_group dg
codebook dose_group

sts graph, by(dose_group)  ylabel(, angle(horizontal))


**************************** log logistic model using streg

*log logistic model clinic
streg clinic, noconstant dist(loglogistic)

*graph: note the y-axis scaling is different from Steve's
sts graph , failure by(clinic)   ylabel(, angle(horizontal)) title ("log logistic model") subtitle("by clinic") 


*log logistic model
streg prison, noconstant dist(loglogistic)

*graph: note the y-axis scaling is different from Stephen's
sts graph, failure by(prison)   ylabel(, angle(horizontal)) title ("log logistic model")  subtitle("by prison")

*log logistic model
streg dose_group, noconstant dist(loglogistic)

*graph: note the y-axis scaling is different from Stephen's
sts graph, failure by(dose_group)   ylabel(, angle(horizontal)) title ("log logistic model")  subtitle("by dose group")


******************************************** Schoenfeld residuals *********************************

*Schoenfeld residuals clinic, use the option scaledsch to generate the residuals
stcox i.clinic, scaledsch(sca*) base // a predicted value will be created for each category within a categorical variable

twoway (scatter sca1 time_years) (fpfitci sca1 time_years, fcolor(none) blwidth(medium) blpattern(longdash)), ///
ylabel(-4(2)4) ylabel(, angle(horizontal)) title("Schoenfeld residuals:clinic") name(scatter1,replace)

twoway (scatter sca2 time_years) (fpfitci sca2 time_years, fcolor(none) blwidth(medium) blpattern(longdash)), ///
ylabel(-4(2)4) ylabel(, angle(horizontal)) title("Schoenfeld residuals:clinic") name(scatter2,replace)

*this is an old method no longer supported by Stata, cannot use "i." in front of categorical variable
stcox clinic
stphtest,plot(clinic) msym(oh) name(stphtest1,replace)

drop sca*
*Schoenfeld residuals clinic
stcox prison,scaledsch(sca3)

twoway (scatter sca3 time_years) (fpfitci sca3 time_years, fcolor(none) blpattern(solid)), ///
ylabel(-4(2)4) ylabel(, angle(horizontal)) title("Schoenfeld residuals:prison")  name(scatter2,replace)

stphtest,plot(prison) msym(oh) name(stphtest2,replace)

drop sca*
*Schoenfeld residuals dose_group
stcox i.dose_group,scaledsch(sca*)

twoway (scatter sca2 time_years) (fpfitci sca2 time_years, fcolor(none) blpattern(solid)), ///
ylabel(-6(2)6) ylabel(, angle(horizontal)) title("Schoenfeld residuals:group 2")  name(scatter2,replace)

twoway (scatter sca3 time_years) (fpfitci sca3 time_years, fcolor(none) blpattern(solid)), ///
ylabel(-6(2)6) ylabel(, angle(horizontal)) title("Schoenfeld residuals:group 3")  name(scatter3,replace)

twoway (scatter sca4 time_years) (fpfitci sca4 time_years, fcolor(none) blpattern(solid)), ///
ylabel(-6(2)6) ylabel(, angle(horizontal)) title("Schoenfeld residuals:group 4")  name(scatter4,replace)

twoway (scatter sca5 time_years) (fpfitci sca5 time_years, fcolor(none) blpattern(solid)), ///
ylabel(-8(2)8) ylabel(, angle(horizontal)) title("Schoenfeld residuals:group 4")  name(scatter5,replace)

stcox dose_group
stphtest,plot(dose_group) msym(oh) name(stphtest3,replace)



* to test for proportional hazard assumption the following method can be used. Graph should generate parallel lines for proportional 
*hazard assumption to hold true.
stcox clinic prison dose_group
estat phtest
stphplot, by(clinic)
stphplot, by(prison)
stphplot, by(dose_group)


**************************************** strata for clinic, using prison and "dose" as predictor
stcox  prison dose,strata(clinic)

sts graph if clinic==1, by(prison) 
sts graph if clinic==2, by(prison) 



**************************************** time varying models: Stanford transplant data

use transplant,clear

*check out follow up time frequencies
fre futime

*must change a "zero" period of time to some fraction period of time
replace futime=.1 if futime==0

stset futime, fail(fustat)

center age,pre(ctr_)

*note that the model results does not exactly match up with R. There are four options
*to deal with "ties" Breslow (the default)  efron, exactm, and exactp
stcox transplant ctr_age surgery

*changing the option for ties to "exactm" gives you similar results as R as shown in the handout.
stcox transplant ctr_age surgery,exactm cformat(%6.4fc)

stset,clear // using this command is not necessary. If you use a new stset command it will replace what is in memory

*the variables of interest
browse id futime fustat transplant ctr_age surgery waittime


*people that did not have a transplant have a wait time of "missing", must change that to zero
replace waittime=0 if waittime==.

gen tstart0=0
gen tstop0=waittime
gen tstart1=waittime
gen tstop1=futime

browse id  fustat  ctr_age surgery  transplant   tstart0 tstop0 waittime tstart1 tstop1 futime
 
reshape long tstart tstop, i(id) j(period)

drop if tstart==tstop & tstop==0

*people who received a transplant did not have the transplant during period 0, the initial wait time
replace transplant=0 if period==0

*one could not die period 0 if tstop is less than follow up time
replace fustat=0 if tstop<=futime & period==0

*period 1 for observation 28 was excluded because tstart equals stop
*add small increment to tstop, same concept as on line 103 above
replace tstop=tstop+.01 if tstart==tstop



*************** specifying stset

stset tstop, fail(fustat) // this would be the wrong set up
/* Using this code, there is no mention of when one enters
*/

stset tstop, fail(fustat) enter(tstart) // this code states when one enters
stcox transplant ctr_age surgery ,exactm  cformat(%6.4fc)

stset tstop, fail(fustat) enter(tstart) exit(tstop) // same results as the code above
stcox transplant ctr_age surgery ,exactm  cformat(%6.4fc)

stset tstop, fail(fustat) time0(tstart) exit(tstop) // same results as the other two
stcox transplant ctr_age surgery ,exactm  cformat(%6.4fc)

 


