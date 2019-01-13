libname kid "G:\kidtx_nstemi\data";
libname kid2 "G:\kidtx_nstemi\";

* overall procedures done;
data work.tog_nmod;
	set kid2.tog_nmod;
run;

* determine intervention as cabg or pci;
data work.tog_nmod;
	set work.tog_nmod;
	inter = 0;

	if cabg = 1 or pci = 1 then
		inter = 1;
run;

proc freq data=tog_nmod;
	table cabg pci inter;
run;

* create interventions done for entire cohort;
proc surveyfreq data=tog_nmod;
	cluster hospid;
	strata nis_stratum;
	weight discwt;

	table cangio / cl;
run;

proc surveyfreq data=tog_nmod;
	cluster hospid;
	strata nis_stratum;
	weight discwt;

	table inter/ cl;
run;

proc surveyfreq data=tog_nmod;
	cluster hospid;
	strata nis_stratum;
	weight discwt;

	table pci / cl;
run;

proc surveyfreq data=tog_nmod;
	cluster hospid;
	strata nis_stratum;
	weight discwt;

	table cabg / cl;
run;

proc surveyfreq data=tog_nmod;
	* coronary angiogram acc to cohort;
	cluster hospid;
	strata nis_stratum;
	weight discwt;

	table renaltx * cangio / cl or chisq row;
run;

proc surveyfreq data=tog_nmod;
	* pci acc to cohort;
	cluster hospid;
	strata nis_stratum;
	weight discwt;

	table renaltx * pci / cl or chisq row;
run;

proc surveyfreq data=tog_nmod;
	* cabg acc to cohort;
	cluster hospid;
	strata nis_stratum;
	weight discwt;

	table renaltx * cabg / cl or chisq row;
run;

* create cohort for age < 50 consisting of young adults;
data work.young;
	set work.tog_nmod;
	where age < 51;
run;

proc univariate data=young;
	var age;
run;

proc surveyfreq data=young;
	* pci acc to cohort;
	cluster hospid;
	strata nis_stratum;
	weight discwt;

	table renaltx * pci / cl or chisq row;
run;

proc surveyfreq data=young;
	* cabg acc to cohort;
	cluster hospid;
	strata nis_stratum;
	weight discwt;

	table renaltx * cabg / cl or chisq row;
run;

data pci;
	input year $ treatment $ count @@;
	datalines;
2007  	pci_yes   111577  2007 pci_no 27707  2008 pci_yes 124089 2008 pci_no 304354 2009 pci_no 278871 
2009 pci_yes 121351 2010 pci_yes 112312  2010 pci_no 	283355 2011	pci_yes    128264	  2011 pci_no  304580 2012	pci_yes  142685	
2012 pci_no  323350 2013	pci_yes  144615	2013 pci_no 315000 2014	pci_yes 149820	 2014 pci_no 316000 2015	pci_yes 71010  2015 pci_no 	151710
;

data pci2;
input year$ treatment$ count;
cards;

2007 yes 111577
2007 no 277007
2008 yes 124089
2008 no 304354
2009 yes 121351
2009 no 278871
2010 yes 112312
2010 no 283355
2011 yes 128264
2011 no 304580
2012 yes 142685
2012 no 323350
2013 yes 144615
2013 no 315000
2014 yes 149820
2014 no 316000
2015 yes 71010
2015 no 151710
;

data kid.pci_overall;
	set work.pci;
run;

proc freq data = pci2;
	weight count;
	tables year * treatment / trend cmh chisq nocol;
run;

* get the tog_nmod data;
* cabg procedures for NSTEMI per year;
data work.tog_nmod;
	set kid2.tog_nmod;
run;

proc surveyfreq data = tog_nmod;
	cluster hospid;
	strata nis_stratum;
	weight discwt;

	table year * cabg;
run;

* create table for trend analysis;
data cabg;
	input year $ treatment $ count;
	datalines;

2007 yes  34231
2007  no   354418
2008 yes  37240
2008 no  391203
2009 yes 36682
2009 no 363539
2010 yes 32459
2010 no 363208
2011 yes 34058
2011 no 398786
2012 yes 38635
2012 no 427400
2013 yes 39165
2013 no 420450
2014 yes 40325
2014 no 425495
2015 yes 18230
2015 no 204490
;

* save cabg in folder;
data kid.cabg;
	set work.cabg;
run;

* trend analysis for cabg;
proc freq data=cabg;
	weight count;

	table year * treatment / nopct nocol chisq trend;
