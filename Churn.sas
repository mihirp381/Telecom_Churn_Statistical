
/* Importing the churn dataset */
PROC IMPORT 
    DATAFILE = "H:\HW5\Churn_telecom.csv" 
    OUT = churn
    DBMS = CSV 
    REPLACE;
    GETNAMES = YES;
RUN;
/* Printing the churn dataset */
PROC PRINT DATA = churn (obs = 20);
RUN;

/* Count of missing value in the dataset */

PROC MEANS DATA = churn NMISS;
OUTPUT OUT = missing_value NMISS = ;
RUN;

PROC EXPORT data=missing_value
  OUTFILE='H:\HW5\missing_output.csv'
  DBMS=csv
  REPLACE;
RUN;

/* Means for all the variables when the churn is 0*/
PROC MEANS DATA=churn(WHERE=(churn=0));
OUTPUT OUT=means_data_no_churn mean=;
run;

/* Use PROC EXPORT to create a CSV file- Run once only */
PROC EXPORT data=means_data_no_churn
  OUTFILE='H:\HW5\means_output_no_churn.csv'
  DBMS=csv
  REPLACE;
RUN;

/* Means for all the variables when the churn is 0*/
PROC MEANS DATA=churn(where=(churn=1));
OUTPUT OUT=means_data_churn mean=;
RUN;

/* Use PROC EXPORT to create a CSV file- Run once only */
PROC EXPORT data=means_data_churn
  OUTFILE='H:\HW5\means_output_churn.csv'
  DBMS=csv
  REPLACE;
RUN;

/* Correlation of all the variables in the data */
PROC CORR DATA = churn out = corr_matrix;
RUN;

PROC EXPORT data=corr_matrix
  OUTFILE='H:\HW5\corr_output_churn.csv'
  DBMS=csv
  REPLACE;
RUN;


/* Importing the processed dataset */
PROC IMPORT 
    DATAFILE = "H:\HW5\final_data.csv" 
    OUT = churn_final
    DBMS = CSV 
    REPLACE;
    GETNAMES = YES;
RUN;
/* Printing the churn dataset */
PROC PRINT DATA = churn_final (obs = 20);
RUN;

/* Q.1 Splliting into training and testing data sets */
PROC SURVEYSELECT DATA=churn_final SEED=12345 RAT=0.7
OUT = churn_select OUTALL
METHOD = srs;
RUN;

DATA train_sample test_sample;
SET churn_select;
IF selected = 1 THEN OUTPUT train_sample;
ELSE OUTPUT test_sample;
RUN;

PROC PRINT DATA = train_sample (obs=20);
RUN;

PROC PRINT DATA = test_sample (obs=20);
RUN;

/* Logistic Regression */

PROC LOGISTIC DATA= train_sample DESCENDING; 
MODEL churn = roam_Mean change_mou drop_dat_Mean custcare_Mean threeway_Mean opk_dat_Mean mou_opkd_Mean callfwdv_Mean callwait_Mean mtrcycle eqpdays asl_flag_N prizm_social_one_C prizm_social_one_R prizm_social_one_S prizm_social_one_T area_ATLANTIC_SOUTH_AREA area_CALIFORNIA_NORTH_AREA area_CENTRAL_SOUTH_TEXAS_AREA area_CHICAGO_AREA area_DALLAS_AREA area_DC_MARYLAND_VIRGINIA_AREA area_GREAT_LAKES_AREA area_HOUSTON_AREA area_LOS_ANGELES_AREA area_MIDWEST_AREA area_NEW_ENGLAND_AREA area_NEW_YORK_CITY_AREA area_NORTH_FLORIDA_AREA area_NORTHWEST_ROCKY_MOUNTAIN_AR area_OHIO_AREA area_PHILADELPHIA_AREA area_SOUTH_FLORIDA_AREA area_SOUTHWEST_AREA dualband_N dualband_T dualband_U refurb_new_N hnd_webcap_UNKW hnd_webcap_WC marital_A marital_B marital_M marital_S ethnic_B ethnic_C ethnic_D ethnic_F ethnic_G ethnic_H ethnic_I ethnic_J ethnic_M ethnic_N ethnic_O ethnic_P ethnic_R ethnic_S ethnic_U ethnic_X kid0_2_U creditcd_N car_buy_New;
RUN;
