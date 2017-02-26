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

title1
"Research Question: How does the sales price of houses vary with respect to neighborhoods?"
;

title2
"Rationale: This analysis will help identify expensive and cheaper neighborhoods."
;

footnote1
"Plotting the boxplot between neighborhoods and sale price shows that Meadow Village, Briardale and Iowa DOT and Rail Road are among the cheapest neighborhoods. While Northridge, Northridge Heights and Stone Brook are rich neighborhoods with several outliers in terms of price."
;

footnote2
"It can also be noted that many of the rich neighborhoods have high variability in sale prices which means that they have sale prices varying from relatively low to very high."
;

*
Methodology: Proc means is used to calculate the average selling price in each neighborhood. 
Proc sort and print is used to sort and print the means in descending order. 

Proc sgplot to create boxplots is used to graph the average selling price for each neighborhood.
;
proc means
        mean
        noprint
        data=ames_housing_analytic_file
    ;
    class Neighborhood;
    var SalePrice;
    output out=ames_housing_temp;
run;

proc sort data=ames_housing_temp(where=(_STAT_="MEAN"));
    by descending SalePrice;
run;

proc print data=ames_housing_temp;
    var Neighborhood SalePrice;
run;


ods graphics on/ height=8in;
proc sgplot data = ames_housing_analytic_file;
    hbox SalePrice/ category = Neighborhood;
run;
ods graphics off;

title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
title1
"Research Question: What are the variables that are highly correlated and their relevance in terms of selling prices?"
;

title2
"Rationale: Correlations between variables will help in establishing hidden trends in the data and also point out redundant or uninformative variables."
;

footnote1
"There is a strong positive correlation between Sale Price and Total Basement Surface (0.63)."
;

footnote2
"There is a slight negative correlation between Sale Price and Overall Condition. It seems that recently bult houses tend to be in worse Overall Condition."
;

*
Methodology: PROC CORR is used to calculate the correlation coefficients where Pearson 
correlations are displayed. The correlations are calculated forthe numeric variables in the dataset.
;

ods graphics on;
proc corr data = ames_housing_analytic_file nosimple noprob best=7;
    var Lot_Area
	Overall_Cond
	Total_Bsmt_SF
	Full_Bath
        Bedroom_AbvGr
	TotRms_AbvGrd
        Year_Built
        Fireplaces
        Wood_Deck_SF
        Open_Porch_SF
        Pool_Area
        Garage_Area
	SalePrice;
run;
ods graphics off;

title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
title1
"Research Question: What are the significant variables that highly impact the selling price of a house?"
;

title2
"Rationale: This analysis will help to estimate and predict house prices with these features. So a potential home buyer can be given an estimate of a house price based on the significant features."
;

footnote1
"Using the stepwise selection technique, the most significant variables at alpha level 0.1 are SalePrice, Year_Built, Full_Bath, Garage_Area, Fireplaces, Pool Area, Overall_Cond, TotRms_AbvGrd and Bedroom_AbvGr."
;

*
Methodology: Proc sgplot is used to check for normality of the response variable Sale Price. The plot shows that the data are right skewed
and therefore a log transformation is used to normalize it.

Proc reg is applied on the variables to fit a linear regression model where Sale Price is the response variable. Stepwise selection method is used to identify the 
significant variables for alpha =0.1.
;

proc sgplot data = ames_housing_analytic_file ;
    histogram SalePrice;
run;

proc sgplot data = ames_housing_analytic_file ;
    histogram Log_SalePrice;
run;

proc reg data= ames_housing_analytic_file;
   model Log_SalePrice = Lot_Area
		         Overall_Cond
		         Total_Bsmt_SF
		         Full_Bath
                         Bedroom_AbvGr
		         TotRms_AbvGrd
                         Year_Built
                         Fireplaces
                         Wood_Deck_SF
                         Open_Porch_SF
                         Pool_Area
                         Garage_Area
		         SalePrice/ selection = stepwise sls = 0.1 sle = 0.1;
run;

title;
footnote;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
title1
"Research Question: How does the selling price vary with the number of rooms (bedrooms, bathrooms and total rooms) in a house 
and how many of each are preferred by homebuyers?"
;

title2
"Rationale: This analysis will help to identify the number of rooms potential buyers prefer and more houses with such demand can be built."
;

footnote1
"The maximum number of Bedrooms in most houses is 3, bathrooms is 2 and total number of rooms is 6."
;

footnote2
"The scatterplots show that the Sale Price increases with increase in the number of rooms."
;

*
Methodology: Proc freq is used to calculate the maximum number of bedrooms, bathrooms and total rooms. 
The relation between Sale Price and number of each typpe of rooms is plotted using Proc sgplot. 
;

proc freq data = ames_housing_analytic_file order=freq;
   table Bedroom_AbvGr/ nocum nopercent;
run;

Proc sgplot data = ames_housing_analytic_file noautolegend;
   reg y = SalePrice x = Bedroom_AbvGr;
run;
		
proc freq data = ames_housing_analytic_file order=freq;
   table Full_Bath/ nocum nopercent;
run;

Proc sgplot data = ames_housing_analytic_file noautolegend;
   reg y = SalePrice x = Full_Bath;
run;

proc freq data = ames_housing_analytic_file order=freq;
   table TotRms_AbvGrd/ nocum nopercent;
run;

Proc sgplot data = ames_housing_analytic_file noautolegend;
   reg y = SalePrice x = TotRms_AbvGrd;
run;

title;
footnote;
