
## Getting_and_Cleaning_Data_Project
The purpose of this project is to demonstrate ability to collect, work with and clean data set.
# The goal is to prepare tidy data that can be used for later analysis with a script run_analysis.R.
# This R script does the following things:

## Loads R packages
library(data.table)
library(plyr)
library(dplyr)

## Creates new folder "week4.project", download data from UC Irvine Machine Learning Repository and unzip the file in the created folder.
setwd("C:/")
getwd()
if(!dir.exists("week4.project")){
  dir.create("week4.project")
}
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destfile <- "C:/week4.project/dataset.zip"
download.file(URL, destfile)

## Unzip the folder
setwd("C:/week4.project")
unzip("dataset.zip")

## 1) Merges the training and the test sets to create one data set (activity_type). 
## 1.1) Reads activity labels data (y) 
y.test <- read.table("C:/week4.project/UCI HAR Dataset/test/y_test.txt") 
y.train <- read.table("C:/week4.project/UCI HAR Dataset/train/y_train.txt") 
activity_type <- dplyr::bind_rows(y.test, y.train)

## Checks  results in a dataframe
tbl_df(activity_type)

## 1.2) Reads activity labels data, changes them as.factor and appropriately labels the data set with descriptive activity names.
activity_labels <- read.table("C:/week4.project/UCI HAR Dataset/activity_labels.txt")
activity_labels$V1 <- factor(activity_labels$V1)
activity_labels$V2 <- factor(activity_labels$V2)
activity_type$V1 <- factor(activity_type$V1)
activity_data <- full_join(activity_type, activity_labels, by="V1") 
activitydata_colnames <- as.character(c("activity_labels", "activity_type"))
activity_data <- activity_data %>% setNames(activitydata_colnames)

## Checks results in a dataframe.
tbl_df(activity_data)

## 1.3) Reads subject data (x) and bind them in one dataset
subject.test <- read.table("C:/week4.project/UCI HAR Dataset/test/subject_test.txt") 
subject.train <- read.table("C:/week4.project/UCI HAR Dataset/train/subject_train.txt") 
subject <- dplyr::bind_rows(subject.test, subject.train)

## 1.4) Creates a colname and check results in a dataframe
colnames(subject) <- "subject"
tbl_df(subject)

## Cleans the environment before starting work with features. 
rm(list = ls()[!ls() %in% c("activity_data","subject")])

## 1.5) Reads test and train data collected from the accelerometer and gyroscope and bind them together.
feature.test <- read.table("C:/week4.project/UCI HAR Dataset/test/X_test.txt")
feature.train <- read.table("C:/week4.project/UCI HAR Dataset/train/X_train.txt")
features <- dplyr::bind_rows(feature.test, feature.train)

## 1.6) Reads features_labels and assign features labels as colnames (number 3 in the assignment)
features_labels <- read.table("C:/week4.project/UCI HAR Dataset/features.txt")
features_labels <- as.character(features_labels$V2)
features <- features %>% setNames(features_labels)

## 1.7) Create a combine data set
combined_dataset  <- dplyr::bind_cols(activity_data, subject, features)
combined_dataset

## clean the environment
rm(list = ls()[!ls() %in% ("combined_dataset")])

## 2) Extracts only the measurements on the mean and standart deviation for each measurement
only_mean_std <- select(combined_dataset, matches("activity_type|subject|mean|std"))

## 3) Uses descriptive activity names to name the activities in the data set
## (Done in 1.6))

## 4) Appropriately labels the data set with descriptive variable names
colnames(combined_dataset)
names(combined_dataset) <- gsub("^t","Time", names(combined_dataset))
names(combined_dataset) <- gsub("^f","Frequency", names(combined_dataset))
names(combined_dataset) <- gsub("Acc","Accelerometer", names(combined_dataset))
names(combined_dataset) <- gsub("Gyro","Gyroscope", names(combined_dataset))
names(combined_dataset) <- gsub("Mag","Magnitude", names(combined_dataset))
names(combined_dataset) <- gsub("BodyBody","Body", names(combined_dataset))
names(combined_dataset) <- gsub("-"," ", names(combined_dataset))

## 5) Creates a second, independent tidy data set with the average of each variable 

final_dataset <- aggregate(combined_dataset, by=list(activity = combined_dataset$activity_type, 
                                                     subject = combined_dataset$subject), mean)

## 5.1) Removes all extra columns. 
final_dataset <- subset(final_dataset, ,-c(subject, activity_labels, activity_type))




