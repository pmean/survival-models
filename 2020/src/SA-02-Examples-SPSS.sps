* Encoding: windows-1252.

cd 'C:\Users\Jeef\OneDrive\Survival Analysis\data files\SPSS'.

GET
  FILE='whas100.sav'.

*create a new variable for time in years.

COMPUTE time_yrs=lenfol / 365.25.
EXECUTE.

*list the first 10 observations.
SUMMARIZE
  /TABLES=id admitdate foldate los lenfol fstat age gender bmi
  /FORMAT=VALIDLIST NOCASENUM TOTAL LIMIT=10
  /TITLE='Case Summaries'
  /MISSING=VARIABLE
  /CELLS=COUNT.


CROSSTABS
  /TABLES=gender BY fstat
  /FORMAT=AVALUE TABLES
  /CELLS=COUNT
  /COUNT ROUND CELL.


KM time_yrs BY gender
  /STATUS=fstat(1)
  /PRINT MEAN
  /PERCENTILES
  /PLOT SURVIVAL
  /TEST LOGRANK BRESLOW TARONE
  /COMPARE OVERALL POOLED.


COXREG time_yrs
  /STATUS=fstat(1)
  /PATTERN BY gender
  /CONTRAST (gender)=Indicator
  /METHOD=ENTER gender 
  /PLOT SURVIVAL HAZARD
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20).


****************************************************************

*create categorical variable for age, same as lecture 1.

RECODE age (SYSMIS=SYSMIS) (Lowest thru 59=1) (60 thru 69=2) (70 thru 79=3) (80 thru 
    Highest=4)  INTO age_breaks.
VARIABLE LABELS  age_breaks 'age_4_categories'.
VALUE LABELS age_breaks
  1 '<60'
  2 '60-69'
  3 '70-79'
  4 '>=80'.
EXECUTE.


KM time_yrs BY age_breaks
  /STATUS=fstat(1)
  /PRINT MEAN
  /PERCENTILES
  /PLOT SURVIVAL
  /TEST LOGRANK
  /COMPARE OVERALL POOLED.


COXREG time_yrs
  /STATUS=fstat(1)
  /PATTERN BY age_breaks
  /CONTRAST (age_breaks)=Indicator
  /METHOD=ENTER age_breaks 
  /PLOT SURVIVAL HAZARDS
  /PRINT=CI(95) CORR SUMMARY 
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20).

COXREG time_yrs
  /STATUS=fstat(1)
  /PATTERN age(65) 
  /PATTERN age(75) 
  /METHOD=ENTER age 
  /PLOT SURVIVAL HAZARDS
  /PRINT=CI(95) CORR SUMMARY 
  /CRITERIA=PIN(.05) POUT(.10) ITERATE(20).










