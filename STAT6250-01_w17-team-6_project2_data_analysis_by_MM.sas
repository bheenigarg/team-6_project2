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
"Research Question 1: How are housing sales changing over time and can this be used to help predict future home pricing?"
;

title2
"Rationale: This can help to determine how the sale price of homes varies by the year they are sold.."
;

*
Methodology: Use PROC CORR to determine the correlation between the year that the house was sold and the sale price.
;

*footnote1;

proc corr data = ames_housing_analytic_file;
    var SalePrice
        Yr_Sold;
run;
title;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
"Research Question 2: Does the presence of a central air conditioner in the home have an relationship with the sale price?"
;

title2
"Rationale: The results of this analysis can help to price homes based on if they have a central air unit."
;

*
Methodology: Use PROC FREQ to view the frequency of central air with the sale price range of the homes.
;

*footnote1;

proc freq data = ames_housing_analytic_file;
          tables SalePrice*Central_Air/nocum norow nocol;
          format SalePrice spfmt.
                 Central_Air $cafmt.;
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

footnote1
"With the results indicating a slightly negative correlation, we can determine that the overall condition rating is not helpful in reaching the sale price"
;

footnote2
"This data suggests that if the goal is to have an overall condition rating that helps to price the home, the system for rating the condition should be re-evaluated."
;

proc corr data = ames_housing_analytic_file;
    var SalePrice
        Overall_Cond;
run;
title;
footnote;
