##########################################################################################################

## Getting and Cleaning Data Course Project
## January 2019

# Questions:

# This script will perform the following steps on the UCI HAR Dataset downloaded from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

##########################################################################################################

rm(list = ls())
library(dplyr)
library(reshape2)

### Set working directory
setwd("D:/016 Coursera 2018/4 Getting and Cleaning Data/Project 4")

# Load activity labels + features
activityLabels <- read.table("activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("features.txt")
features[,2] <- as.character(features[,2])

# Extract only the data on mean & std dev
featuresWanted <- grep(".*mean.*|.*", features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names = gsub('-mean','Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)

# Load the datasets
train_X <- read.table("X_train.txt")[featuresWanted]
train_Y <- read.table("Y_train.txt")
train_Subjects <- read.table("subject_train.txt")
train <- cbind(train_Subjects, train_Y, train_X)

test_X <- read.table("X_test.txt")[featuresWanted]
test_Y <- read.table("Y_test.txt")
test_Subjects <- read.table("subject_test.txt")
test <- cbind(test_Subjects, test_Y, test_X)

# merge datasets and add labels
alldata <- rbind(train,test)
colnames(alldata) <- c("subject", "activity", featuresWanted.names)

# turn activities & subjects into factors
alldata$activity <- factor(alldata$activity, levels = activityLabels[,1], labels=activityLabels[,2])
alldata$subject <- as.factor(alldata$subject)

alldata.melted <- melt(alldata, id=c("subject","activity"))
alldata.mean <- dcast(alldata.melted, subject + activity ~ variable, mean)

write.table(alldata.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
