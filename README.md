Getting and Cleaning Data Course Project
=================================

## General info
This repo contains the original "Human Activity Recognition Using Smartphones" dataset sourced from
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones, the run_analysis.R script performing merging and cleaning the raw data as per course project instructions and merged and tidy datasets stored in 'UCI HAR Dataset' folder.

The data was downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

In order to reproduce the cleaning process please pull the local copy of this repository, set the root folder of the project as the working directory in R and run run_analysis.R.
After the script is run 'merged_dataset.txt' and 'tidy_dataset.txt' will appear in the 'UCI HAR Dataset' folder.
Note that the script will run properly regardless of the size and dimension measurements of the raw datasets.

## How the script is performed
Here I provide a quick overview of the steps taken to go through the list of instructions given in this project. These comments are also provided as the code comments in run_analysis.R

The process undergoes the following steps:

1. Merges the training and the test sets to create one data set.
* reading two respective tables from test and train folders and merging them with each other
* note: merged data is test data first and train data second

2. Extracts only the measurements on the mean and standard deviation for each measurement. 
* reading features.txt 
* assigning the features vector to the names of the merged measurement dataset
* searching for the mean and st. deviation variables 
* subsetting the measurements by these variables
* cleaning the names (removing parentheses, dashes etc., converting to lower case)

3. Uses descriptive activity names to name the activities in the data set.
* reading activity labels
* cleaning their names
* assigning the labels to their numbers stored in merged label vector

4. Appropriately labels the data set with descriptive activity names.
* combining the merged subject
* label and measurement data
* writing it to the file 'merged_dataset.txt'

5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

* determining the dimensions of the tidy dataset

6 activities - 30 subjects - 66 variables: resulting dataset is 180 rows deep (6 * 30) and
68 columns wide (subject id, activity label and 66 measurement variables) 

* initializing tidy dataset - creating empty 180x68 data frame
* assigning the subjects and activities
* in order to calculate all the appropriate means we need to go over the mergedDataset subsetting it by the respective subject and activity and calling colMeans
* writing acquired data set in to the file 'tidy_dataset.txt'

Final steps are cleaning memory and getting back to the initial working directory.
