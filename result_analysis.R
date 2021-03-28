#!/usr/bin/env Rscript

library(ggplot2)

#This script is the foundation to future analysis on the HSRD data

#it reads in the data file created from the HSRDcalculator script

#One of the potential erros that occur is the duplication of the data
#This happens when the HSRDcalculator is excuted twice on the same file as everytime the calculator is excuted it writes in the data regardless if it's already there

dataSet <- read.table('HSRdata.txt',header = FALSE)
colnames(dataSet)<-c('HSRD','dates')
 
avgHSRD <- mean(dataSet$HSRD)

#A plotting function to look display the running history including the average too

p1 <- ggplot(dataSet,aes(x=dates,y=HSRD))+
geom_point(shape=21, color="black", fill="#69b3a2", size=6)+
geom_hline(yintercept = avgHSRD, color="blue")+
#geom_text(aes(x=avgHSRD, label=paste0("Mean\n",avgHSRD)))+
ggtitle("HighSpeedRunningHistory")
plot(p1)

