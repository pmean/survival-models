* preliminary statements
cls
capture log close
set more off
set mem 20m
cd e:/git/survival-models/2020/data
log using input-data-stata-output.log, replace
* create fly1.dta from txt file
clear
import delimited fly1.txt, varnames(nonames) delimiters(" ")
rename v1 day
list in 1/5
save fly1, replace
* create fly2.dta from txt file
clear
import delimited fly2.txt, varnames(nonames) delimiters(" ")
rename v1 day
rename v2 cens
list in 1/5
save fly2, replace
* create fly3.dta from txt file
clear
import delimited fly3.txt, varnames(nonames) delimiters(" ")
rename v1 day
rename v2 cens
list in 1/5
save fly3, replace
* create heart.dta from csv file
clear
import delimited heart.csv
list in 1/5
save heart, replace
* create heroin.dta from csv file
clear
import delimited heroin.txt, varnames(1) delimiters("\t") colrange(1:6) 
list in 1/5
save heroin1, replace
clear
import delimited heroin.txt, varnames(1) delimiters("\t") colrange(7:12) 
list in 1/5
save heroin2, replace
clear
use heroin1
append using heroin2
save heroin, replace
log close