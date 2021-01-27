#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
numargs <- length(args)
enumargs <- 1
if(numargs != enumargs) {
   print("Only need 1 gpx file")
   stop("Stopping right here")
}

library(geosphere)
#install.packages('DescTools')
library(DescTools)
#install.packages('plotKML')
library(plotKML)
library(ggplot2)


#GPXd<-readGPX(args)
GPXd<-readGPX('18_01_21.gpx')
gpsD<-GPXd$tracks[[1]]$`County Dublin Soccer`
gpsD$time<-StrExtract(gpsD$time,"\\d\\d:\\d\\d:\\d\\d")
gpsD$time<-as.POSIXct(gpsD$time,format='%H:%M:%S') #formatting time

#distm(c(-6.41654326580464839935302734375, 53.29884253442287445068359375), c(-6.4164885319769382476806640625, 53.2988916523754596710205078125), fun = distHaversine)

#distm(c(-6.200409412961912, 53.29645625), c(-6.4164885319769382476806640625, 53.2988916523754596710205078125), fun = distHaversine)


#1 Need function to calculate distance between 2 points
#2 Need to calculate time taken to get from one point to the next
#3 Need to divide distance by time to get speed


#Practice Data
#points <- data.frame('long'= c(-6.41654326580464839935302734375, -6.4164885319769382476806640625,-6.4164650626480579376220703125,-6.41646229662001132965087890625), 'lat' =  c(53.29884253442287445068359375,53.2988916523754596710205078125,53.29889751970767974853515625,53.298875726759433746337890625), 'time' = c('12:32:27','12:32:30','12:32:34','12:32:35'))
#points[,3] <- as.POSIXct(points[,3],format='%H:%M:%S') #formatting time

#Functions to calculat Time differece between position a and b (Tab), distance between a and b (Dab), a = first position and b = second position, Sab is the speed m/s
#Tab<-as.numeric(difftime(points[2,3],points[1,3], units = 'secs'))
#Dab<-distm(c(points[1,1],points[1,2]),c(points[2,1],points[2,2]),fun=distHaversine)
#Sab<-Dab/Tab

#Inorder to apply the distance function without looping through the whole data set need to make matrices with 2 points, distm will take a matrix as an imput

#AB1<-points[1:2,1:2]
#AB2<-points[2:3,1:2]
#pd2 <- list(AB1,AB2)
STD <- data.frame('Distances'=rep(0,dim(gpsD)[1]),'Seconds'=rep(0,dim(gpsD)[1]),'Speed'=rep(0,dim(gpsD)[1]))

#Using the long And Lat to get distances, distm(long1,lat1,long2,lat2)
for (i in c(1:dim(gpsD)[1])){
  
  STD$Distances[i] <- (distm(gpsD[i:(i+1),1:2],fun=distHaversine))[1,2]
  STD$Seconds[i] <- as.numeric(difftime(gpsD$time[i+1],gpsD$time[i], units = 'secs'))[1]
}

STD$Speed <- STD$Distances/STD$Seconds
STD$Times <-gpsD$time#[-length(gpsD$time)]


#Last line is always NA
if(is.na(tail(STD,1))==TRUE){
  STD<-STD[-dim(STD)[1],]
  
}

mn <- 5.5
mx <- max(STD$Speed)
#RoxSD$bracket <- ifelse(RoxSD$Speed>mn&RoxSD$Speed<mx,TRUE,FALSE)
#RoxTS$bracket <- ifelse(RoxTS$Speed>mn&RoxTS$Speed<mx,TRUE,FALSE)
STD$bracket <- ifelse(STD$Speed>mn&STD$Speed<mx,TRUE,FALSE)

result<-sum(STD$Distances[STD$bracket==TRUE])
print(result)

