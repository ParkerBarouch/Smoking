


		***********************************************************************************;
		***			Author: Parker Barouch				Date: 11/11/17					***;
		***												Last Edited: 12/11/17			***;
		***																				***;
		***									  Title:									***;
		***	 	 A Study of the Causal Effects that drives Students to use Cigaretts	***;
		***																				***;
		***																				***;
		***			Purpose: To predict students probability of smoking to identifey	***;
		***					 key charcteriestics or triggers that cause student to 		***;
		***					 smoke														***;
		***																				***;
		***********************************************************************************;



%let Path = D:\Applied\;

/*%include "&path.Macros.sas";*/ /*have posted the macros used in this project below*/

/*libname pb "D:\Applied\Research Project";*/


%Macro LS(Dataset, DepVar); /*This macro identifys variables who lack variation*/
	proc means data = &Dataset NOPRINT;
		class &DepVar;
		output out = &Dataset._all;
	run;


	data &Dataset._all (Drop = _Type_);
		set &Dataset._all;

		if (_STAT_ = "MIN" or _STAT_ = "MAX") and &DepVar ~= .;
	run;


	proc transpose data = &Dataset._all
		out = &Dataset._all;
	run;


	data &Dataset._all; /*Identifies which variables have the large-small problem and vice-versa*/
		set &Dataset._all (rename = (COL1 = MIN COL2 = MAX COL3 = MIN1 COL4 = MAX1));

		Large_small_I_ind = 0;
		Large_small_O_ind = 0;

		if MAX < MAX1 then
			if MAX < MIN1 then
				Large_small_I_ind = 1;
		else
			if MAX1 < MIN then
				Large_small_O_ind = 1;
	run;


	Data &Dataset._problem; /*Creates a new datset with the problemed variables*/
		set &Dataset._all;

		if Large_small_I_ind = 1 or Large_small_O_ind = 1;
	run;
%Mend LS;


%macro ifm(var, replace_with); /*replaces missing values with user specified numbers*/
	if &var = . then
		&var = &replace_with; 

%mend ifm;



/*Importing the data*/
proc import datafile = "&Path.Research Project\NYTS 2009 Dataset.xlsx"
	out = Survey
	dbms = xlsx;
run;


