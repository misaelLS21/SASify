proc print data=sashelp.cars(obs=10);
run;

/* proc frequence method in SAS*/
proc freq data=sashelp.cars;
run;


proc print data=sashelp.air(obs=30);
run;