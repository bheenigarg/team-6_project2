*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding housing sales in Ames, IA from 2006-2010

Dataset Name: cde_2014_analytic_file created in external file
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
*
Question: How does the sales price of houses vary with respect to neighborhoods?

Rationale: Rationale: This analysis will help identify expensive and cheaper neighborhoods.

Methodology:
;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: What are the variables that are highly correlated and their relevance in terms of selling prices?

Rationale: Correlations between variables will help in establishing hidden trends in the data and also point out redundant or uninformative variables.


Methodology:
;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: How does the selling price vary with the number of rooms (bedrooms, bathrooms and total rooms) in a house and what are the average number of each type of room in a house?

Rationale: This analysis will help to identify the number of rooms potential buyers prefer and more houses with such demand can be built.


Methodology:
;