/*Cleaning data so that it can be used for analysis*/
data clean;
	set Survey;

	Age = qn1 + 8;
	Grade = qn3 + 5;
	

	if qn2 = 2 then
		Male = 1;
	else
		Male = 0;

	if qn4 = 1 then 
		Hispanic = 1;
	else
		Hispanic = 0;

	if qn5a = 1 then 
		AIndian = 1;
	else
		AIndian = 0;

	if qn5b = 1 then 
		Asian = 1;
	else
		Asian = 0;

	if qn5c = 1 then 
		Black = 1;
	else
		Black = 0;

	if qn5d = 1 then
		Hawaiian = 1;
	else
		Hawaiian = 0;

	if qn5e = 1 then
		White = 1;
	else
		White = 0;

	if qn7 = 1 then
		miss = 0;
	else if qn7 = 2 then 
		miss = 1;
	else if qn7 = 3 then 
		miss = 2;
	else if qn7 = 4 then 
		miss = 6;
	else
		miss = 11;

	if qn10 > 2 then
		cig_ind = 1;
	else
		cig_ind = 0;

	if qn38 = 1 then
		otob = 1;
	else
		otob = 0;

	if qn39 = 1 then
		age_otob = 0;
	else
		age_otob = qn39 + 6;

	if qn40 = 1 then
		use_otob = 0;
	else if qn40 = 2 then
		use_otob = 1;
	else if qn40 = 3 then
		use_otob = 3;
	else if qn40 = 4 then
		use_otob = 6;
	else if qn40 = 5 then
		use_otob = 10;
	else if qn40 = 6 then
		use_otob = 20;
	else
		use_otob = 30;

	if qn43 = 1 then
		cigar = 0;
	else if qn43 > 1 then
		cigar = 1;

	if qn44 = 1 then
		day_cigar = 0;
	else if qn44 = 2 then
		day_cigar = 1;
	else if qn44 = 3 then
		day_cigar = 3;
	else if qn44 = 4 then
		day_cigar = 6;
	else if qn44 = 5 then
		day_cigar = 10;
	else if qn44 = 6 then
		day_cigar = 20;
	else if qn44 = 7 then
		day_cigar = 30;

	if qn45 = 1 then
		Pipe = 0;
	else if qn45 > 1 then
		Pipe = 1;

	if qn46 = 1 then
		day_pipe = 0;
	else if qn46 = 2 then
		day_pipe = 1;
	else if qn46 = 3 then
		day_pipe = 3;
	else if qn46 = 4 then
		day_pipe = 6;
	else if qn46 = 5 then
		day_pipe = 10;
	else if qn46 = 6 then
		day_pipe = 20;
	else if qn46 = 7 then
		day_pipe = 30;

	if qn51 = 1 then
		room = 0;
	else if qn51 = 2 then 
		room = 1;
	else if qn51 = 3 then 
		room = 3;
	else if qn51 = 4 then 
		room = 5;
	else if qn51 = 5 then 
		room = 7;

	if qn52 = 1 then
		car = 0;
	else if qn52 = 2 then 
		car = 1;
	else if qn52 = 3 then 
		car = 3;
	else if qn52 = 4 then 
		car = 5;
	else if qn52 = 5 then 
		car = 7;

	if qn52 = 1 then
		harmful = 1;
	else
		harmful = 0;

	if qn52 = 2 then
		pharmful = 1;
	else
		pharmful = 0;

	if qn52 = 3 then
		pnharmful = 1;
	else
		pnharmful = 0;

	if qn52 = 4 then
		nharmful = 1;
	else
		nharmful = 0;

	if qn53 = 1 then 
		live_smoke = 1;
	else
		live_smoke = 0;

	if qn54 = 1 then 
		live_otob = 1;
	else
		live_otob = 0;

	if qn55 < 6 then
		friends_t = qn55 - 1;
	
	if qn55 = 6 or qn55 = . then
		friends_unsure_t = 1;
	else 
		friends_unsure_t = 0;

	if qn56 < 6 then
		friends_otob = qn56 - 1;
	
	if qn56 = 6 or qn56 = . then
		friends_unsure_ot = 1;
	else 
		friends_unsure_ot = 0;

	rule_no = 0;
	rule_s  = 0;
	rule_a  = 0;
	rule_na = 0;
	rule_M  = 0;

	if qn57 = . then
		rule_M = 1;
	else if qn57 = 1 then
		rule_no = 1;
	else if qn57 = 2 then
		rule_s = 1;
	else if qn57 = 3 then
		rule_a = 1;
	else if qn57 = 4 then
		rule_na = 1;

	dy_smoke_y = 0;
	py_smoke_y = 0;
	pn_smoke_y = 0;
	dn_smoke_y = 0;
	na_smoke_y = 0;

	if qn58 = 1 then 
		dy_smoke_y = 1;
	else if qn58 = 2 then
		py_smoke_y = 1;
	else if qn58 = 3 then
		pn_smoke_y = 1;
	else if qn58 = 4 then
		dn_smoke_y = 1;
	else
		na_smoke_y = 1;
		
	dy_smoke_bf = 0;
	py_smoke_bf = 0;
	pn_smoke_bf = 0;
	dn_smoke_bf = 0;
	na_smoke_bf = 0;

	if qn60 = 1 then 
		dy_smoke_bf = 1;
	else if qn60 = 2 then
		py_smoke_bf = 1;
	else if qn60 = 3 then
		pn_smoke_bf = 1;
	else if qn60 = 4 then
		dn_smoke_bf = 1;
	else
		na_smoke_bf = 1;
		
	if qn62 < 4 and qn62 ~= . then
		par_warn = 1;
	else
		par_warn = 0;

	if qn65 > 2 then
		smoke_cool = 1;
	else if qn65 ~= . then
		smoke_cool = 0;

	if smoke_cool = . then
		smoke_cool_m = 1;
	else
		smoke_cool_m = 0;

	say_no_m = 0;

	if qn78 = 1 then
		say_no = 1;
	else if qn78 = 2 then
		say_no = 0;
	else if qn78 = . or qn78 = 3 then
		say_no_m = 1;

	taught_smoke_m = 0;
	if qn81 = 1 then
		taught_smoke_bad = 0;
	else if qn81 = 2 then
		taught_smoke_bad = 1;
	else if qn81 = 3 or qn81 = . then
		taught_smoke_m = 1;