run;

* trend analysis for reperfusion;
proc surveyfreq data=tog_nmod;
	cluster hospid;
	strata nis_stratum;
	weight discwt;

	table year * reperf / row chisq;
run;

* create dataframe for reperfusion data overall;
data reperf;
	input year $ treatment $ count @@;
	datalines;

2007 no 243960 2007 yes 144689 2008 no 268368 2008 yes 160075 2009 no 243407 2009 yes 156815 2010 no 251973 2010 yes 143694
2011 no 271616 2011 yes 161229 2012 no 285880 2012 yes 180155 2013 no 277050 2013 yes 182565 2014 no 276820 2014 yes 189000 2015 no 133990 2015 yes 88730
;

* save reperf data;
data kid.reperf;
	set work.reperf;
run;

proc freq data=reperf;
	weight count;

	table year * treatment / trend nocol;
run;

proc surveyfreq data=tog_nmod;
	cluster hospid;
	strata nis_stratum;
	weight discwt;

	table year * died /row;
run;

data died;
	input year $ died $ count @@;
	datalines;

2007 yes 19428 2007 no 369175 2008 yes 22447 2008 no 405880 2009 yes 20346 2009 no 379749 2010 yes 20580 2010 no 374959 
2011 yes 22782 2011 no 709336 2012 yes 23510 2012 no 442450 2013 yes 22755 2013 no 436715 2014 yes 23135 2014 no 442485
2015 yes 10680 2015 no 211905
;

* save died dataframe to folder;
data kid.died;
	set work.died;
run;

proc freq data=died;
	weight count;

	table year * died / trend;
run;

proc contents data=tog_nmod;
run;

proc freq data=tog_nmod;
	table zipinc_qrtl;
run;

proc freq data=tog_nmod;
	table chf cm_dm cm_dmcx cm_obese cm_htn_c cm_wghtloss insu race_n insu female inter priorcabg priicd priorpci;
run;

proc freq data=tog_nmod;
	table race race_n;
run;

* proc surveylogistic for determining OR for intervention after NSTEMI;
proc surveylogistic data=tog_nmod;
	class  carotid(ref = "0") chf(ref = "0") cm_dm(ref = "0") cm_dmcx(ref = "0") cm_htn_c(ref = "0") cm_obese(ref = "0") cm_wghtloss(ref = "0") female(ref = "0")
		priicd(ref = "0") priorcabg(ref = "0") priorpci(ref = "0") priorst(ref = "0")  renaltx(ref = "0") inter/ param=GLM;
	model inter(event = "1") = age carotid chf cm_dm cm_dmcx cm_htn_c cm_obese cm_aids cm_wghtloss female priicd priorcabg priorpci priorst  renaltx;
	cluster hospid;
	strata nis_stratum;
	weight discwt;
run;

* proc surveylogistic for PCI;
proc surveylogistic data=tog_nmod;
	class  carotid(ref = "0") chf(ref = "0") cm_dm(ref = "0") cm_dmcx(ref = "0") cm_htn_c(ref = "0") cm_obese(ref = "0") cm_wghtloss(ref = "0") female(ref = "0")
		priicd(ref = "0") priorcabg(ref = "0") priorpci(ref = "0") priorst(ref = "0")  renaltx(ref = "0") pci/ param=GLM;
	model pci(event = "1") = age carotid chf cm_dm cm_dmcx cm_htn_c cm_obese cm_aids cm_wghtloss female priicd priorcabg priorpci priorst  renaltx;
	cluster hospid;
	strata nis_stratum;
	weight discwt;
run;

* CABG;
proc surveylogistic data=tog_nmod;
	class  carotid(ref = "0") chf(ref = "0") cm_dm(ref = "0") cm_dmcx(ref = "0") cm_htn_c(ref = "0") cm_obese(ref = "0") cm_wghtloss(ref = "0") female(ref = "0")
		priicd(ref = "0")  priorpci(ref = "0") priorst(ref = "0")  renaltx(ref = "0") cabg/ param=GLM;
	model cabg(event = "1") = age carotid chf cm_dm cm_dmcx cm_htn_c cm_obese cm_aids cm_wghtloss female priicd  priorpci priorst  renaltx;
	cluster hospid;
	strata nis_stratum;
	weight discwt;
run;

