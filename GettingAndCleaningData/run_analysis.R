#Step 1: Merges the training and the test sets to create one data set
#Step 3: Uses descriptive activity names to name the activities in the data set
#Step 4: Appropriately labels the data set with descriptive variable names

##getwd()
##setwd("./Tony Bredehoeft/Coursera/Data Science Specialization/Getting and Cleaning Data/UCI HAR Dataset")
#fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(fileURL, destfile = "UCI HAR.zip")
library(reshape2)

act.labels <- read.table("activity_labels.txt",colClasses = c("character","character"),col.names = c("activity.class","activity.name"))
features <- read.table("features.txt", colClasses = c("character","character"))

#training data
train <- read.table("./train/X_train.txt",colClasses = c(rep("numeric",561)))
train.labels <- read.table("./train/Y_train.txt",colClasses = c("character"))
train.subject <- read.table("./train/subject_train.txt",colClasses = c("character"))
train.full <- cbind(train,train.labels,train.subject)
colnames(train.full) <- c(features[,2],"activity.class","subject")
train.complete <- merge(train.full,act.labels,by.x = "activity.class",by.y = "activity.class")

#test data
test <- read.table("./test/X_test.txt",colClasses = c(rep("numeric",561)))
test.labels <- read.table("./test/Y_test.txt",colClasses = c("character"))
test.subject <- read.table("./test/subject_test.txt",colClasses = c("character"))
test.full <- cbind(test,test.labels,test.subject)
colnames(test.full) <- c(features[,2],"activity.class","subject")
test.complete <- merge(test.full,act.labels,by.x = "activity.class",by.y = "activity.class")

#full data set
combined.data <- rbind(train.complete,test.complete)

##Step 2: Extract only the measurements on the mean and standard deviation for each measurement

mean.col <- which(grepl("mean",names(combined.data)))
sd.col <- which(grepl("std",names(combined.data)))
combined.data.mean.sd <- combined.data[,c(mean.col,sd.col,563,564)]

#Step 5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject

melted.data <- melt(combined.data.mean.sd,id = c("subject","activity.name"))
tidy.data <- dcast(melted.data, subject + activity.name ~ variable, mean)
write.table(tidy.data, "UCI_Har_Tidy.txt")