# """
# #Need to approximate all the values, so to have more data
# # use approx function
# #plot(STD$Times,STD$Speed,type='l')# plot very similar to garmin connect
# #plot(STD$Speed,STD$Distances,type='l')# plot speed vs distance, will be usedul for finding HSRD
# mean(STD$Speed) # mean very similar to garmin connect
# mx <- max(STD$Speed) # max on garmin connect is more
# 
# #Problem: How to calculate the distance travelled at 5.5m/s or above?
# #Attempt1: Area under the graph = distance remake, the graph with only speeds above 5.5m/s anything smaller = 0
# #Attempt2: Look at the data and take out all the distances travelled at a certain speed
# #STDx <- approx(STD$Times,STD$Speed)
# #STDx<-data.frame(STDx)
# 
# #plot(STDx$x,STDx$y)
# 
# 
# #Interpolation, makes the data more detailed
# RoxTS<-list()
# #RoxSD<-list()
# #px <-list()
# 
# for(i in c(0:((dim(STD)[1]-1)))){
#   a <- STD[(i+1):(i+2),c(3,4)]
#   b <- approx(a$Times,a$Speed)
#  # y <- STD[(i+1):(i+2),c(1,3)]
#   #z <- approx(y$Speed,y$Distances)
#   
#   RoxTS$Times[((i*50)+1):((i+1)*50)]<-b$x[1:50]
#   RoxTS$Speed[((i*50)+1):((i+1)*50)]<-b$y[1:50]
#   #RoxSD$Speed[((i*50)+1):((i+1)*50)]<-z$x[1:50]
#   #RoxSD$Distances[((i*50)+1):((i+1)*50)]<-z$y[1:50]
# }
# RoxTS<-data.frame(RoxTS)
# #px<-data.frame(px)
# #plot(RoxTS$Times,RoxTS$Speed,type = 'l')
# 
# RoxSD<-list()
# 
# for(i in c(0:((length(STD$Speed)-1)))){
#   #a <- STD[(i+1):(i+2),c(3,4)]
#   #b <- approx(a$Times,a$Speed)
#   y <- STD[(i+1):(i+2),c(1,3)]
#   #print(y)
#   z <- approx(y$Speed,y$Distances)
#   
#   #RoxTS$Times[((i*50)+1):((i+1)*50)]<-b$x[1:50]
#   #RoxTS$Speed[((i*50)+1):((i+1)*50)]<-b$y[1:50]
#   RoxSD$Speed[((i*50)+1):((i+1)*50)]<-z$x[1:50]
#   RoxSD$Distances[((i*50)+1):((i+1)*50)]<-z$y[1:50]
# }
# 
# RoxSD<-data.frame(RoxSD)
# #plot(RoxSD$Speed,RoxSD$Distances,type = 'p')
# 
# 
# #plot(px$Times,px$Speed,type = 'l')
# #ggplot(RoxD)
# #Create the min and max speed bracket and filter data to that speed by creating a true and false column
# mn <- 5.5
# mx <- max(STD$Speed)
# RoxSD$bracket <- ifelse(RoxSD$Speed>mn&RoxSD$Speed<mx,TRUE,FALSE)
# RoxTS$bracket <- ifelse(RoxTS$Speed>mn&RoxTS$Speed<mx,TRUE,FALSE)
# STD$bracket <- ifelse(STD$Speed>mn&STD$Speed<mx,TRUE,FALSE)
# 
# #plot(RoxTS$Times[RoxTS$bracket==TRUE],RoxTS$Speed[RoxTS$bracket==TRUE],type = 'l')
# #plot(RoxSD$Speed[RoxSD$bracket==TRUE],RoxSD$Distances[RoxSD$bracket==TRUE],type = 'p')
# #Only look at the distances from STD, using approx function does not work when wanting to calculate HSRD
# result<-sum(STD$Distances[STD$bracket==TRUE])
# print(result)
# 
# 
# 
# #Use the Area Under the Curve calculation to find the total distance ran in that speed bracket
# #AUC(RoxTS$Times[RoxTS$bracket==TRUE],RoxTS$Speed[RoxTS$bracket==TRUE],type='step')
# """