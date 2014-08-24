# Code Book

This code book describes the data transformations conducted on the `UCI HAR Dataset`
for the Getting and Cleaning Data course project.

## Obtaining Raw Data

The input raw data was obtained from a URL provided by the Coursera project 
assignment page:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The raw data was downloaded from the above URL and decompressed into a folder
named `UCI HAR Dataset`. The full, raw data set can be found the root folder of
this repository.

## Structure of Raw Data

The UCI Machine Learning Repository, the publishers of the data set, have also
published a summary of the data set here:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

In addition, the raw data download includes a `README.txt` file explaining the
data format in depth.

Here are the details relevant to this script.

### Observational Data

* Data has been split into training and testing sets; these sets are saved
in the `train` and `test` sub-directories respectively.
* Raw observational data is stored in headerless, fixed-width flat-files:
  * Each file contains observations of 561 variables, one per line.
  * Training data: `train/X_train.txt`
  * Testing data: `test/X_test.txt`
  
### Meta-Data

* The names of the variables reported in each column of the raw data are 
found in `features.txt`
  * This file is space-delimited text.
  * Column 1 contains the column number of the raw data
  * Column 2 contains the feature name associated with that column
* Activity labels for each row of the raw data are saved in `test\Y_test.txt`
and `train\Y_train.txt` for the testing and training sets respectively.
  * These files are a single column with the numeric ID of the activity assigned
to the corresponding row of observations in the raw data
  * The map of numerical activity IDs to names is found in `activity_labels.txt`.
This file is space delimited. Column 1 is the ID, column 2 is the label.
* The subjects (labeled 1-30) associated with each row of the raw data are found in 
`test\subject_test.txt` and `train\subject_train.txt` for the testing and training
data sets respectively.
  * These files are a single column containing the numeric ID of the subject

## Description of the tidy data set

The tidy data set contains the average of all observations of mean or standard
deviations from both the test and train data grouped by subject and activity.
This is saved in `final.txt`. In addition, the combined data set is saved as 
`output.txt`

The columns extracted from the raw data file are those with a feature name ending in
either '-mean()' or '-std()'. The feature names are used as the column header of the
output file with '-mean()' replaced with 'Mean' and '-std()' replaced with 'Std' so
that the file can be consumed as a data.frame in R without R interpreting the column
names as function calls.

Two additional columns are added to the output file in addition to the mean and 
standard deviations columns just described:

* Activity: the activity label for the observation as recorded in `activity_labels.txt`
* Subject: the subject ID for the observation as recorded in the `subject_test.txt` files

This data set is then processed to calculate the mean of each feature for each subject
and each activity. The feature headers remain the same.

## Overview of Data Processing

Here is an outline of the steps taken by run_analysis.R to create the tidy data set.

* Read the features list and select the features of interest.
* Read the raw data tables for the testing and training data sets and extract
only the columns of interest
* Read the subject IDs for each raw data table
* Read the activity IDs for each raw data table and match with the activity
labels
* Bind the subject IDs, activity labels and data set names (TEST or TRAIN) to
the raw data tables
* Name the columns of the raw data tables with the feature names
* combine the raw data tables into a single data.frame named `allDf`
* Write the combined data.frame to `output.txt`
* Process the combined data.frame to calculate the average of each feature
for each subject and activity. In a data.frame named `summaryDf`
* Save the summaryDf data.fraome to `final.txt`