* predictors for intervention in patients with renatx;
proc surveylogistic data=tog_nmod;

	class  carotid(ref = "0") chf(ref = "0") cm_dm(ref = "0") cm_dmcx(ref = "0") cm_htn_c(ref = "0") cm_obese(ref = "0") cm_wghtloss(ref = "0") female(ref = "0")
		priicd(ref = "0") priorcabg(ref = "0") priorpci(ref = "0") priorst(ref = "0") insu(ref = "1") inter race_n(ref = "1") / param=GLM;
	model inter(event = "1") = age carotid chf cm_dm cm_dmcx cm_htn_c cm_obese cm_wghtloss female priicd priorcabg priorpci priorst insu race_n;
	cluster hospid;
	strata nis_stratum;
	weight discwt;
	where renaltx = 1;
run;

proc surveyfreq data=tog_nmod;
	cluster hospid;
	strata nis_stratum;
	weight discwt;

	table renaltx * died / chisq row or cl;
run;

proc surveymeans data=tog_nmod;
	cluster hospid;
	strata nis_stratum;
	weight discwt;
	domain renaltx;
	var los;
run;

proc surveyreg data=tog_nmod;
	cluster hospid;
	strata nis_stratum;
	weight discwt;
	class renaltx;
	model los = renaltx;
run;

* died during hospitalization;
proc surveyfreq data=tog_nmod;
	cluster hospid;
	strata nis_stratum;
	weight discwt;

	table renaltx * died / or cl row chisq;
run;

* logistic regression to determine predictors of mortality in patients who had prior renal tx;
proc surveylogistic data=tog_nmod;

	class  died  chf(ref = "0") cm_dm(ref = "0") cm_dmcx(ref = "0") cm_htn_c(ref = "0") cm_obese(ref = "0") cm_wghtloss(ref = "0") female(ref = "0")
		priicd(ref = "0") priorcabg(ref = "0") priorpci(ref = "0") priorst(ref = "0") insu(ref = "1") inter(ref = "0") race_n(ref = "1") / param=GLM;
	model died(event = "1") = age chf cm_dm cm_dmcx cm_htn_c cm_obese cm_wghtloss female priorcabg priorpci priorst  inter;
	cluster hospid;
	strata nis_stratum;
	weight discwt;
	where renaltx = 1;
run;

* create dataframe for only renaltx patients to determine if there are any trends over the years of study;
data work.renonly;
	set work.tog_nmod;
	where renaltx = 1;
run;

proc freq data=renonly;
	table renaltx;
run;

* interventions done per year in the renaltx cohort;
proc surveyfreq data=renonly;
	cluster hospid;
	strata nis_stratum;
	weight discwt;

	table year * inter / row chisq cl;
run;

* died per year in the renal tx cohort;
proc surveyfreq data=renonly;
	cluster hospid;
	strata nis_stratum;
	weight discwt;

	table year * died / row chisq cl;
run;

proc contents data=tog_nmod;
run;

proc freq data=tog_nmod;
	table hosp_bedsize hosp_locteach hosp_region;
run;

************ 01/13/2019 ******** further data analysis;
* coronary angiogram = cangio + pci;

data tog_nmod;
set tog_nmod;
cor_ang = 0;
if pci = 1 or cangio = 1 then cor_ang = 1;
run;
* coronary angiogram and renaltx cohort;

proc surveyfreq data=tog_nmod;

cluster hospid;
strata nis_stratum;
weight discwt;

table cor_ang/ row cl;
run;

* coronary angiogram according to renal tx;


proc surveyfreq data=tog_nmod;

cluster hospid;
strata nis_stratum;
weight discwt;

table renaltx * cor_ang / row cl chisq or;
run;

proc surveylogistic data=tog_nmod; * logistic regression model for coronary angiogram according to renal tx;

	class  carotid(ref = "0") chf(ref = "0") cm_dm(ref = "0") cm_dmcx(ref = "0") cm_htn_c(ref = "0") cm_obese(ref = "0") cm_wghtloss(ref = "0") female(ref = "0")
		priicd(ref = "0") priorcabg(ref = "0") priorpci(ref = "0") priorst(ref = "0") insu(ref = "1") inter race_n(ref = "1") / param=GLM;

	model cor_ang(event = "1") = age  renaltx carotid chf cm_dm cm_dmcx cm_htn_c cm_obese cm_wghtloss female priicd priorcabg priorpci priorst insu race_n;
	cluster hospid;
	strata nis_stratum;
	weight discwt;

run;

proc contents data=tog_nmod;
run;
