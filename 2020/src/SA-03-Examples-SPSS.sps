* Encoding: windows-1252.
cd 'C:\Users\Jeef\OneDrive\Survival Analysis\data files\SPSS'.

GET
  FILE='whas100.sav'.

*The first part of the lecture was done in R. R and Stata have a simple method for using the software
*as a calculator.  In R you write a bit of code and it performs the calculation.  In Stata all  you have to do
*is type in the command "display" and then the equation.  In SPSS it is a bit more involved but can be done
*taking the following approach.

*1.068**10

*minimum clinically important difference: consider a doubling of the hazard rate as the minimum clinically importatnt difference then theta =ln(2)

* Encoding: windows-1252.
DO IF $casenum = 1.
compute #temp = LN(2).
PRINT /#temp.
END IF.
exe.

*degree of inbalance between the two groups: you expect to see half as many deaths in the treatment group compared to the control group, 
*1/3 of deaths in treatment group and 2/3 in control: .33  

*using formula, the number of deaths requiered
*Note: a double star ** is used instead of a carrot top ^ for exponentiating.

DO IF $casenum = 1.
compute #temp = (1.96+.84)**2/(.693**2 * .33 *(1-.33)).
PRINT /#temp.
END IF.
exe.

* Assumptions
* you follow the average patient for 3 years
*you will have a 20% early dropout rate
*deaths follow an exponential distribution
*baseline hazard rate is 0.4 (treatment group)


*calculate the number of people still alive
*S(t)= e -lambda *t where lambda equals harzard rate 3 *.4=1.2, 3*.8=2.4

DO IF $casenum = 1.
compute #temp = EXP(-1.2).
PRINT /#temp.
END IF.
exe.


DO IF $casenum = 1.
compute #temp = EXP(-2.4).
PRINT /#temp.
END IF.
exe.


*divide number of deaths by 1 - probability of survival and 1- the probability of early dropout

DO IF $casenum = 1.
compute #temp = 25/(.8*.7).
PRINT /#temp.
END IF.
exe.


DO IF $casenum = 1.
compute #temp =50/(.8*.91).
PRINT /#temp.
END IF.
exe.


**************************************** Dates and Times *************************************
*You will find that dates in a data set can come in all kinds of formats. Sometimes it will be easier to format them in Excel and then bring them
*into SPSS.  Other times it is much easier to format within SPSS. Here is a link to understanding and formating links in SPSS.

*https://www.ibm.com/support/knowledgecenter/en/SSLVMB_24.0.0/spss/base/idh_idd_dtwz_learn.html


*Formatting the variable admitdate:
formats exit_moment(f1).


* Date and Time Wizard: year of admit.
COMPUTE years=XDATE.YEAR(admitdate).
VARIABLE LABELS years.
VARIABLE LEVEL years(SCALE).
FORMATS years(F8.0).
VARIABLE WIDTH years(8).
EXECUTE.

* Date and Time Wizard: half_year from admit date.
COMPUTE half_year=DATESUM(admitdate, 180, "days", 'closest').
VARIABLE LABELS half_year.
VARIABLE LEVEL half_year(SCALE).
FORMATS half_year(DATE12).
VARIABLE WIDTH half_year(12).
EXECUTE.

* Date and Time Wizard: days from admit to follow up..
COMPUTE  days_admit_to_fol=DATEDIF(foldate, admitdate, "days").
VARIABLE LABELS  days_admit_to_fol "days to follow up".
VARIABLE LEVEL  days_admit_to_fol (SCALE).
FORMATS  days_admit_to_fol (F5.0).
VARIABLE WIDTH  days_admit_to_fol(5).
EXECUTE.

* Date and Time Wizard: weeks from admit to follow up.
COMPUTE  days=DATEDIF(foldate, admitdate, "weeks").
VARIABLE LABELS  days.
VARIABLE LEVEL  days (SCALE).
FORMATS  days (F5.0).
VARIABLE WIDTH  days(5).
EXECUTE.


