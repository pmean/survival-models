cd "C:\Users\Jeef\OneDrive\Survival Analysis\data files\Stata"

use whas500,clear
gen time_yrs=lenfol/365.25
*due to number of variables, viewing observations best in data editor
browse

*viewing variables' composition
codebook ,compact

stset time_yrs, fail(fstat)


*predictor age
stcox age, cformat(%6.3fc)
stcox age, cformat(%6.3fc) nohr
*retrieve the AIC/BIC and model's ll
estat ic

*predictor gender
stcox i.gender, cformat(%6.3fc) base
stcox i.gender, cformat(%6.3fc) nohr base
estat ic

*Kaplan-Meier graph by gender
sts graph , by(gender) xlabel(1(1)6) 


*predictor gender and age
stcox c.age i.gender, cformat(%6.3fc) base
stcox age i.gender, cformat(%6.3fc) nohr base
estat ic

*summarize age
sum age

*by gender
bys gender: sum age

*boxplot of age by gender
graph box age, over(gender)

*age difference is 8.1 years, hazard ratio for age is 1.069
di 1.069^8.1 //1.72

*graphing at same age for both genders
stcurve, survival at1( age=69.8 gender=0 ) at2( age=69.8 gender=1 )  name(same_age,replace)


*predictor bmi
stcox bmi, cformat(%6.3fc)
stcox bmi, cformat(%6.3fc) nohr

*predictor bmi
stcox bmi age i.gender, cformat(%6.3fc) base
stcox bmi age i.gender, cformat(%6.3fc) nohr base

*boxplot of bmi by gender
graph box bmi, over(gender)

*scatter plot
 scatter bmi age
 


*stata assumes predictors not include in the parenthesis are at their means, age =69.8
stcurve, survival at1( bmi=25 ) at2( bmi=35 ) at3( bmi=45 ) name(no_age,replace)

*creating the graph at age 95
stcurve, survival at1( bmi=25 age=95 ) at2( bmi=35 age=95) at3( bmi=45 age=95) 


*interaction age with gender
*if you are new to Stata, the following two lines of code will give you the same results
stcox c.age i.gender c.age#i.gender, cformat(%6.3fc) base
stcox c.age##i.gender, cformat(%6.3fc) base // I prefer this method because it is shorter

stcox c.age##i.gender, cformat(%6.3fc) nohr base


************ centering
*third party addon makes centering very easy
findit center  

*to easily find the command, in the page that pops up press ctrl f on your keyboard and then paste the following in the Find box
*center from http://fmwww.bc.edu/RePEc/bocode/c

center age,gen(age_c)

stcox c.age_c##ib1.gender, cformat(%6.3fc) base nolog
stcox c.age_c##ib1.gender, cformat(%6.5fc) nohr base nolog
*generate the predicted hazard ratios at different ages for females
margins,at(gender=1 age=(50(1)60)) 
marginsplot, noci


************************************************************

*create the Hazard ratio for women changes with age

*use the coefficient for female and age from this output and add it to the 2nd line of the loop
stcox c.age_c##i.gender, cformat(%6.5fc) base nolog nohr

gen age40=.
gen hr40=.
local i=1

forvalues x=40/90{
replace hr40=exp(0.20336 -0.03043*(`x'-69.846)) in `i'
replace age40=39+`i'  in `i'
local i=`i'+1
}

twoway (connected  hr40 age40 ,  msize(zero) sort ), title("Hazard ratio for women changes with age") yline(1)  xtitle("age")


*comparing model's, note that the AIC and BIC may not exactly match other softwares' estimations but they will be close
stcox i.gender, cformat(%6.3fc) base nolog nohr
estat ic

stcox c.age_c i.gender, cformat(%6.3fc) base nolog nohr
estat ic

stcox c.age_c i.gender bmi, cformat(%6.3fc) base nolog  nohr
estat ic





*************** Martingale residuals

stcox c.age i.gender bmi, cformat(%6.3fc) base nolog
predict mg,mgale

*graphing
twoway (scatter mg age if age>20 & age<110), xscale(r(20 110)) 

*including quadratic fit
twoway (scatter mg age if age>20 & age<110) (fpfit mg age, lcolor(red) lwidth(medium)), xscale(r(20 110)) 

*including quadratic fit with confidence interval
twoway (scatter mg age if age>20 & age<110) (fpfitci mg age, lcolor(red) lwidth(medium)), xscale(r(20 110)) 

*using local polynomial smoothed line 
twoway (scatter mg age if age>20 & age<110) (lpolyci mg age, lcolor(red) lwidth(medium) alwidth(none)), xscale(r(20 110))


*adding predictor sysbp to the model
stcox c.age i.gender bmi c.sysbp, cformat(%6.3fc) base nolog
predict mg_sysbp,mgale

*fitted polynomial with CI
twoway (scatter mg_sysbp sysbp ) (fpfitci mg sysbp, lcolor(red) lwidth(medium) alwidth(none))

*local polynomial smoothed line 
twoway (scatter mg_sysbp sysbp ) (lpolyci mg sysbp, lcolor(red) lwidth(medium) alwidth(none))


*add predictor for congestive heart complications
stcox c.age i.gender bmi c.sysbp i.chf, cformat(%6.3fc) base nolog
predict mg_schf,mgale

*boxplot the martingale residuals
graph box mg_schf, over(chf)


*creating restricted cubic splines
help mkspline

mkspline cubic_age  = age_c, cubic  nknots(6) displayknots

stcox cubic* bmi i.gender

sts graph,hazard

stcox cubic_age* bmi i.gender
predict cubic, hr

stcox age_c bmi i.gender
predict non_cubic, hr


sts graph

*smoothed hazard estimate
sts graph,hazard kernel(gaussian) 

