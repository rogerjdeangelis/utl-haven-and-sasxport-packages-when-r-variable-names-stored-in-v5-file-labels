%let pgm=utl-haven-and-sasxport-packages-when-r-variable-names-stored-in-v5-file-labels;

Haven and SASxport packages with r variable names stored in v5 export file labels

github
https://tinyurl.com/mrxbn9ce
https://github.com/rogerjdeangelis/utl-haven-and-sasxport-packages-when-r-variable-names-stored-in-v5-file-labels

Thank all of the haven developers for enriching the R language.

I am trying to rename the v5 export the 8 charater variable names to the longer R variable names contained
the label area of the V5 transport file. This way R other languages can use the R names.

I am having two issues withe haven write_xpt that SASxport does not have.
SASxport was removed from CRAN?

     1. write_xpt errs out on R column names with a '.' delimiter (Infant.Mortality)
     2. write_xpt can only output to the current working directory

I am prpbably doing something stupoid but it seems that Greg Warnes SASxport is
easier to use and perhaps more mature.

I think Gregs SASxport works with more non standard variable names and labels.
Also SASxport does not have to output to the current working directory.
It is a little more mature than haven, having been enriched many times over the years?

Consider, built in dataset swiss. This dataset has a variable name with
a period delimiter , Infant.Mortality.
This is also an issue with the iris dataframe variable names.

Extra code needed with write_xpt but not SASxport

   1. I had to rename Infant.Mortality to InfantMortality
   2. I had to set the current working directory

/*
| |__   __ ___   _____ _ __
| `_ \ / _` \ \ / / _ \ `_ \
| | | | (_| |\ V /  __/ | | |
|_| |_|\__,_| \_/ \___|_| |_|

*/
proc datasets lib=sd1 nolist nodetails;delete want; run;quit;
%utlfkil(d:/xpt/want_xpt);

%utl_rbeginx;
parmcards4;
library(haven)
library(labelled)
colfix<-sub("\\.","",colnames(swiss))
colnames(swiss) <- colfix;
want <- set_variable_labels(swiss,.labels = colnames(swiss))
setwd("d:/xpt")
write_xpt(want,"want.xpt",version=5)
;;;;
%utl_rendx;

libname xpt xport "d:/xpt/want.xpt";
proc contents data=xpt._all_;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*   Alphabetic List of Variables and Attributes                                                                          */
/*                                                                                                                        */
/* #    Variable    Type    Len    Label                                                                                  */
/*                                                                                                                        */
/* 2    AGRICULT    Num       8    Agriculture                                                                            */
/* 5    CATHOLIC    Num       8    Catholic                                                                               */
/* 4    EDUCATIO    Num       8    Education                                                                              */
/* 3    EXAMINAT    Num       8    Examination                                                                            */
/* 1    FERTILIT    Num       8    Fertility                                                                              */
/* 6    INFANTMO    Num       8    InfantMortality                                                                        */
/*                                                                                                                        */
/**************************************************************************************************************************/


Because SASxport is not in Cran you need to download
https://cran.r-project.org/src/contrib/Archive/SASxport/
You will need to download and install rtools and devtool.
then
install.packages("#.tar.gz", repos = NULL, type="source")


/*                                   _
 ___  __ _ _____  ___ __   ___  _ __| |_
/ __|/ _` / __\ \/ / `_ \ / _ \| `__| __|
\__ \ (_| \__ \>  <| |_) | (_) | |  | |_
|___/\__,_|___/_/\_\ .__/ \___/|_|   \__|
                   |_|
*/

/*----  SASxport handles labels and non standard column names           ----*/
/*----  Do not have to use the current working directory                ----*/
/*----  Simpler                                                         ----*/

proc datasets lib=sd1 nolist nodetails;delete want; run;quit;
%utlfkil(d:/xpt/want_xpt);

%utl_submit_r64x('
library(SASxport);
library(labelled);
want <- set_variable_labels(swiss,.labels = colnames(swiss));
write.xport(want,file="d:/xpt/want.xpt");
');

libname xpt xport "d:/xpt/want.xpt";
proc contents data=xpt._all_;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*     Alphabetic List of Variables and Attributes                                                                        */
/*                                                                                                                        */
/*  #    Variable    Type    Len    Label                                                                                 */
/*                                                                                                                        */
/*  2    AGRICULT    Num       8    Agriculture                                                                           */
/*  5    CATHOLIC    Num       8    Catholic                                                                              */
/*  4    EDUCATIO    Num       8    Education                                                                             */
/*  3    EXAMINAT    Num       8    Examination                                                                           */
/*  1    FERTILIT    Num       8    Fertility                                                                             */
/*  6    INFANT_M    Num       8    Infant.Mortality                                                                      */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
