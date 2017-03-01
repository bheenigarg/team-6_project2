*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding housing sales in Ames, IA from 2006-2010

Dataset Name: ames_housing_analytic_file created in external file
STAT6250-01_w17-team-6_project2_data_preparation.sas, which is assumed to be
in the same directory as this file

See included file for dataset properties
;

* environmental setup;
%let dataPrepFileName = STAT6250-01_w17-team-6_project2_data_preparation.sas;
%let sasUEFilePrefix = team-6_project2;

* load external file that generates analytic dataset
ames_housing_analytic_file using a system path dependent on the host
operating system, after setting the relative file import path to the current
directory, if using Windows;
%macro setup;
    %if
        &SYSSCP. = WIN
    %then
        %do;
            X
            "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))"""
            ;           
            %include ".\&dataPrepFileName.";
        %end;
    %else
        %do;
            %include "~/&sasUEFilePrefix./&dataPrepFileName.";
        %end;
%mend;
%setup


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
title1
"Research Question 1: Is the sale price of homes affected by the year it was built and what is the average sale price for year built?"
;

title2
"Rationale: This can help to determine the general price range that homes should be listed at, based on how old the home is."
;

*
Methodology: Use PROC CORR to determine the correlation between the year that the house was built and the sale price.
;

*footnote1;

proc corr data = ames_housing_analytic_file;
    var SalePrice
        Year_Built;
run;
title;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
"Research Question 2: What additional home features (Fireplaces, Wood Deck SF, Open Porch SF, and Pool Area) affect the sale price of the home?"
;

title2
"Rationale: The results of this analysis can help to price homes with any of these features."
;

*
Methodology: Use PROC FREQ to compare which variables for additional home features correlate with the sale price of the home.
;

*footnote1;

proc freq data = ames_housing_analytic_file;
          tables SalePrice*Fireplaces/nocum norow nocol;
          format SalePrice spfmt.;
run;
title;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
title1
"Research Question 3: How does the overall condition rating of the home relate to the sale price of the home?"
;

title2
"Rationale: If the overall condition rating significantly affects the sale price of the home, this can be used to price future homes, as well as inform homeowners how to improve the condition of their home to increase the value."
;

*
Methodology: Use PROC CORR to view the overall conditions ratings that are associated with sale prices of homes.
;

*footnote;

proc corr data = ames_housing_analytic_file;
    var SalePrice
        Overall_Cond;
run;
title;
