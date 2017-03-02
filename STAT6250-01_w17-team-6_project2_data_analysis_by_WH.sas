*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding assessed values for individual residential properties sold 
in Ames, IA from AY 2006 - 2010.

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
"Question: What is the average sale price of properties sold in Ames, Iowa
between AY 2006-2008 and AY 2009-2010?"
;

title2
"Rationale: This would help brokers to know the average sale price buyers are 
willing to spend. Also, property builders can consider building new properties 
around the average sale price of properties sold in Ames, IA."
;

footnote1
"With properties sold in Ames, IA between AY 2006-2010, minimum price sold for
a property was $12,789 and maximum price sold was $755,000."
;

footnote2
"Out of 2,930 observation properties sold in Ames, IA, the average sales price 
is $180,796.06."
;

footnote3
"This compares the column “SalePrice” in Data1 to the same column in 
Data2."
;

*
Methodology: With ames_housing_analytic_file, use PROC MEANS on column 
"SalePrice" and obtain the average sale price of properties sold in Ames, IA.
;
 
proc means data=ames_housing_analytic_file;
    var SalePrice;
run;


title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
"Question: What are the top 3 type of exterior covering on house in Ames, Iowa 
that was involved in a sale between AY 2006-2008 and AY 2009-2010?"
;

title2
"Rationale: This would help identify which type of exterior covering on house 
can be considered when building new future properties."
;

footnote1
"The top 3 type of exterior coverings sold in Ames, IA ,in order from
best to least, were Vinyl Siding, Metal Siding, and Hard Board."
;

footnote2
"Vinyl Siding had 1,026 properties sold. Metal Siding had 450 properties sold.
 Hard Board had 442 properties sold."
;

footnote3
"This compares the column “Exterior_1st” in Data1 to the same column in 
Data2."
;

*
Methodology: With utilizing ames_housing_analytic_file, PROC FREQ will be used
to obtain the percentages of column "Exterior_1st". In this way, the top 3 type 
of exterior covering can be shown.
;

proq freq data=ames_housing_analytic_file;
    table Exterior_1st/list;
run;

title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
"Question: Is there any correlation between an Open Porch and SalePrice of 
properties sold? If there is any correlation, please explain the correlation?"
;

title2
"Rationale: This would help identify the impact of an Open Porch to the 
SalePrice of sold properties in Ames, IA AY 2006-2010."
;

footnote1
"Open Porch had an average of 47.53 square feet sold and Sale Price had an 
average of $180,796 sold"
;

footnote2
"For every .31 Open Porch square feet sold, Sale Price goes up by 1 unit $."
;

footnote3
"This compares the column “Open_Porch_SF” in Data3 to the column “SalePrice”
in Data1 and Data2."
;

*
Methodology: With analyzing all 3 data sets, PROC CORR will be used to see
the correlation effects of "Open_Porch_SF" to "SalePrice". 
;

proc corr data=ames_housing_analytic_file;
    var Open_Porch_SF
        SalePrice;
run;

title;
footnote;
