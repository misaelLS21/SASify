/*---------------------------------------------------------------------------------------
SASify. "Simplifying SAS"
LIBNAME Statement – General Usage
-----------------------------------------------------------------------------------------
Purpose:
    Assigns a library reference (libref) to a data source so it can be accessed in SAS 
    as libref.dataset.

General Syntax:
    libname <libref> <engine> "<source>" <options>;

Common Engines:
| Engine       | Use Case                  | Example                                                  |
|--------------|---------------------------|----------------------------------------------------------|
| BASE         | Folder with SAS datasets  | libname mylib "C:\sasdata";                              |
| XLSX         | Excel (.xlsx) file        | libname myxls xlsx "C:\data.xlsx";                       |
| PCFILES      | Excel without XLSX engine | libname myxls pcfiles path="C:\data.xlsx";               |
| ODBC         | ODBC data sources         | libname mydb odbc dsn="SalesDB" user=me password=pass;   |
| ORACLE       | Oracle databases          | libname myora oracle user=me password=pass path=ORCL;    |
| POSTGRES     | PostgreSQL databases      | libname mypg postgres server=localhost port=5432 user=me |
| CAS (Viya)   | In-memory CAS tables      | libname mycas cas;                                       |

Key Notes:
- Libref names: up to 8 characters, start with a letter, contain letters/numbers/_.
- Use QUOTES for file paths with spaces.
- For databases, SAS/ACCESS to the DB is required.
- In SAS Viya, use CAS engine for cloud in-memory processing.
- Always CLEAR libname after use to release resources.

Clear LIBNAME:
    libname <libref> clear;
---------------------------------------------------------------------------------------*/


/* 1.- LIBNAME Does (General)
- LIBNAME assigns a library reference (libref) to a data source, so you can use it in SAS code like:
--------------------
libname mylib "<path or connection>";
proc print data=mylib.table;
run;
-------------------- 

The source can be:

    A folder with SAS datasets

    An Excel file

    A database (through SAS/ACCESS)

    A cloud source in SAS Viya (CAS library)
*/

libname mylib "<path or connection>";
proc print data=mylib.table;
run;

/* More examples:  */

*1.1 Local Folder (SAS datasets);
libname localdata "C:\sasdata";
    proc contents data=localdata._all_;
    run;

*1.2 Excel File;
libname exceldata xlsx "C:\reports\data1.xlsx";
    proc print data=exceldata.'Sheet1'n;
    run;


*1.3 Database via ODBC;
libname mydb odbc dsn="SalesDB" user=myuser password=mypass;
proc sql;
    select * from mydb.sales;
quit;


*1.4 Database via Native Engine (PostgreSQL example);
libname pgdata postgres
    server=localhost port=5432
    user=myuser password=mypass
    database=mydb;

*1.5 CSV via PROC IMPORT (no direct libname);
    proc import datafile="C:\data.csv" out=mydata dbms=csv replace;
        getnames=yes;
    run;


/* Creating a New LIBNAME in SAS Viya 
   Note: Remember that SAS Viya is SAS in the cloud. Not SAS 9.
*/

*1 Simple CAS LIBNAME;
libname mycas cas; *mycas now points to your CAS session’s in-memory space.;

proc casutil;
    load data=sashelp.cars outcaslib="casuser" casout="cars";
run;


*2 CAS LIBNAME with Server & Caslib;
libname sales cas
    caslib="salesdata" /*CAS library name in Viya environment*/
    server="cas-shared-default" /*CAS server name*/
    port=5570
    sessref=mysession; /*existing CAS session reference*/

proc print data=sales.mytable;
run;
    
/** Clearing a LIBNAME **/
*Always clear when done (avoids file locks);
libname mylib clear;
