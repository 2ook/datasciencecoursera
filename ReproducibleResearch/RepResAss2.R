library(ggplot2)
library(lubridate)
library(plyr)
library(reshape2)
library(gridExtra)
library(lattice)

#reading in the data and processing to fit analysis
data <- read.csv('repdata-data-StormData.csv',stringsAsFactors=FALSE)
names(data) <- tolower(names(data))

#set up date time variables correctly
data$bgn_date <- mdy(sapply(data$bgn_date,gsub,pattern=' 0:00:00',replacement=''))
data$end_date <- mdy(sapply(data$end_date,gsub,pattern=' 0:00:00',replacement=''))

#evaluating how the event type variable is encoded

length(unique(data$evtype))
unique(tolower(data$evtype))
length(unique(tolower(data$evtype)))
sort(unique(tolower(data$evtype)))

unique(data$evtype[grep("H[Ee][Aa][Tt]",data$evtype)])
unique(data$evtype[grep("[Tt][Oo][Rr][Nn][Aa][Dd][Oo]",data$evtype)])

#checking which types of events lead to the greatest number of injuries and fatalities

data[order(data$fatalities,decreasing=TRUE),c('bgn_date','state','evtype','injuries','fatalities')][1:10,]
data[order(data$injuries,decreasing=TRUE),c('bgn_date','state','evtype','injuries','fatalities')][1:10,]

#initializing an adjusted event type variable

data$evtype <- tolower(data$evtype)
data$evtype_adj <- data$evtype

#trying to group the event variables to get an adjusted event type variable

data$evtype_adj[which(grepl("tornado",data$evtype))] <- 'tornado'
data$evtype_adj[which(grepl("heat",data$evtype))] <- 'heat'
data$evtype_adj[which(grepl("warm",data$evtype))] <- 'heat'
data$evtype_adj[which(grepl("blizzard",data$evtype))] <- 'blizzard'
data$evtype_adj[which(grepl("coastal",data$evtype))] <- 'coastal'
data$evtype_adj[which(grepl("cold",data$evtype))] <- 'cold'
data$evtype_adj[which(grepl("dry",data$evtype))] <- 'dry'
data$evtype_adj[which(grepl("wind",data$evtype))] <- 'wind'
data$evtype_adj[which(grepl("flood",data$evtype))] <- 'flood'
data$evtype_adj[which(grepl("freez",data$evtype))] <- 'freeze'
data$evtype_adj[which(grepl("hail",data$evtype))] <- 'hail'
data$evtype_adj[which(grepl("rain",data$evtype))] <- 'rain'
data$evtype_adj[which(grepl("snow",data$evtype))] <- 'snow'
data$evtype_adj[which(grepl("hurricane",data$evtype))] <- 'hurricane'
data$evtype_adj[which(grepl("ice",data$evtype))] <- 'ice'
data$evtype_adj[which(grepl("lightning",data$evtype))] <- 'lightning'
data$evtype_adj[which(grepl("slide",data$evtype))] <- 'slide'
data$evtype_adj[which(grepl("thunderstorm",data$evtype))] <- 'thunderstorm'
data$evtype_adj[which(grepl("sleet",data$evtype))] <- 'sleet'
data$evtype_adj[which(grepl("waterspout",data$evtype))] <- 'waterspout'

#now adding an other category as some have suggested

data$evtype_adj[which(!(data$evtype_adj %in% c('waterspout','sleet','thunderstorm',
                                               'slide','lightning','ice','hurricane',
                                               'snow','rain','hail','freeze','flood',
                                               'wind','dry','cold','coastal','blizzard',
                                               'heat','tornado')))] <- 'other'

table(data$evtype_adj)

#now checking top 30 events by fatalities and injuries with the adjusted event type variable

data[order(data$fatalities,decreasing=TRUE),c('bgn_date','state','evtype_adj','injuries','fatalities')][1:10,]
data[order(data$injuries,decreasing=TRUE),c('bgn_date','state','evtype_adj','injuries','fatalities')][1:10,]

#clean the event type variable, perhaps make a new event type variable

table(data$evtype_adj[data$injuries > 100])

inj_meds <- ddply(data[data$injuries > 100,],.(evtype_adj),summarise,med=median(injuries))
ggplot(data[data$injuries > 100,],aes(evtype_adj,injuries)) + 
  geom_boxplot(aes(fill=factor(evtype_adj))) + 
  geom_text(data=inj_meds,aes(x=evtype_adj,y=med,label=med),size = 3, hjust = -1.5) +
  coord_flip() + 
  xlab('Type of Event') + 
  ylab('Number of Injuries') + 
  ggtitle('Boxplot of Injuries by Event Type')

#comparing boxplots, checking if I like ggplot format best
boxplot(injuries ~ evtype_adj,data=data[data$injuries > 100,],col=factor(evtype_adj))

table(data$evtype_adj[data$fatalities > 10])

