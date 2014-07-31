#load necessary libraries and set working directory
library(reshape2)
getwd()
setwd("./Tony Bredehoeft/Coursera/Data Science Specialization/Exploratory Data Analysis")

#loaded PM2.5 data sets
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#reshape data to get total PM2.5 values for each year
NEI.melt <- melt(NEI,id="year",measure.vars="Emissions")
NEI.dcast <- dcast(NEI.melt,year ~ variable,sum)

#create plot 1
png(file="./Course Assignment 2/plot1.png")
plot(NEI.dcast$year,NEI.dcast$Emissions,type="b",pch=15,col="red",main=expression('Total PM'[2.5]*' Emissions'),ylab="Emissions (in tons)",xlab="Year")
text(NEI.dcast$year,NEI.dcast$Emissions,pos=c(1,3,3,3),labels=NEI.dcast$year)
dev.off()