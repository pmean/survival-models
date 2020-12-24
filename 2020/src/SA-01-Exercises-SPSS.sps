* Encoding: windows-1252.

cd 'C:\Users\Jeef\OneDrive\Survival Analysis\data files\SPSS'.

GET
  FILE='whas500.sav'.



*Question 1.
KM lenfol
  /STATUS=fstat(1)
  /PRINT MEAN
  /PERCENTILES
  /PLOT SURVIVAL.


*Question 2.

*crosstabs for gender and fstat.
CROSSTABS
  /TABLES=gender BY fstat
  /FORMAT=AVALUE TABLES
  /CELLS=COUNT
  /COUNT ROUND CELL.

KM lenfol BY gender
  /STATUS=fstat(1)
  /PRINT MEAN
  /PERCENTILES
  /PLOT SURVIVAL
  /TEST LOGRANK
  /COMPARE OVERALL POOLED.

*Question 3.

RECODE age (SYSMIS=SYSMIS) (Lowest thru 59=1) (60 thru 69=2) (70 thru 79=3) (80 thru 
    Highest=4)  INTO age_breaks.
VARIABLE LABELS  age_breaks 'age_4_categories'.
VALUE LABELS age_breaks
  1 '<60'
  2 '60-69'
  3 '70-79'
  4 '>=80'.
EXECUTE.

*crosstabs for age_breaks and fstat.
CROSSTABS
  /TABLES=age_breaks BY fstat
  /FORMAT=AVALUE TABLES
  /CELLS=COUNT
  /COUNT ROUND CELL.

KM lenfol BY age_breaks
  /STATUS=fstat(1)
  /PRINT MEAN
  /PERCENTILES
  /PLOT SURVIVAL
  /TEST LOGRANK
  /COMPARE OVERALL POOLED.
