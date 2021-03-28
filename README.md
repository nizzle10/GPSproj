#High Speed Running Distance Calculator
=======================================

##This project is to measure the high speed runnning distance (HSRD) of an athlete using gps data

###This repository includes 4 scripts:
###*packages.R* - this installs the required packages and must be executed first
###*distance_function.R* - this script contains the code for the HSRD caluclator - **it does not need to be executed**
###*HSRDcalculator.R* - this script once excuted applies the distance function on a gps file - it need **1 argument** - a gps file - which must be a **GPX file** - this script also creats a history of it's executions, saves it in a text file, in a data table format. it includes data of the training and the HSRD
###*result_analysis.R"* - Lastly this script is for analysis purposes, it's output is a pdf file containing a graph of the HSRD history
============================================================================

###Further work to be done on the analysis of the data include;
###A weekly representation of the HSRD
###Acute chronic load ratio calculations
###A comaprison of a rolling average ACLR and an exponentional weighted average model ACLR
============================================================================

###Work can also be done on comparing the accuarcy between garmin and a GPS pod such as STATSport
###It needs to be understood that gps pds are more acccuarte as take the gps location every 0.1 sec. 
###Where as garmin takes it every 1 sec. 
###**IMPORTANT** this needs to be configured sometimes garmins are configured to take the location once it "sees" movement, this will definitely lead to very  inaccurate results
###Due to the rapid direction nature of team sports and the rapid change of accelerations/deccelerations there will be inaccuarcies. By how much is the interesting bit.
###When training is on a bigger pitch it will yield more accuarate results, or when there is a lot of HSRD covered by an athlete



