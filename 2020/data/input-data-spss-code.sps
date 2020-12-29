* Encoding: UTF-8.
* fly1.
GET DATA  /TYPE=TXT
  /FILE="E:\git\survival-models\2020\data\fly1.txt"
  /DELIMITERS=" "
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=1
  /DATATYPEMIN PERCENTAGE=95.0
  /VARIABLES=
  day AUTO
  /MAP.

DATASET NAME fly1 WINDOW=FRONT.

SAVE OUTFILE='E:\git\survival-models\2020\data\fly1.sav'
  /COMPRESSED.

* fly2.
GET DATA  /TYPE=TXT
  /FILE="E:\git\survival-models\2020\data\fly2.txt"
  /DELIMITERS=" "
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=1
  /DATATYPEMIN PERCENTAGE=95.0
  /VARIABLES=
  day AUTO
  cens AUTO
  /MAP.

DATASET NAME fly2 WINDOW=FRONT.

SAVE OUTFILE='E:\git\survival-models\2020\data\fly2.sav'
  /COMPRESSED.

* fly3.
GET DATA  /TYPE=TXT
  /FILE="E:\git\survival-models\2020\data\fly3.txt"
  /DELIMITERS=" "
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=1
  /DATATYPEMIN PERCENTAGE=95.0
  /VARIABLES=
  day AUTO
  cens AUTO
  /MAP.

DATASET NAME fly3 WINDOW=FRONT.

SAVE OUTFILE='E:\git\survival-models\2020\data\fly3.sav'
  /COMPRESSED.

*grace1000.
GET DATA  /TYPE=TXT
  /FILE="E:\git\survival-models\2020\data\grace1000.dat"
  /ENCODING='UTF8'
  /DELCASE=LINE
  /DELIMITERS=" "
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=1
  /LEADINGSPACES IGNORE=YES
  /DATATYPEMIN PERCENTAGE=95.0
  /VARIABLES=
  id F3.0
  days F3.0
  death F1.0
  revasc F1.0
  revascdays F3.0
  los F2.0
  age F2.0
  sysbp F3.0
  stchange F1.0
  /MAP.
DATASET NAME grace1000 WINDOW=FRONT.

SAVE OUTFILE='E:\git\survival-models\2020\data\grace1000.sav'
  /COMPRESSED.

*heart.
GET DATA  /TYPE=TXT
  /FILE="E:\git\survival-models\2020\data\heart.csv"
  /ENCODING='UTF8'
  /DELIMITERS=","
  /QUALIFIER='"'
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /DATATYPEMIN PERCENTAGE=95.0
  /VARIABLES=
  start AUTO
  stop AUTO
  event AUTO
  age AUTO
  year AUTO
  surgery AUTO
  transplant AUTO
  id AUTO
  /MAP.

DATASET NAME heart WINDOW=FRONT.

SAVE OUTFILE='E:\git\survival-models\2020\data\heart.sav'
  /COMPRESSED.

*heroin.
GET DATA  /TYPE=TXT
  /FILE="E:\git\survival-models\2020\data\heroin.txt"
  /ENCODING='UTF8'
  /DELCASE=VARIABLES 6
  /DELIMITERS="\t"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /DATATYPEMIN PERCENTAGE=95.0
  /VARIABLES=
  ID AUTO
  Clinic AUTO
  Status AUTO
  Time AUTO
  Prison AUTO
  Dose AUTO
  /MAP.

DATASET NAME heroin WINDOW=FRONT.

SAVE OUTFILE='E:\git\survival-models\2020\data\heroin.sav'
  /COMPRESSED.

*leader.
GET DATA  /TYPE=TXT
  /FILE="E:\git\survival-models\2020\data\leader.txt"
  /ENCODING='UTF8'
  /DELCASE=LINE
  /DELIMITERS=" "
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /DATATYPEMIN PERCENTAGE=95.0
  /VARIABLES=
  years AUTO
  lost AUTO
  manner AUTO
  start AUTO
  military AUTO
  age AUTO
  conflict AUTO
  loginc AUTO
  growth AUTO
  pop AUTO
  land AUTO
  literacy AUTO
  region AUTO
  /MAP.

DATASET NAME leader WINDOW=FRONT.

SAVE OUTFILE='E:\git\survival-models\2020\data\leader.sav'
  /COMPRESSED.

*psychiatric-patients.
GET DATA  /TYPE=TXT
  /FILE="E:\git\survival-models\2020\data\psychiatric-patients.txt"
  /ENCODING='UTF8'
  /DELCASE=LINE
  /DELIMITERS="\t"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=3
  /DATATYPEMIN PERCENTAGE=95.0
  /VARIABLES=
  sex AUTO
  age AUTO
  time AUTO
  death AUTO
  /MAP.

DATASET NAME psychiatric WINDOW=FRONT.

SAVE OUTFILE='E:\git\survival-models\2020\data\psychiatric.sav'
  /COMPRESSED.

