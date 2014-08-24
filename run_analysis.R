# Configuration:
library(plyr)

## set debugging = TRUE to print data structures
debugging = FALSE

## Where to save the output
outFp="complete.txt"
summaryFp="summary.txt"

## Raw data directory is 'dataRoot'
dataRoot <- "UCI HAR Dataset"

## The training data set
trainFp <- paste(dataRoot, "/train/X_train.txt", sep="")
## The training data set subject list
trainSubjectFp <- paste(dataRoot, "/train/subject_train.txt", sep="")
## The training data set activity classifications
trainActivityFp <- paste(dataRoot, "/train/y_train.txt", sep="")

## The testing data set
testFp <- paste(dataRoot, "/test/X_test.txt", sep="")
## The testing data set subject list
testSubjectFp <- paste(dataRoot, "/test/subject_test.txt", sep="")
## The testing data set activity classifications
testActivityFp <- paste(dataRoot, "/test/y_test.txt", sep="")

## The activity label file
activityLabelFp <- paste(dataRoot, "/activity_labels.txt", sep="")

## the Features file, contains headers for the testing and training sets.
featuresFp <- paste(dataRoot, "/features.txt", sep="")
featuresDf <- read.table(featuresFp, header = FALSE, sep=" ")

## get the second column containing the feature names
features <- as.vector(featuresDf$V2)
if(debugging){
  features
}

## Task 2: Extract only the the mean and standard deviation
## for each measurement.
# -- Get the columns of interest. They end in -mean() and -std()
# -- Set the data type of the mean and std columns to numeric, and others to NULL
# -- This will tell read.table to skip the unwanted columns for a faster read.
colTypes <- sapply(features, function(feat) {
  if( substr(feat, nchar(feat) - 6, nchar(feat)) == "-mean()" || 
      substr(feat, nchar(feat) - 5, nchar(feat)) == "-std()" ) {
    return("numeric")
  } else {
    return("NULL")
  }
}, USE.NAMES=FALSE)

if(debugging){
  colTypes
}

# -- Use read.table to extract the columns of interest without
# -- Skip columns with NULL in colClasses
testDf<-read.table(testFp, colClasses=colTypes)
trainDf<-read.table(trainFp, colClasses=colTypes)

## Task 3: Use descriptive activity names to name the activities in the data set.
# -- Read in the activity labels for the testing and training sets.
# -- Activity IDs are found in the y_test.txt and y_train.txt files.
# -- Add the activity labels to the test and training sets with cbind later, 
# -- for now save as vectors.
testActivity <- as.vector(read.table(testActivityFp, header=FALSE)$V1)
trainActivity <- as.vector(read.table(trainActivityFp, header=FALSE)$V1)

# -- The map of activity IDs to activity descriptions is found in activity_labels.txt
activityLabels <- read.table(activityLabelFp, header=FALSE)
colnames(activityLabels) <- c("id", "description")

# -- Set vectors of descriptive activity labels by indexing IDs to names
testActNames <- activityLabels$description[testActivity]
trainActNames <- activityLabels$description[trainActivity]


## Task 5b: Label each measurement with the subject id.
## -- Subject IDs are found in test/subject_test.txt and train/subject_train.txt
## -- Read these IDs into vectors
testSubjects <- as.vector(read.table(testSubjectFp, header=FALSE, sep=" ")$V1)
trainSubjects <- as.vector(read.table(trainSubjectFp, header=FALSE, sep=" ")$V1)

## Bind test and train data to subject IDs and activity labels
testDf <- cbind(testDf, testActNames, testSubjects)
trainDf <- cbind(trainDf, trainActNames, trainSubjects)

## Task 4: Appropriately label the data set with descriptive
## variable names.
colNames <- features[colTypes != "NULL"]
# Remove parentheses from column names so that R does not
# mistake the names with function calls
colNames <- gsub("-mean\\(\\)", "Mean", colNames)
colNames <- gsub("-std\\(\\)", "Std", colNames)
colnames(testDf) <- c(colNames, c("Activity", "Subject"))
colnames(trainDf) <- c(colNames, c("Activity", "Subject"))

## Task 1: Merge the training and test data sets.
allDf<-rbind(testDf, trainDf)
allDf$Subject <- factor(allDf$Subject)
allDf$ParentDataSet <- factor(allDf$ParentDataSet)

# --- clean up
rm(testDf)
rm(trainDf)

## Task 5: Create a second, independent tidy data set with
## the average of each variable for each activity and each subject.
summaryDf <- aggregate(allDf[colNames], by=allDf[c("Activity", "Subject")], FUN=mean, simplify=TRUE)

# Save completed data to a new file for use

write.table(allDf, outFp, row.names=FALSE)
write.table(summaryDf, summaryFp, row.names=FALSE)
