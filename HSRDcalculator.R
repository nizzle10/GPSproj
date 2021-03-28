#!/usr/bin/env Rscript

library(geosphere)
library(plotKML)
library(DescTools)
library(ggplot2)

source('distance_function.R')

#Program takes in one argument - the gpx file

args <- commandArgs(trailingOnly = TRUE)
numargs <- length(args)
enumargs <- 1
if(numargs != enumargs) {
  print("Only need 1 gpx file")
  stop("Stopping right here")
}


#print(args)

GPXd<-readGPX(args)
gpsD<-GPXd$tracks[[1]]$`County Dublin Soccer`
dates<-StrExtract(gpsD$time[1],"\\d\\d\\d\\d-\\d\\d-\\d\\d")
times<-StrExtract(gpsD$time,"\\d\\d:\\d\\d:\\d\\d")
gpsD$time<-as.POSIXct(times,format='%H:%M:%S') 

#using the HSRD function

HSRD <- HSRDfunc(gpsD)
print(paste0("High Speed Running Distance covered is: ", HSRD)



# creating a data frame with dates and the accompanying HSRD results, which is then saved in a nomral text file
# this can then be used to do further analysis on the results such as calculated the chronic load or the Acute Chronic load ratio

res <- data.frame(HSRD,dates)

write.table(res,'HSRdata.txt',append = TRUE,row.names = FALSE, col.names = FALSE)
