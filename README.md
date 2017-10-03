
## Getting_and_Cleaning_Data_Project

The purpose of this project is to demonstrate ability to collect, work with and clean data set.
The goal is to prepare tidy data that can be used for later analysis with a script run_analysis.R.
This R script does the following things:

1) Creates new folder "week4.project" on the PC, download data from UC Irvine Machine Learning Repository (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) and unzip the file in the created folder.

2) Reads activity labels data (y), assigns them to "y.test" and "y.train" and merges the training and the test sets to create one data set:"activity_type", checks results in a dataframe.

3) Reads activity labels, changes them as.factor and appropriately labels the data set with descriptive activity names. Checks the result in a dataframe.

4) Reads subject data (x), assigns them in "subject.test", "subject.train" and binds them in one dataset "subject".

5) Creates a colname "subject", checks the results in a dataframe and cleans the environment before starting work with features. 

6) Reads "test" and "train" data collected from the accelerometer and gyroscope in and bind them together in "features".

7) Reads "features_labels", changes colnames (number 3 in the assignment).

8) Creates a combine data set "combined_dataset" and cleans the environment.

9) Extracts only the measurements on the mean and standart deviation for each measurement and assigns the result to "only_mean_std"

10) Appropriately labels the data set with descriptive variable names.

11) Creates a second, independent tidy data set with the average of each variable and assigns to "final_dataset".

12) Removes all extra columns. 





