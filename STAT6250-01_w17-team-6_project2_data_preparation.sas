*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* 
[Dataset Name] Data1

[Dataset Description] Data from individual real estate transactions in Ames, IA
from 2006 to 2008

[Experimental Unit Description] Housing Units

[Number of Observations] 1941

[Number of Features] 23

[Data Source] http://ww2.amstat.org/publications/jse/v19n3/Decock/AmesHousing.
xls. From SAS Exploration Resources the online data source 'Journal of 
Statistical Education' with the data set "Ames Housing".

[Data Dictionary] http://ww2.amstat.org/publications/jse/v19n3/Decock/Data
Documentation.txt

[Unique ID Schema] 'Parcel Identification Number' (PID) is used for the primary
key.


[Dataset Name] Data2

[Dataset Description] Data from individual real estate transactions in Ames, 
IA from 2009 to 2010

[Experimental Unit Description] Housing Units

[Number of Observations] 989

[Number of Features] 23

[Data Source] http://ww2.amstat.org/publications/jse/v19n3/Decock/AmesHousing.
xls. From SAS Exploration Resources the online data source 'Journal of 
Statistical Education' with the data set "Ames Housing".

[Data Dictionary] http://ww2.amstat.org/publications/jse/v19n3/Decock/
DataDocumentation.txt

[Unique ID Schema] 'Parcel Identification Number' (PID) is used for the primary 
key.


[Dataset Name] Data3

[Dataset Description] Data from individual real estate transactions in Ames, 
IA from 2006 to 2010

[Experimental Unit Description] Housing Units

[Number of Observations] 2930

[Number of Features] 16

[Data Source] http://ww2.amstat.org/publications/jse/v19n3/Decock/AmesHousing.
xls. From SAS Exploration Resources the online data source 'Journal of 
Statistical Education' with the data set "Ames Housing".

[Data Dictionary] http://ww2.amstat.org/publications/jse/v19n3/Decock/
DataDocumentation.txt

[Unique ID Schema] 'Parcel Identification Number' (PID) is used for the primary 
key.
;

* setup environmental parameters;
%let inputDataset1URL =
https://github.com/stat6250/team-6_project2/blob/master/data/AmesHousing_Data1.xls?raw=true
;
%let inputDataset1Type = XLS;
%let inputDataset1DSN = Data1_raw;

%let inputDataset2URL =
https://github.com/stat6250/team-6_project2/blob/master/data/AmesHousing_Data2.xls?raw=true
;
%let inputDataset2Type = XLS;
%let inputDataset2DSN = Data2_raw;

%let inputDataset3URL =
https://github.com/stat6250/team-6_project2/blob/master/data/AmesHousing_Data3.xls?raw=true
;
%let inputDataset3Type = XLS;
%let inputDataset3DSN = Data3_raw;


* load raw datasets over the wire, if they doesn't already exist;
%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=dsn;
    %put &=url;
    %put &=filetype;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            %put Loading dataset &dsn. over the wire now...;
            filename tempfile TEMP;
            proc http
                method="get"
                url="&url."
                out=tempfile
                ;
            run;
            proc import
                file=tempfile
                out=&dsn.
                dbms=&filetype.;
            run;
            filename tempfile clear;
        %end;
    %else
        %do;
            %put Dataset &dsn. already exists. Please delete and try again.;
        %end;
%mend;
%loadDataIfNotAlreadyAvailable(
    &inputDataset1DSN.,
    &inputDataset1URL.,
    &inputDataset1Type.
)
%loadDataIfNotAlreadyAvailable(
    &inputDataset2DSN.,
    &inputDataset2URL.,
    &inputDataset2Type.
)
%loadDataIfNotAlreadyAvailable(
    &inputDataset3DSN.,
    &inputDataset3URL.,
    &inputDataset3Type.
)


* sort and check raw datasets for duplicates with respect to their unique ids,
  removing blank rows, if needed;
proc sort
        nodupkey
        data=Data1_raw
        dupout=Data1_raw_dups
        out=Data1_raw_sorted
    ;
    by
        PID
    ;
