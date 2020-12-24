* Encoding: windows-1252.
cd 'C:\Users\Jeef\OneDrive\Survival Analysis\data files\SPSS'.

GET
  FILE='whas500.sav'.

*create a new variable for time in years.

COMPUTE time_yrs=lenfol / 365.25.
EXECUTE.

**************************************************Cox model with age as predictor.

COXREG time_yrs
  /STATUS=fstat(1)
  /METHOD=ENTER age 
  /PLOT SURVIVAL HAZARDS
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20).



***************************************************Cox model with gender as predictor.
COXREG time_yrs
  /STATUS=fstat(1)
  /PATTERN BY gender
  /CONTRAST (gender)=Indicator
  /METHOD=ENTER gender 
  /PLOT SURVIVAL HAZARD
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20).


***************************************************Cox model with gender and age as predictor.
COXREG time_yrs
  /STATUS=fstat(1)
  /PATTERN BY gender
  /CONTRAST (gender)=Indicator
  /METHOD=ENTER gender age
  /PLOT SURVIVAL HAZARD
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20).


**************************************************summary of age.
DESCRIPTIVES VARIABLES=age
  /STATISTICS=MEAN STDDEV MIN MAX.

***************************************************summary of age by gender.
*first split data into males and females.
SORT CASES  BY gender.
SPLIT FILE LAYERED BY gender.

*average age for females is 8 years older than males.
DESCRIPTIVES VARIABLES=age
  /STATISTICS=MEAN STDDEV MIN MAX.

***************************************************turn off the split file function.
SPLIT FILE OFF.

*************************************************** Box plot of age by gender.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=gender age MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: gender=col(source(s), name("gender"), unit.category())
  DATA: age=col(source(s), name("age"))
  DATA: id=col(source(s), name("$CASENUM"), unit.category())
  GUIDE: axis(dim(1), label("gender"))
  GUIDE: axis(dim(2), label("Age at Admission"))
  SCALE: cat(dim(1), include("0", "1"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: schema(position(bin.quantile.letter(gender*age)), label(id))
END GPL.


***************************************************graphing at mean age of 69.8.
COXREG time_yrs
  /STATUS=fstat(1)
  /PATTERN BY gender
  /CONTRAST (gender)=Indicator
  /METHOD=ENTER gender age
  /PATTERN age(69.8) 
  /PLOT SURVIVAL HAZARD
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20).


************************************************* bmi as predictor.

*Cox model with bmi as predictor.
COXREG time_yrs
  /STATUS=fstat(1)
  /METHOD=ENTER bmi 
  /PLOT SURVIVAL HAZARDS
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20).


*************************************************** Box plot of bmi by gender.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=gender bmi MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: gender=col(source(s), name("gender"), unit.category())
  DATA: bmi=col(source(s), name("bmi"))
  DATA: id=col(source(s), name("$CASENUM"), unit.category())
  GUIDE: axis(dim(1), label("gender"))
  GUIDE: axis(dim(2), label("BMI at Admission"))
  SCALE: cat(dim(1), include("0", "1"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: schema(position(bin.quantile.letter(gender*bmi)), label(id))
END GPL.

***************************************************Cox model with bmi, gender and age as predictor.
*including graph when bmi is 25 and age is 95.
COXREG time_yrs
  /STATUS=fstat(1)
  /PATTERN BY gender
  /CONTRAST (gender)=Indicator
  /METHOD=ENTER gender age bmi
  /PATTERN age(95) bmi(25)
  /PLOT SURVIVAL HAZARD
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20).


***************************************************model with interaction between age and gender.
COXREG time_yrs
  /STATUS=fstat(1)
  /PATTERN BY gender
  /CONTRAST (gender)=Indicator
  /METHOD=ENTER gender age  gender*age
  /PLOT SURVIVAL HAZARD
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20).


***************************************************centering age.
DESCRIPTIVES VARIABLES=age
  /STATISTICS=MEAN STDDEV MIN MAX.

COMPUTE age_centered=age - 69.85.
EXECUTE.


***************************************************model with interaction between age centered and gender.
COXREG time_yrs
  /STATUS=fstat(1)
  /PATTERN BY gender
  /CONTRAST (gender)=Indicator
  /METHOD=ENTER gender age_centered  gender*age_centered
  /PLOT SURVIVAL HAZARD
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20).



***************************************************model with bmi, age and gender, generating martingale residuals.
*Save the hazard ratio.
COXREG time_yrs
  /STATUS=fstat(1)
  /CONTRAST (gender)=Indicator
  /METHOD=ENTER bmi age gender 
  /SAVE=HAZARD(HAZ)
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20).

*run the following code to generate the martingale residual.
compute martingale=(fstat=1)-HAZ.
compute deviance=sqrt(-2*(martingale+(fstat=1)*ln((fstat=1)-martingale))).
if martingale<0 deviance=-deviance.
formats martingale deviance (F8.5).
execute.


*scatterplot of martingale by age..
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=age martingale MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: age=col(source(s), name("age"))
  DATA: martingale=col(source(s), name("martingale"))
  GUIDE: axis(dim(1), label("Age at Admission"))
  GUIDE: axis(dim(2), label("martingale"))
  ELEMENT: point(position(age*martingale))
END GPL.


***************************************************adding predictor sysbp , generating martingale residuals.
*Save the hazard ratio.
COXREG time_yrs
  /STATUS=fstat(1)
  /CONTRAST (gender)=Indicator
  /METHOD=ENTER bmi age gender sysbp
  /SAVE=HAZARD(HAZ2)
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20).

*run the following code to generate the martingale residual.
compute martingale2=(fstat=1)-HAZ2.
compute deviance2=sqrt(-2*(martingale2+(fstat=1)*ln((fstat=1)-martingale2))).
if martingale2<0 deviance2=-deviance2.
formats martingale2 deviance2 (F8.5).
execute.


* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=sysbp martingale2 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: sysbp=col(source(s), name("sysbp"))
  DATA: martingale2=col(source(s), name("martingale2"))
  GUIDE: axis(dim(1), label("Initial Systolic Blood Pressure"))
  GUIDE: axis(dim(2), label("martingale2"))
  ELEMENT: point(position(sysbp*martingale2))
END GPL.


***************************************************adding predictor for congestive heart complication chf , generating martingale residuals.
*Save the hazard ratio.
COXREG time_yrs
  /STATUS=fstat(1)
  /CONTRAST (gender)=Indicator
  /METHOD=ENTER bmi age gender sysbp chf
  /SAVE=HAZARD(HAZ3)
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20).

*run the following code to generate the martingale residual.
compute martingale3=(fstat=1)-HAZ3.
compute deviance3=sqrt(-2*(martingale3+(fstat=1)*ln((fstat=1)-martingale3))).
if martingale3<0 deviance3=-deviance3.
formats martingale3 deviance3 (F8.5).
execute.

* box plot of residuals by chf.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=chf martingale3 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: chf=col(source(s), name("chf"), unit.category())
  DATA: martingale3=col(source(s), name("martingale3"))
  DATA: id=col(source(s), name("$CASENUM"), unit.category())
  GUIDE: axis(dim(1), label("Congestive Heart Complications"))
  GUIDE: axis(dim(2), label("martingale3"))
  SCALE: cat(dim(1), include("0", "1"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: schema(position(bin.quantile.letter(chf*martingale3)), label(id))
END GPL.


****************SPSS doesn't have the capability within its menu's to create restricted cubic splines.  
*It is possible there is a macro to generate the splines but I could not find one.

