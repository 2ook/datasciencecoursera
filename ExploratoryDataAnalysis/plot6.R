#load necessary libraries and set working directory
library(reshape2)
library(ggplot2)
library(lattice)
getwd()
setwd("./Tony Bredehoeft/Coursera/Data Science Specialization/Exploratory Data Analysis")

#loaded PM2.5 data sets
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#getting emissions data from vehicles
vehicle.rows <- which(grepl("[V]ehicle",SCC$EI.Sector))
vehicle.values <- SCC$SCC[vehicle.rows]
vehicle.table <- NEI[NEI$SCC %in% vehicle.values,]

#Getting Comp.vehicleimore and Los Angeles vehicle data and reshaping for analysis
Comp.vehicle <- vehicle.table[vehicle.table$fips %in% c('24510','06037'),]
Comp.vehicle$City <- ifelse(Comp.vehicle$fips == '24510','Comp.vehicleimore','Los Angeles')
Comp.vehicle.melt <- melt(Comp.vehicle,id=c("year","City"),measure.vars="Emissions")
Comp.vehicle.dcast <- dcast(Comp.vehicle.melt,City + year ~ variable,sum)

#creating plot 6
png(file = "./Course Assignment 2/plot6.png",width=800)
xyplot(Emissions ~ year | City,data=Comp.vehicle.dcast,layout=c(2,1),scales = "free",type="b",pch=15,main=expression('Total PM'[2.5]*' Vehicle Emissions'),xlab="Year",ylab="Emissions (in tons)")
dev.off()