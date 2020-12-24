* Encoding: windows-1252.
cd 'C:\Users\Jeef\OneDrive\Survival Analysis\data files\SPSS'.

GET
  FILE='heroin.sav'.

*create a new variable for time in years.

COMPUTE time_yrs=time / 365.25.
EXECUTE.


**************************************************Cox model with clinc as predictor.

COXREG time_yrs
  /STATUS=status(1)
  /PATTERN BY clinic
  /CONTRAST (clinic)=Indicator
  /METHOD=ENTER clinic 
  /PLOT SURVIVAL
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20).


**************************************************Cox model with prison as predictor.

COXREG time_yrs
  /STATUS=status(1)
  /PATTERN BY prison
  /CONTRAST (prison)=Indicator
  /METHOD=ENTER prison 
  /PLOT SURVIVAL
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20).

**************************************************Cox model with dose of methadone as predictor.
*create categorical variable.
RECODE dose (SYSMIS=SYSMIS) (Lowest thru 40=1) (41 thru 50=2) (51 thru 60=3) (61 thru 70=4) (71 thru 
    Highest=5)  INTO dose_group.
VARIABLE LABELS  dose_group 'dose_5_categories'.
VALUE LABELS dose_group
  1 '20-40'
  2 '45-50'
  3 '55-60'
  4 '65-70'
  5 '75-110'.
EXECUTE.


COXREG time_yrs
  /STATUS=status(1)
  /PATTERN BY dose_group
  /CONTRAST (dose_group)=Indicator
  /METHOD=ENTER dose_group 
  /PLOT SURVIVAL
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20).

****************************************************** Complementary log-log cannot be run in SPSS.


***************************************************************** Schoenfeld residuals, clinics


COXREG time_yrs
  /STATUS=status(1)
  /CONTRAST (clinic)=Indicator
  /METHOD=ENTER clinic 
  /SAVE=PRESID
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20).





* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=time_yrs PR1_1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: time_yrs=col(source(s), name("time_yrs"))
  DATA: PR1_1=col(source(s), name("PR1_1"))
  GUIDE: axis(dim(1), label("time_yrs"))
  GUIDE: axis(dim(2), label("Partial residual for clinic 1 or 2"))
  ELEMENT: point(position(time_yrs*PR1_1))
END GPL.


***************************************************************** Schoenfeld residuals, prison
COXREG time_yrs
  /STATUS=status(1)
  /CONTRAST (prison)=Indicator
  /METHOD=ENTER prison 
  /SAVE=PRESID(pris_resid)
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20).


* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=time_yrs pris_resid1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: time_yrs=col(source(s), name("time_yrs"))
  DATA: pris_resid1=col(source(s), name("pris_resid1"))
  GUIDE: axis(dim(1), label("time_yrs"))
  GUIDE: axis(dim(2), label("Partial residual for prison no or yes"))
  ELEMENT: point(position(time_yrs*pris_resid1))
END GPL.


***************************************************************** Schoenfeld residuals, dose_group.
COXREG time_yrs
  /STATUS=status(1)
  /PATTERN BY dose_group
  /CONTRAST (dose_group)=Indicator
  /METHOD=ENTER dose_group 
  /PLOT SURVIVAL
  /SAVE=PRESID(dose)
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20).


* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=time_yrs dose1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: time_yrs=col(source(s), name("time_yrs"))
  DATA: dose1=col(source(s), name("dose1"))
  GUIDE: axis(dim(1), label("time_yrs"))
  GUIDE: axis(dim(2), label("Partial residual for prison no or yes"))
  ELEMENT: point(position(time_yrs*dose1))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=time_yrs dose2 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: time_yrs=col(source(s), name("time_yrs"))
  DATA: dose2=col(source(s), name("dose2"))
  GUIDE: axis(dim(1), label("time_yrs"))
  GUIDE: axis(dim(2), label("Partial residual for prison no or yes"))
  ELEMENT: point(position(time_yrs*dose2))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=time_yrs dose3 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: time_yrs=col(source(s), name("time_yrs"))
  DATA: dose3=col(source(s), name("dose3"))
  GUIDE: axis(dim(1), label("time_yrs"))
  GUIDE: axis(dim(2), label("Partial residual for prison no or yes"))
  ELEMENT: point(position(time_yrs*dose3))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=time_yrs dose4 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: time_yrs=col(source(s), name("time_yrs"))
  DATA: dose4=col(source(s), name("dose4"))
  GUIDE: axis(dim(1), label("time_yrs"))
  GUIDE: axis(dim(2), label("Partial residual for prison no or yes"))
  ELEMENT: point(position(time_yrs*dose4))
END GPL.


***************************************************************** strata.by clinic.
 

COXREG time_yrs
  /STATUS=status(1)
  /STRATA=clinic
  /PATTERN BY prison
  /CONTRAST (prison)=Indicator
  /METHOD=ENTER prison dose 
  /PLOT SURVIVAL HAZARDS
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20).




cd 'C:\Users\Jeef\OneDrive\Survival Analysis\data files\SPSS'.

GET
  FILE='transplant.sav'.

IF  (transplant=0) waittime=10000.
EXECUTE.



*The coefficient for "transplant" is 1.0125 when running the model in R and Stata.
TIME PROGRAM.
COMPUTE T_COV_ = T_>waittime.
COXREG   futime
  /STATUS=fustat(1)
  /METHOD=ENTER T_COV_ 
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20).


*Adding the covariates for age and surgery reduces the coefficient for transplant to 0.925, which still does not match R and Stata.
TIME PROGRAM.
COMPUTE T_COV_ = T_>waittime.
COXREG   futime
  /STATUS=fustat(1)
  /METHOD=ENTER T_COV_ surgery age 
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20).


*designating "surgery" as categorical does not correct the coefficients to the same as R and Stata.
TIME PROGRAM.
COMPUTE T_COV_ = T_>waittime.
COXREG   futime
  /STATUS=fustat(1)
  /CONTRAST (surgery)=Indicator
  /METHOD=ENTER T_COV_ surgery age 
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20).





