#load necessary libraries and set working directory
library(reshape2)
getwd()
setwd("./Tony Bredehoeft/Coursera/Data Science Specialization/Exploratory Data Analysis")

#loaded PM2.5 data sets
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#reshape data to get PM2.5 totals for Baltimore
Balt <- NEI[NEI$fips == '24510',]
Balt.melt <- melt(Balt,id="year",measure.vars="Emissions")
Balt.dcast <- dcast(Balt.melt,year ~ variable,sum)

#create plot 2
png(file = "./Course Assignment 2/plot2.png")
plot(Balt.dcast$year,Balt.dcast$Emissions,type="b",pch=15,col="red",main=expression('Total PM'[2.5]*' Emissions in Baltimore'),ylab="Emissions (in tons)",xlab="Year")
text(Balt.dcast$year,Balt.dcast$Emissions,pos=c(1,3,3,3),labels=Balt.dcast$year)
dev.off()