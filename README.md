---
title: "README.md"
output: html_document
---


Original Data:
Source data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Source data is organized as a test set and a training set

For each, there are three files
 "subject_[test|train].txt"  - one row per observation, indicates the 'subject' index (1:30)
 "y_[test|train].txt"  - one row per observation, indicates the activity index (1:6)
 "X_[test|train].txt"  - one row per observation, includes 561 measurements per observation, as indicated in the source README.txt, etc...

There are 30 subjects performing 6 kinds of activities
Each observation consists of 561 measurements (of a subject performing an activity)
Total observations for test group:  7352 across the 30 subjects
Total observations for test group:  2947 across the 30 subjects


Assumptions: 
* "reshape" and "plyr" packages are installed
* Data is in working directory
Specifically, the directory "UCI HAR Dataset" should be unzipped and located in the working directory, 
with contents as they were originally organized.


Output:
The final output is the file "subjectActivitySummary.csv".  
Columns are: subject, activity, variable, value (see CodeBook.md for more details)

There is also an intermediate output which has all observations for the test and training subjects
