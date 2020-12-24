* Encoding: windows-1252.

cd 'C:\Users\Jeef\OneDrive\Survival Analysis\data files\SPSS'.

GET
  FILE='whas100.sav'.

*create a new variable for time in years.

COMPUTE time_yrs=lenfol / 365.25.
EXECUTE.




KM time_yrs
  /STATUS=fstat(1)
  /PRINT TABLE MEAN
  /PLOT SURVIVAL.

KM time_yrs
  /STATUS=fstat(1)
  /PRINT MEAN
  /PERCENTILES
  /PLOT SURVIVAL.

KM time_yrs BY gender
  /STATUS=fstat(1)
  /PRINT MEAN
  /PERCENTILES
  /PLOT SURVIVAL
  /TEST LOGRANK
  /COMPARE OVERALL POOLED.


*create categorical varaible from continuous for age.

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



KM time_yrs BY age_breaks
  /STATUS=fstat(1)
  /PRINT MEAN
  /PERCENTILES
  /PLOT SURVIVAL
  /TEST LOGRANK 
  /TREND
  /COMPARE OVERALL POOLED.