fat_meds <- ddply(data[data$fatalities > 10,],.(evtype_adj),summarise,med=median(fatalities))
ggplot(data[data$fatalities > 10,],aes(evtype_adj,fatalities)) + 
  geom_boxplot(aes(fill=factor(evtype_adj))) + 
  geom_text(data=fat_meds,aes(x=evtype_adj,y=med,label=med),size = 3, hjust = -1.5) +
  coord_flip() +
  xlab('Type of Event') + 
  ylab('Number of Fatalities') + 
  ggtitle('Boxplot of Fatalities by Event Type')

#now going to look at what types of events have the greatest economic impact
#first have to start with the exponent/multiplier variables for damage values
#propdmg, propdmgexp, cropdmg, cropdmgexp

table(data$propdmgexp)
table(data$cropdmgexp)

#setting multiplier variables to numeric values for crop damage

data$cropdmgexp_cor <- data$cropdmgexp
data$cropdmgexp_cor[!(data$cropdmgexp %in% c('H','h','K','k','M','m','B','b'))] <- '1'
data$cropdmgexp_cor[data$cropdmgexp == 'H'] <- '100'
data$cropdmgexp_cor[data$cropdmgexp == 'h'] <- '100'
data$cropdmgexp_cor[data$cropdmgexp == 'M'] <- '1000000'
data$cropdmgexp_cor[data$cropdmgexp == 'm'] <- '1000000'
data$cropdmgexp_cor[data$cropdmgexp == 'K'] <- '1000'
data$cropdmgexp_cor[data$cropdmgexp == 'k'] <- '1000'
data$cropdmgexp_cor[data$cropdmgexp == 'B'] <- '1000000000'
data$cropdmgexp_cor[data$cropdmgexp == 'b'] <- '1000000000'

data$cropdmgexp_cor <- as.numeric(data$cropdmgexp_cor)

#doing the same thing for property damage

data$propdmgexp_cor <- data$propdmgexp
data$propdmgexp_cor[!(data$propdmgexp %in% c('H','h','K','k','M','m','B','b'))] <- '1'
data$propdmgexp_cor[data$propdmgexp == 'H'] <- '100'
data$propdmgexp_cor[data$propdmgexp == 'h'] <- '100'
data$propdmgexp_cor[data$propdmgexp == 'M'] <- '1000000'
data$propdmgexp_cor[data$propdmgexp == 'm'] <- '1000000'
data$propdmgexp_cor[data$propdmgexp == 'K'] <- '1000'
data$propdmgexp_cor[data$propdmgexp == 'k'] <- '1000'
data$propdmgexp_cor[data$propdmgexp == 'B'] <- '1000000000'
data$propdmgexp_cor[data$propdmgexp == 'b'] <- '1000000000'

data$propdmgexp_cor <- as.numeric(data$propdmgexp_cor)

#creating a calculation for total economic impact

data$totaldmg <- data$propdmg*data$propdmgexp_cor + data$cropdmg*data$cropdmgexp_cor

#checking the sum of total economic impact by year

data$bgn_year <- year(data$bgn_date)

#melt and dcast to get fatalities and injuries by year

data.melt <- melt(data,id=c('evtype_adj','bgn_year','state'),measure.vars=c('injuries','fatalities','totaldmg'))
data.year.dcast <- dcast(data.melt,bgn_year ~ variable,sum)

#plotting total injuries and fatalities by year

ggplot(data.year.dcast,aes(bgn_year)) + 
  geom_line(aes(y=injuries, color="injuries")) + 
  geom_line(aes(y=fatalities, color="fatalities")) +
  ylab('Number of Injuries and Fatalities') +
  xlab('Year of Weather Event')

#dcast to get injuries and fatalities by state

data.state.dcast <- dcast(data.melt,state ~ variable,sum)

#plotting sum of injuries and fatalities by state

ggplot(data.state.dcast, aes(x=state,y=injuries)) + geom_bar(stat='identity')
ggplot(data.state.dcast, aes(x=state,y=fatalities)) + geom_bar(stat='identity')

#dcast to get total and average economic impact by event type

data.event.mean.dcast <- dcast(data.melt,evtype_adj ~ variable,mean)
data.event.sum.dcast <- dcast(data.melt,evtype_adj ~ variable,sum)

#plotting total and average economic impact

p1 <- ggplot(data.event.sum.dcast, aes(x=evtype_adj,y=totaldmg)) + 
  geom_bar(stat='identity') +
  coord_flip() +
  xlab('Type of Weather Event') +
  ylab('Total Economic Impact') +
  ggtitle('Total Economic Impact of Weather Events')
p2 <- ggplot(data.event.mean.dcast, aes(x=evtype_adj,y=totaldmg)) + 
  geom_bar(stat='identity') +
  coord_flip() +
  xlab('Type of Weather Event') +
  ylab('Average Economic Impact') +
  ggtitle('Average Economic Impact of Weather Events')

grid.arrange(p1,p2,ncol=2)
