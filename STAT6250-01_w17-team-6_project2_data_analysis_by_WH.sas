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
"Question: What are the top 3 type of dwellings in Ames, Iowa that was involved 
in a sale between AY 2006-2008 and AY 2009-2010?"
;

title2
"Rationale: This would help identify which type of dwellings can be considered 
in building new future properties."
;

footnote1
;

*
Note: This compares the column “MS_SubClass” in Data1 to the same column in 
Data2.

Methodology: With ames_housing_analytic_file, use PROC FREQ on column 
"MS_SubClass" and obtain the top 3 types of dwelling sold by viewing percentage.
;
    
proc freq data=ames_housing_analytic_file;
    table MS_SubClass;
run;

proc sort data=ames_housing_analytic_file;
    by descending MS_SubClass;
run;

proc print data=ames_housing_analytic_file;
    var MS_SubClass;

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
;


*
Note: This compares the column “Exterior_1st” in Data1 to the same column in 
Data2.

Methodology: With utilizing ames_housing_analytic_file, PROC FREQ will be used
to obtain the percentages of column "Exterior_1st". In this way, the top 3 type 
of exterior covering can be shown.
;

proq freq data=ames_housing_analytic_file;
    table Exterior_1st;
run;

proq sort data=ames_housing_analytic_file;
    descending Exterior_1st;
run;

title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
"Question: What is the effect of Kitchen quality to sales price of property 
sold? Describe each Kitchen quality to the sales price."
;

title2
"Rationale: This would help identify which Kitchen quality would be best to 
build and suitable for homebuyers."
;

footnote1
;

*
Note: This compares the column “KitchenQual” in Data3 to the column “SalePrice”
in Data1 and Data2.

Methodology: With analyzing all 3 data sets, PROC FREQ will be used to see
the % effects of "KitchenQual" to "SalePrice". 
;

proc freq data=ames_housing_analytic_file;
    tables Kitchen_Qual*SalePrice;
    format SalePrice spfmt;
run;

title;
footnote;
