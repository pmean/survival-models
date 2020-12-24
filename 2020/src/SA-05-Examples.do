cd "C:\Users\Jeef\OneDrive\Survival Analysis\data files\Stata"

use whas100,clear

gen time_yrs=lenfol/365.25


*generating synthetic graphs

set obs 301
egen x=fill(0(.01)3) // creating sequence of numbers
gen st=exp(-x) // survival curve
browse

line st x,  ylabel(, angle(horizontal)) ///
xlabel(0(.5)3, angle(forty_five)) title("Survival curve for the “standard” exponential")

*add scale parameter of 2

gen scale2=exp(-x/2) // survival curve for θ=2

line st scale2  x,  ylabel(, angle(horizontal)) ///
xlabel(0(.5)3, angle(forty_five)) title("Survival curve for θ=2")

gen scale_pt5=exp(-x/.5) // survival curve for θ=5

line st scale_pt5  x,  ylabel(, angle(horizontal)) ///
xlabel(0(.5)3, angle(forty_five)) title("Survival curve for θ=0.5")



 



stset time_yrs, fail(fstat)

*exponential distribution with no covariates
streg , dist(exp) nolog nohr 
predict exp_sur,s // predict  S(t|t_0)


sts graph, addplot((line exp_sur _t, c(l) sort))  ///
title("Survival curves (no covariates)") legend(off)





set obs 1001
egen y=fill(0(.01)10) // creating sequence of numbers

*cummulative hazard function

sts graph,cumhaz 


gen cumhazard=1-exp(-y/6) // survival curve


sts graph,cumhaz addplot((line cumhazard y)) xlabel(0(2.5)10) ///
title("Survival curves (no covariates)") legend(off)



****************** exponential model with covariates
*center bmi and age
center bmi age, pre(ctr_)

streg  i.gender##c.ctr_age ctr_bmi, dist(exp) nohr time cformat(%6.4fc) base 




*The Weibull distribution

gen weib1=exp(-x) // Weibull distribution =1

gen weib2=exp(-x^2) // Weibull distribution =2

line weib1 weib2 y if y<=3,  ylabel(, angle(horizontal)) ///
xlabel(0(.5)3, angle(forty_five)) title("The Weibull distribution (k=2)")


gen weib5=exp(-x^.5) // survival curve

line weib1 weib5  y if y<=3,  ylabel(, angle(horizontal)) ///
xlabel(0(.5)3, angle(forty_five)) title("The Weibull distribution (k=.5)")


*adding parameter

gen weib22=exp(-(x/2)^2) // survival curve

line weib2 weib22  y if y<=3,  ylabel(, angle(horizontal)) ///
xlabel(0(.5)3, angle(forty_five)) title("The Weibull distribution (θ=2)")


*null model 
streg , dist(weibull) nohr time cformat(%6.4fc) base

*plotting curves, predict  S(t|t_0)
streg , dist(weibull) nohr time cformat(%6.4fc) base 
predict w_sur,s

streg , dist(exp) nohr time cformat(%6.4fc) base 


sts graph, addplot((line w_sur exp_sur  _t, c(l) sort)) ///
title("Survival curves (no covariates)")  legend(off)
 

* Weibull model
streg  i.gender##c.ctr_age ctr_bmi, dist(weibull) nohr time cformat(%6.4fc) base 
