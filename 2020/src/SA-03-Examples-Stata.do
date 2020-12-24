cd "C:\Users\Jeef\OneDrive\Survival Analysis\Mod3\syntax"


/*
alpha = .05 =Z of 0.025 =1.96
power = 80% = Z of .20 = .84

*/

*minimum clinically important difference: consider a doubling of the hazard rate as the minimum clinically importatnt difference then theta =ln(2)
di ln(2) //.693

/*degree of inbalance between the two groups: you expect to see half as many deaths in the treatment group compared to the control group, 
1/3 of deaths in treatment group and 2/3 in control: .33  */ 

*using formula, the number of deaths requiered

di (1.96+.84)^2/(.693^2 * .33 *(1-.33)) //73.834757

*round up to 75, 25 deaths in treatment group and 50 in control group

/* Assumptions
- you follow the average patient for 3 years
- you will have a 20% early dropout rate
- deaths follow an exponential distribution
- baseline hazard rate is 0.4 (treatment group)


*calculate the number of people still alive
S(t)= e -lambda *t where lambda equals harzard rate 3 *.4=1.2, 3*.8=2.4
*/

di exp(-1.2) // .30119421, the percentage of people surviving past 3 year = 30%
di exp(-2.4) // .09071795

*divide number of deaths by 1 - probability of survival and 1- the probability of early dropout
di 25/(.8*.7)  //44.642857
di 50/(.8*.91) //68.681319



findit artsurv
artsurv, method(l) edf0(.36) hratio(.8,.4) onesided(0) tunit(1) lg(1 2) ldf(0.2;.2)  aratios(2 1) nperiod(3)


*there is a drop down menu for this package
artmenu on // after running this command go to "user" and then "ART" on the main Stata screen.



*generating synthetic graphs
clear
set obs 101
egen x=fill(0(.03)3) // creating sequence of numbers
gen s1=exp(-.4*x) // hazard rate of .4
gen s2=exp(-.4*2*x) //hazard rate of .8

line s1 s2 x, xline(.87 1.7) yline(.5, lwidth(vthin) lpattern(dash) extend) ylabel(, angle(horizontal)) ///
xlabel(0(.2)3, angle(forty_five)) title("Ten extra months for median survival time") subtitle("Hazard ratio of 2.0") name(longerlife,replace)

line s1 s2 x, xline(2) yline(.45 .20, lwidth(vthin) lpattern(dash) extend) ylabel(, angle(horizontal)) ///
title("25% greater chance of surviving to two years") subtitle("Hazard ratio of 2.0") name(survivingtime,replace)




*Generating random start times
clear
set obs 22
set seed 456
gen exp = -ln(uniform())
gen time= exp/(0.02*365)

gen start_time=sum(time)
sort start_time
gen patient=_n

twoway (scatter patient start_time ), ytitle(Patient) xtitle("Start Time") ylabel(, angle(horizontal))

*Generating random deaths
*generate two random groups
gen rannum=uniform()
egen grp2=cut(rannum),group(2)
browse

*group 0 will have hazard ratio of .05 and group 1 hazard ratio of .10
gen death=exp/.05 if grp2==0
replace death=exp/.1 if grp2==1

gen death_time=death+start_time if grp2==0
replace death_time=death+start_time if grp2==1



twoway rspike start_time death_time  patient,horizontal

twoway (rspike start_time death_time patient if grp2==0, horizontal lcolor(dkgreen) lwidth(thick)) ///
(rspike start_time death_time patient if grp2==1, horizontal lcolor(dkblue) lwidth(thick)) , ///
xtitle("time to death") legend(label(1 "treatment") label(2 "control"))  ylabel(, angle(horizontal)) 



*truncate the data
gen death_time2=death_time
replace death_time2=10 if death_time>=10


twoway (rspike start_time death_time2 patient if grp2==0, horizontal lcolor(dkgreen) lwidth(thick)) ///
(rspike start_time death_time2 patient if grp2==1, horizontal lcolor(dkblue) lwidth(thick)) , ///
xtitle("time to death") legend(label(1 "treatment") label(2 "control"))  ylabel(, angle(horizontal)) ///
xscale(range(0 10)) xlabel(0(2)10) xscale() title("Truncated at 10 years")




******************************* Dates and formatting

cd "C:\Users\Jeef\OneDrive\Survival Analysis\data files\Stata"

use whas500,clear
keep admitdate disdate fdate


gen los=disdate-admitdate



browse

*look at different formats
format admitdate %d  // the default format for the todate command
format admitdate %tg  //number of days since Jan 1, 1960, which is day 0 in Stata
format admitdate %dM_d,_CY // typical format
format admitdate %dm_d,_CY // abbreviated month
format admitdate %dm_d,_Y // abbreviated month and year

*you can get some very strange results with some data, I recommend downloading the command todate for situations where the dates are formatted poorly

findit todate

*here is a link to a very helpful article on working with dates, at the bottom of the article is a very helpful do file

*https://www.ssc.wisc.edu/sscc/pubs/stata_dates.htm
