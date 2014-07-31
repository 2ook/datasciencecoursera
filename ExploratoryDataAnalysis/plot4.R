#load necessary libraries and set working directory
library(reshape2)
library(ggplot2)
getwd()
setwd("./Tony Bredehoeft/Coursera/Data Science Specialization/Exploratory Data Analysis")

#loaded PM2.5 data sets
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#getting SCC values related to coal consumption
coal.rows <- which(grepl("[cC]oal",SCC$EI.Sector))
coal.values <- SCC$SCC[coal.rows]
coal.table <- NEI[NEI$SCC %in% coal.values,]

#reshaping data to get coal emissions totals for each year
coal.melt <- melt(coal.table,id="year",measure.vars="Emissions")
coal.dcast <- dcast(coal.melt,year ~ variable, sum)

#creating plot 4
png(file = "./Course Assignment 2/plot4.png")
plot(coal.dcast$year,coal.dcast$Emissions,type="b",pch=15,col="red",main=expression('Total Coal PM'[2.5]*' Emissions'),ylab="Emissions (in tons)",xlab="Year")
text(coal.dcast$year,coal.dcast$Emissions,pos=c(1,1,4,2),labels=coal.dcast$year)
dev.off()