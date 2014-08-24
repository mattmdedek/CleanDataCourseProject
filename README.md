This repository contains a single script 'run_analysis.R' which re-factors the 
*UCI Human Activity Recognition Using Smartphones Data Set* in order to satisfy 
the requirements of the course project for the August 2014 session of the Johns
Hopkins Bloomberg School of Public Health *Getting and Cleaning Data* course.

Running the run_analysis.R script will process the data files found in the folder
`UCI HAR Dataset`. It combines the testing and training data sets while
annotating each observation with the subject ID and the activity classification.
The combined data set is then processed to calculate the average of each data point
for each subject and each activity. The combined data is saved in `output.txt`.
The final processed data is saved in `summary.txt`.

See `CodeBook.md` for details.

Reference:
========

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
