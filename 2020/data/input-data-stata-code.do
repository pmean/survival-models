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
* create grace1000 from dat file
clear
import delimited grace1000.dat, delimiters(" ", collapse)
drop v1
rename v2 id
rename v3 days
rename v4 death
rename v5 revasc
rename v6 revascdays
rename v7 los
rename v8 age
rename v9 sysbp
rename v10 stchange
drop v11
list in 1/5
save grace1000, replace
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
erase heroin1.dta
erase heroin2.dta
* create leader.dta from txt file
clear
import delimited leader.txt, varnames(1) delimiters(" ", collapse)
replace start=start+1000
list in 1/5
save leader, replace
* create psychiatric from txt file
clear
import delimited psychiatric-patients.txt, varnames(1) delimiters("\t")
list in 1/5
save psychiatric, replace
* create rats.dta from csv file
clear
import delimited rats.csv, varnames(1) delimiters(",")
list in 1/5
save rats, replace
* create transplant.dta from txt file
clear
import delimited transplant.txt, varnames(1) delimiters("\t")
list in 1/5
save transplant, replace
* create transplant1.dta from csv file
clear
import delimited transplant1.csv, varnames(1) delimiters(",")
list in 1/5
save transplant1, replace
* create transplant2.dta from csv file
clear
import delimited transplant2.csv, varnames(1) delimiters(",")
list in 1/5
save transplant2, replace
* create whas100.dta from dat file
clear
import delimited whas100.dat, delimiters(" ", collapse)
drop v1
rename v2 id
rename v3 admitdate
rename v4 foldate
rename v5 los
rename v6 lenfol
rename v7 fstat
rename v8 age
rename v9 gender
rename v10 bmi
drop v11
list in 1/5
save whas100, replace
* create whas500.dta from dat file
clear
import delimited whas500.dat, delimiters(" ", collapse)
drop v1
rename v2 id
rename v3 age
rename v4 gender
rename v5 hr
rename v6 sysbp
rename v7 diasbp
rename v8 bmi
rename v9 cvd
rename v10 afb
rename v11 sho
rename v12 chf
rename v13 av3
rename v14 miord
rename v15 mitype
rename v16 year
rename v17 admitdate
rename v18 disdate
rename v19 fdate
rename v20 los
rename v21 dstat
rename v22 lenfol
rename v23 fstat
drop v24
list in 1/5
save whas500, replace
log close