run;
proc sort
        nodupkey
        data=Data2_raw
        dupout=Data2_raw_dups
        out=Data2_raw_sorted
    ;
    by
        PID
    ;
run;
proc sort
        nodupkey
        data=Data3_raw
        dupout=Data3_raw_dups
        out=Data3_raw_sorted
    ;
    by
        PID
    ;
run;


* combine 2006-08 and 2009-10 data vertically by the primary key, Parcel Identification 
  Number(PID) retaining all 23 variables from each data set;
data ames_housing_2006_2010;
    set Data1_raw_sorted
	Data2_raw_sorted
	;
	by 
	    PID
	;
run;

proc format ;
  value spfmt low- 99999 = 'Less than $100,000'
	           100000 - 199999 = '$100,000 to $199,999'
	           200000 - 299999 = '$200,000 to $299,999'
		   300000 - 399999 = '$300,000 to $399,999'
		   400000 - 499999 = '$400,000 to $499,999'
		   500000 - 599999 = '$500,000 to $599,999'
		   600000 - 699999 = '$600,000 to $699,999'
		   700000 - 799999 = '$700,000 to $799,999'
		   800000 - 899999 = '$800,000 to $899,999'
		   900000 - 999999 = '$900,000 to $999,999'
		   1000000 - high = 'More than $1 million';
		   
   value $cafmt 'Y' = '1'
	        'N'  = '0';
	
   value dwellfmt '020' = '1-Story 1946 & newer all styles'
                  '030' = '1-Story 1945 & older'
		  '040' = '1-Story w/finished attic all ages'
		  '045' = '1.5 Story - unfinished all ages'
		  '050' = '1.5 Story finished all ages'
		  '060' = '2-Story 1946 & newer'
		  '070' = '2-Story 1945 & older'
		  '075' = '2.5 Story all ages'
		  '080' = 'Split or Multi-Level'
		  '085' = 'Split Foyer'
		  '090' = 'Duplex - all styles and ages'
		  '120' = '1-Story PUD 1946 & newer'
		  '150' = '1.5 Story PUD - all ages'
		  '160' = '2-Story PUD - 1946 & newer'
		  '180' = 'PUD - Multilevel - incl split Lev/Foyer'
		  '190' = '2 Family Conversion - all styles and ages';
		  
run;

* build analytic dataset from raw datasets with the least number of columns and
minimal cleaning/transformation needed to address research questions in
corresponding data-analysis files;
proc sort
        nodupkey
        data=ames_housing_2006_2010
        dupout=ames_housing_dups
        out=ames_housing_analytic_sorted
    ;
    by
        PID
    ;
run;
data ames_housing_analytic_file;
   Log_SalePrice = log(SalePrice + 1);
   retain
        MS_SubClass
        Neighborhood
	Lot_Area
	Land_Slope
	Central_Air
	Bldg_Type
	House_Style
	Overall_Cond
	Roof_Style
        Exterior_1st
	Total_Bsmt_SF
	Kitchen_Qual
	Full_Bath
        Bedroom_AbvGr
	TotRms_AbvGrd
        Year_Built
	Yr_Sold
        Fireplaces
        Wood_Deck_SF
        Open_Porch_SF
        Pool_Area
        Garage_Area
	Garage_Cars
	SalePrice
	Log_SalePrice
    ;
    keep
        MS_SubClass
        Neighborhood
	Lot_Area
	Land_Slope
	Central_Air
	Bldg_Type
	House_Style
	Overall_Cond
	Roof_Style
        Exterior_1st
	Total_Bsmt_SF
	Kitchen_Qual
	Full_Bath
        Bedroom_AbvGr
	TotRms_AbvGrd
        Year_Built
	Yr_Sold
        Fireplaces
        Wood_Deck_SF
        Open_Porch_SF
        Pool_Area
        Garage_Area
	Garage_Cars
	SalePrice
	Log_SalePrice
    ;
    merge
        ames_housing_analytic_sorted
        Data3_raw_sorted
    ;
    by
        PID
    ;
	if _N_ = 1 then delete;
run;
