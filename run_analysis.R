#run_analysis.R

#GettingAndCleaningData Course Project

#Per assignment, his script  
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 




##Read in the activity decoder
activityLabelsFile <- paste(topDir, "activity_labels.txt", sep="/")
activityLabels <- read.table(activityLabelsFile)
activityLabels <- activityLabels$V2  #make vector

##Read in the measurement decoder
featuresFile <- paste(topDir, "features.txt", sep="/")
features <- read.table(featuresFile)
features <- features$V2 #extract vector
hasMean <- grepl("mean", features, ignore.case=T)
hasStd <- grepl("std", features, ignore.case=T)
hasMeanOrStd <- hasMean | hasStd  #logical vector which represents which indices have 'mean' or 'std' in their name


#For quick development, allow small number of data rows
#readIn <- 100
readIn <- -1  #default - read all data

topDir <- "UCI HAR Dataset"
if (!file.exists(topDir)) {stop("Can't find directory 'UCI HAR Dataset' in working directory")}

##
#Read in training data
##
#subjects
trainSubjectFile <- paste(topDir, "train", "subject_train.txt", sep="/")
if (!file.exists(trainSubjectFile)) {stop(paste("Can't find file ",  trainSubjectFile)) }
trainSubject <- read.table(trainSubjectFile, nrows=readIn)
colnames(trainSubject) <- "Subject"

#activities
trainLabelFile <- paste(topDir, "train", "y_train.txt", sep="/")
if (!file.exists(trainLabelFile)) {stop(paste("Can't find file ",  trainLabelFile)) }
trainActivityLabel <- read.table(trainLabelFile, nrows=readIn)
colnames(trainActivityLabel) <- "Activity"
#now replace the numeric activities with their names
trainActivityLabel$Activity <- activityLabels[trainActivityLabel[, "Activity"]]

#measurements
trainSetFile <- paste(topDir, "train", "X_train.txt", sep="/")
if (!file.exists(trainSetFile)) {stop(paste("Can't find file ",  trainSetFile)) }
trainSet <- read.table(trainSetFile, nrows=readIn)
colnames(trainSet) <- features
#now select for only measurements which have "mean" or "std" in the name (per the hasMeanOrStd vector)
trainMeanStdSet <- trainSet[, which(hasMeanOrStd) ]

##
#debugging - verify the data selection makes sense
#trainCheck <- rbind(hasMean, hasStd, hasMeanOrStd, trainSet)
#write.csv(trainCheck, "trainCheck.csv")
#write.csv(trainMeanStdSet, "trainMeanStdSet.csv")
##

#now bind the subjects, activities and measurements
allTrain <- cbind(trainSubject, trainActivityLabel, trainMeanStdSet)


##
#Read in all test data
##

#subjects
testSubjectFile <- paste(topDir, "test", "subject_test.txt", sep="/")
if (!file.exists(testSubjectFile)) {stop(paste("Can't find file ",  testSubjectFile)) }
testSubject <- read.table(testSubjectFile, nrows=readIn)
colnames(testSubject) <- "Subject"

#activities
testLabelFile <- paste(topDir, "test", "y_test.txt", sep="/")
if (!file.exists(testLabelFile)) {stop(paste("Can't find file ",  testLabelFile)) }
testActivityLabel <- read.table(testLabelFile, nrows=readIn)
colnames(testActivityLabel) <- "Activity"
#now replace the numeric activities with their names
testActivityLabel$Activity <- activityLabels[testActivityLabel[, "Activity"]]

#measurements
testSetFile <- paste(topDir, "test", "X_test.txt", sep="/")
if (!file.exists(testSetFile)) {stop(paste("Can't find file ",  testSetFile)) }
testSet <- read.table(testSetFile, nrows=readIn)
colnames(testSet) <- features
#now select for only measurements which have "mean" or "std" in the name (per the hasMeanOrStd vector)
testMeanStdSet <- testSet[, which(hasMeanOrStd) ]  

#now bind the subjects, activities and measurements
alltest <- cbind(testSubject, testActivityLabel, testMeanStdSet)


#now put them all together
#This is the final train, test data combined.
#includes subject, activity (with label).  
#Only measurements which include the terms "mean" or "std" are included
fullData <- rbind(allTrain, alltest)

#Write out the full data (this is likely optional)
write.csv(fullData, "fullData.csv")


#Now collapse the data per subject-activity combo
library(reshape)
fullDataMelt <- melt(fullData, id=c("Subject", "Activity"))
final <- ddply(fullDataMelt, c("Subject", "Activity", "variable"), function(df) mean(df$value))
colnames(final)[3] <- "Variable"
colnames(final)[4] <- "Value"

write.csv(final, "subjectActivitySummary.csv")
#write.table(final, "subjectActivitySummary.txt", row.name=F)