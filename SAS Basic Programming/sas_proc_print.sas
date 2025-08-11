/*---------------------------------------------------------------------------------------
SASify. "Simplifying SAS"

PROC PRINT – Usage Overview
-----------------------------------------------------------------------------------------
The PROC PRINT procedure in SAS is used to display the contents of a dataset in a 
tabular format. It is one of the most common and simple ways to review, validate, and 
present data. By default, PROC PRINT outputs all variables and all observations from 
the specified dataset in the order they appear. However, numerous options and 
statements allow for filtering, sorting (with PROC SORT), selecting specific variables, 
labeling, formatting, and controlling the style of the output.

Typical usage:
    proc print data=LIBRARY.DATASET;
    run;

-----------------------------------------------------------------------------------------
Quick Option Reference Table
-----------------------------------------------------------------------------------------
| Option / Statement     | Description                                                 |
|------------------------|-------------------------------------------------------------|
| data=                  | Specifies the dataset to print.                             |
| (obs=n)                | Limits output to the first n observations.                  |
| var                    | Selects specific columns to display.                        |
| noobs                  | Removes the automatic observation number column.            |
| by                     | Groups output by one or more variables (dataset must be     |
|                        | sorted beforehand using PROC SORT).                         |
| id                     | Sets ID variable to replace observation number.             |
| label                  | Enables display of custom variable labels.                  |
| split="char"           | Splits long labels into multiple lines at the given char.   |
| format                 | Applies display formats to variables.                       |
| where                  | Filters rows based on specified conditions.                 |
| title / footnote       | Adds titles and footnotes to the output.                     |
| ods                    | Controls output destination and style (HTML, PDF, RTF, etc).|
-----------------------------------------------------------------------------------------
Best Practices:
- Always use WHERE instead of subsetting IF inside PROC PRINT for efficiency.
- Sort the dataset beforehand if you plan to use BY grouping.
- Apply FORMATS to improve readability for numeric and date variables.
---------------------------------------------------------------------------------------*/


*Basic Syntax;
proc print data=sashelp.cars;
run;

*Select Specific Variables;
proc print data=sashelp.cars;
    var Make Model Type MSRP;
run;

*Limit number of observations;
proc print data=sashelp.cars (obs=10);
run;

*Add observation numbers;
*'noobs' removes the automatic observation number column;
proc print data=sashelp.cars (obs=10);
run;

*Fiter Rows;
proc print data=sashelp.cars;
    where Type = "SUV";
run;

*Order by Variable;
proc sort data=sashelp.cars out=sorted_cars;
    by MSRP;
run;

proc print data=sorted_cars;
    by MSRP;
run;


/* Advance Options 
   Advance Commands with PROC PRINT
*/ 

* Group by variables with BY statement;
proc sort data=sashelp.cars out=sorted_cars;
    by Type;
run;

proc print data=sorted_cars;
    by Type;
run;

*Add title an foodnote;
title "List of Cars by Make and Model by SASify";
footnote "Data Source: SASHELP.CARS";

proc print data=sashelp.cars;
    var Make Model Type MSRP;
run;

title;
footnote;


*Change Labels;
proc print data=sashelp.cars label;
    label MSRP = "Manufacturer's Suggested Retail Price";
    var Make Model Type MSRP;
run;

* Split Long Labels into Multiple Lines;
proc print data=sashelp.cars label split="*";
    label MSRP = "Manufacturer's*Suggested Retail Price";
    var Make Model Type MSRP;
run;

*Apply Formats;
proc print data=sashelp.cars;
    format MSRP dollar10. MPG_City MPG_Highway 5.1;
    var Make Model Type MSRP MPG_City MPG_Highway;
run;


*Style with ODS (HTML, PDF, RTF output);
ods html file="cars.html" style=statistical;
proc print data=sashelp.cars;
    var Make Model MSRP;
run;
ods html close;


/* Full example with all the elements */ 
ods html file="cars_report.html" style=journal;

proc sort data=sashelp.cars out=sorted_cars;
    by Type MSRP;
run;

title "Detailed Cars Report by Type";
footnote "Generated on %sysfunc(date(), worddate.)";

proc print data=sorted_cars label split="*" noobs;
    id Make;
    by Type;
    where MSRP > 30000;
    var Make Model Type MSRP MPG_City MPG_Highway;
    label MSRP = "Manufacturer's*Suggested Retail Price"
          MPG_City = "City MPG"
          MPG_Highway = "Highway MPG";
    format MSRP dollar10. MPG_City MPG_Highway 5.1;
run;

title;
footnote;
ods html close;

