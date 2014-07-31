#load necessary libraries and set working directory
library(reshape2)
library(ggplot2)
getwd()
setwd("./Tony Bredehoeft/Coursera/Data Science Specialization/Exploratory Data Analysis")

#loaded PM2.5 data sets
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#getting emissions data from vehicles
vehicle.rows <- which(grepl("[V]ehicle",SCC$EI.Sector))
vehicle.values <- SCC$SCC[vehicle.rows]
vehicle.table <- NEI[NEI$SCC %in% vehicle.values,]

#Getting Baltimore vehicle data and reshaping for analysis
Balt.vehicle <- vehicle.table[vehicle.table$fips == '24510',]
Balt.vehicle.melt <- melt(Balt.vehicle,id=c("year"),measure.vars="Emissions")
Balt.vehicle.dcast <- dcast(Balt.vehicle.melt, year ~ variable,sum)

#creating plot 5
png(file = "./Course Assignment 2/plot5.png")
plot(Balt.vehicle.dcast$year,Balt.vehicle.dcast$Emissions,type="b",pch=15,col="red",main=expression('Total Baltimore PM'[2.5]*' Vehicle Emissions'),ylab="Emissions (in tons)",xlab="Year")
text(Balt.vehicle.dcast$year,Balt.vehicle.dcast$Emissions,pos=c(4,2,3,3),labels=Balt.vehicle.dcast$year)
dev.off()