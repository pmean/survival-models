# survival-models

This repository contains R and SAS code for running a variety
of survival models. See each individual file for requirements.

Before you run these programs, please go to 

ftp://ftp.wiley.com/public/sci_tech_med/survival/

and download these files. Store them in a subdirectorty, wiley,
under that data directory. I did not include the wiley subdirectory
in the git repository because (a) I didn't need to, and (b) I didn't
want to take a chance of running afoul of any copyright issues.

This directory structure is based loosely on the recommendations in

Wilson et al. Good Enough Practices in Statistical Computing. 
PLoS Comput Biol 13(6): e1005510.

bin contains binary files (xlsx (Excel), pptx (PowerPoint), 
sas7bdat (SAS data), and RData (R data) files).

data contains text data files.

doc contains documentation, which for this repository is data dictionaries for most files found in the data folder.

results contains output from R and SAS programs.

src contains source code for R and SAS.