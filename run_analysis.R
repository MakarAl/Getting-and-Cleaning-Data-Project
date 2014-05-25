## The following script processes the following data provided on the link below:
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

## Initial preparations are:

setwd("./UCI HAR Dataset")

## The process undergoes the following steps:
## 1. Merges the training and the test sets to create one data set.
## reading two respective tables from test and train folder and merging them with each other
## merged data is test data first and train data second

temp1 <- read.table("./test/subject_test.txt")
temp2 <- read.table("./train/subject_train.txt")
mergedSubject <- rbind(temp1, temp2)

temp1 <- read.table("./test/X_test.txt")
temp2 <- read.table("./train/X_train.txt")
mergedMeasurement <- rbind(temp1, temp2)

temp1 <- read.table("./test/y_test.txt")
temp2 <- read.table("./train/y_train.txt")
mergedLabel <- rbind(temp1, temp2)

remove("temp1", "temp2")

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## reading features.txt, assigning the features vector to the names of the merged measurement 
## dataset, searching for the mean and st. deviation variables and subsetting the measurements
## by these variables, cleaning the names

features <- read.table("features.txt")
names(mergedMeasurement) <- features[,2]
mergedMeasurement <- mergedMeasurement[,grep("mean\\(\\)|std\\(\\)", names(mergedMeasurement))]
names(mergedMeasurement) <- gsub("-|\\(|\\)","",tolower(names(mergedMeasurement)))

## 3. Uses descriptive activity names to name the activities in the data set.
## reading activity labels, cleaning their names, assigning the labels to their numbers stored
## in merged label vector

actlabels <- read.table("activity_labels.txt")
actlabels[,2] <- gsub("_","",tolower(actlabels[,2]))
for (i in 1:nrow(mergedLabel)) {mergedLabel[i,] <- actlabels[mergedLabel[i,],2]}
names(mergedLabel) <- "activity"

## 4. Appropriately labels the data set with descriptive activity names.
## combining the merged subject, label and measurement data, writing it to the file

names(mergedSubject) <- "subject"
mergedDataset <- cbind(mergedSubject, mergedLabel, mergedMeasurement)
write.table(mergedDataset,"merged_dataset.txt")

## 5. Creates a second, independent tidy data set with the average of each variable for each 
##    activity and each subject. 

## Determining the dimensions of the tidy dataset
nRows <- length(unique(mergedDataset$subject)) * length(unique(mergedDataset$activity))
nColumns <- ncol(mergedDataset)

## 6 activities - 30 subjects - 66 variables: resulting dataset is 180 rows deep (6 * 30) and
## 68 columns wide (subject id, activity label and 66 measurement variables) 
## Initializing tidy dataset:
tidyDataset <- data.frame(matrix(nrow = nRows, ncol = nColumns))
names(tidyDataset) <- names(mergedDataset)
tidyDataset$subject <- rep(1:length(unique(mergedDataset$subject)), 
                                                    length(unique(mergedDataset$activity)))
tidyDataset$activity <- rep(unique(mergedDataset$activity), length(unique(mergedDataset$subject)))

## In order to calculate all the appropriate means we need to go over the mergedDataset
## subsetting it by the respective subject and activity and calling colMeans
for (i in 1:nrow(tidyDataset)) {
    reqIndices <- which(mergedDataset$subject == tidyDataset$subject[i] & 
                            mergedDataset$activity == tidyDataset$activity[i])
    tidyDataset[i,3:ncol(tidyDataset)] <- colMeans(mergedData[reqIndices,3:ncol(mergedDataset)])
}

write.table(tidyDataset,"tidy_dataset.txt")

## Cleaning memory and getting back to the initial working directory:
rm(list = ls())
setwd("../") ## getting back to the project folder
print("Merged dataset and tidy dataset are stored in the root directory in files 'merged_dataset.txt'
        and 'tidy_dataset.txt' respectively")