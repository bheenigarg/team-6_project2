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

data ames_housing_analytic_file;
    retain
        MS_SubClass
        Exterior_1st
        Kitchen_Qual
        SalePrice
        Neighborhood
        Bedroom_AbvGr
        Year_Built
        Fireplaces
        Wood_Deck_SF
        Open_Porch_SF
        Pool_Area
        Overall_Cond
    ;
    keep
        MS_SubClass
        Exterior_1st
        Kitchen_Qual
        SalePrice
        Neighborhood
        Bedroom_AbvGr
        Year_Built
        Fireplaces
        Wood_Deck_SF
        Open_Porch_SF
        Pool_Area
        Overall_Cond
    ;
    merge
        Data1_raw_sorted
        Data2_raw_sorted
        Data3_raw_sorted
    ;
    by
        PID
    ;
run;
