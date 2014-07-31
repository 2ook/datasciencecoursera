#load necessary libraries and set working directory
library(reshape2)
library(ggplot2)
getwd()
setwd("./Tony Bredehoeft/Coursera/Data Science Specialization/Exploratory Data Analysis")

#loaded PM2.5 data sets
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#reshaping data to get values from Baltimore for each emission source
Balt <- NEI[NEI$fips == '24510',]
Balt.melt <- melt(Balt,id=c("year","type"),measure.vars="Emissions")
Balt.dcast <- dcast(Balt.melt, year + type ~ variable,sum)

#creating plot 3
png(file="./Course Assignment 2/plot3.png",width=600)
ggplot(Balt.dcast,aes(year,Emissions)) + geom_line(aes(color=type)) + geom_point(aes(color=type),size=3,shape=15) + ylab("Emissions (in tons)") + xlab("Year") + ggtitle(expression('PM'[2.5]*' Emission Sources in Baltimore'))
dev.off()