*rats.
GET DATA  /TYPE=TXT
  /FILE="E:\git\survival-models\2020\data\rats.csv"
  /ENCODING='UTF8'
  /DELIMITERS=","
  /QUALIFIER='"'
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /DATATYPEMIN PERCENTAGE=95.0
  /VARIABLES=
  litter AUTO
  rx AUTO
  time AUTO
  status AUTO
  sex AUTO
  /MAP.

DATASET NAME rats WINDOW=FRONT.

SAVE OUTFILE='E:\git\survival-models\2020\data\rats.sav'
  /COMPRESSED.

*transplant.
GET DATA  /TYPE=TXT
  /FILE="E:\git\survival-models\2020\data\transplant.txt"
  /ENCODING='UTF8'
  /DELCASE=LINE
  /DELIMITERS="\t"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=3
  /DATATYPEMIN PERCENTAGE=95.0
  /VARIABLES=
  birth.dt AUTO
  accept.dt AUTO
  tx.date AUTO
  fu.date AUTO
  fustat AUTO
  surgery AUTO
  age AUTO
  futime AUTO
  wait.time AUTO
  transplant AUTO
  mismatch AUTO
  hla.a2 AUTO
  mscore AUTO
  reject AUTO
  /MAP.
DATASET NAME transplant WINDOW=FRONT.

SAVE OUTFILE='E:\git\survival-models\2020\data\transplant.sav'
  /COMPRESSED.

*transplant1.
GET DATA  /TYPE=TXT
  /FILE="E:\git\survival-models\2020\data\transplant1.csv"
  /ENCODING='UTF8'
  /DELIMITERS=","
  /QUALIFIER='"'
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /DATATYPEMIN PERCENTAGE=95.0
  /VARIABLES=
  birth.dt AUTO
  accept.dt AUTO
  tx.date AUTO
  fu.date AUTO
  fustat AUTO
  surgery AUTO
  age AUTO
  futime AUTO
  wait.time AUTO
  transplant AUTO
  mismatch AUTO
  hla.a2 AUTO
  mscore AUTO
  reject AUTO
  /MAP.
DATASET NAME transplant1 WINDOW=FRONT.

SAVE OUTFILE='E:\git\survival-models\2020\data\transplant1.sav'
  /COMPRESSED.

* transplant2.
GET DATA  /TYPE=TXT
  /FILE="E:\git\survival-models\2020\data\transplant2.csv"
  /ENCODING='UTF8'
  /DELIMITERS=","
  /QUALIFIER='"'
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /DATATYPEMIN PERCENTAGE=95.0
  /VARIABLES=
  id AUTO
  start AUTO
  stop AUTO
  event AUTO
  transplant AUTO
  age AUTO
  year AUTO
  surgery AUTO
  /MAP.
DATASET NAME transplant2 WINDOW=FRONT.

SAVE OUTFILE='E:\git\survival-models\2020\data\transplant2.sav'
  /COMPRESSED.

*whas100.
GET DATA  /TYPE=TXT
  /FILE="E:\git\survival-models\2020\data\whas100.dat"
  /ENCODING='UTF8'
  /DELCASE=LINE
  /DELIMITERS=" "
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=1
  /LEADINGSPACES IGNORE=YES
  /DATATYPEMIN PERCENTAGE=95.0
  /VARIABLES=
  id AUTO
  admitdate ADATE10
  foldate ADATE10
  los F2.0
  lenfol F4.0
  fstat F1.0
  age F2.0
  gender F1.0
  bmi F8.5
  /MAP.
DATASET NAME whas100 WINDOW=FRONT.

SAVE OUTFILE='E:\git\survival-models\2020\data\whas100.sav'
  /COMPRESSED.

*whas500.
GET DATA  /TYPE=TXT
  /FILE="E:\git\survival-models\2020\data\whas500.dat"
  /ENCODING='UTF8'
  /DELCASE=LINE
  /DELIMITERS=" "
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=1
  /LEADINGSPACES IGNORE=YES
  /DATATYPEMIN PERCENTAGE=95.0
  /VARIABLES=
  id F3.0
  age F2.0
  gender F1.0
  hr F3.0
  sysbp F3.0
  diasbp F3.0
  bmi F8.5
  cvd F1.0
  afb F1.0
  sho F1.0
  chf F1.0
  av3 F1.0
  miord F1.0
  mitype F1.0
  year F1.0
  admitdate ADATE10
  disdate ADATE10
  fdate ADATE10
  los F2.0
  dstat F1.0
  lenfol F4.0
  fstat F1.0
  /MAP.
DATASET NAME whas500 WINDOW=FRONT.

SAVE OUTFILE='E:\git\survival-models\2020\data\whas500.sav'
  /COMPRESSED.

*save output.
OUTPUT SAVE NAME=Document1
  OUTFILE='E:\git\survival-models\2020\data\input-data-spss-output.spv'
  LOCK=NO.