run;
 

/*proc contents data = clean;*/
/*run;*/


/*dropping some unnecesary variables that will not be used in the analysis*/
data clean1 (drop = qn:);
	set clean;
run;


/*Checking the data to make sure it all makes sense*/
proc means n nmiss mean stddev min max data = clean1;
run;


/*data found that has missing values will be replaced*/
data clean2;
	set clean1;
	
	%ifm(Age, 15); /*ie. if age is missing it will be replaced by 15*/
	%ifm(grade, 9);
	%ifm(age_otob, 0)
	%ifm(cigar, 0);
	%ifm(day_cigar, 0);
	%ifm(pipe, 0);
	%ifm(day_pipe, 0);
	%ifm(room, 0);
	%ifm(car, 0);
	%ifm(friends_t, 0);
	%ifm(friends_otob, 0);
	%ifm(smoke_cool, 0);
	%ifm(say_no, 0);
	%ifm(taught_smoke_bad, 0);
run;

/*proc means nmiss;*/
/*run;*/


/*Rechecking the data to make sure it all makes sense*/
proc means data = clean2;
run;


/*some test variables created to add more insight into the analysis*/
data add_var;
	set clean2;

	friends_use = friends_t + friends_otob;

	if age >= 18 then
		legal = 1;
	else
		legal = 0;

	agesq = age**2;

	age_lt18  = age * (age <  18);
	age_gte18 = age * (age >= 18);
run;


/*checks variables for variation when cig_ind = 0 or 1*/
%ls(clean2, cig_ind);


/*independent variables for the probit regression*/
%let Indep = 
	Age
	agesq
/*	Grade*/
/*	Male*/
	Hispanic
/*	AIndian*/
/*	Asian*/
	Black
	White
	miss
/*	otob*/
/*	age_otob*/
/*	use_otob*/
	cigar
	room
/*	car*/
	harmful
	pharmful
/*	pnharmful*/
/*	nharmful*/
	live_smoke
/*	friends_t*/
/*	friends_otob*/
	friends_use
/*	friends_unsure_t*/
/*	friends_unsure_ot*/
	rule_no
	rule_s
	rule_a
/*	rule_na*/
/*	rule_M*/
	dy_smoke_y
/*	py_smoke_y*/
/*	pn_smoke_y*/
	dn_smoke_y
/*	na_smoke_y*/
	dy_smoke_bf
/*	py_smoke_bf*/
/*	pn_smoke_bf*/
	dn_smoke_bf
/*	na_smoke_bf*/
	smoke_cool
/*	say_no_m*//**/

;


proc qlim data = add_var;
	nloptions maxiter = 500;
	model cig_ind = &indep / discrete;
	output out = probit_reg proball;
run;


/*Checks the percentage of correcly predicted predictions*/
data correct;
	set probit_reg;

	if Prob1_cig_ind < Prob2_cig_ind then
		predict = 1;
	else
		predict = 0;

	if cig_ind = predict then
		correct = 1;
	else 
		correct = 0;
run;


proc means mean data = correct;
	class cig_ind;
	var correct;
run;

