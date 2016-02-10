# Getting-and-Cleaning-Data-Project
The project materials as part of the course requirements for Coursera's Getting and Cleaning Data.

#Description:

Describes the variables, the data, and transformations used to clean up the data for the Getting and Cleaning Data Course Project.

###Data Set Information:

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

###Attribute Information:

For each record in the dataset it is provided:   
* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.   
* Triaxial Angular velocity from the gyroscope.   
* A 561-feature vector with time and frequency domain variables.   
* Its activity label.   
* An identifier of the subject who carried out the experiment.  

#Data transformations:

The data was provided via a set of txt files which in turn were imported into R via the following section of the script:

### import the data 
features <- read.table("features.txt")   
activityLabels <- read.table("activity_labels.txt")   
subjectTest <- read.table("./test/subject_test.txt")   
xTest <- read.table("./test/x_test.txt")   
yTest <- read.table("./test/y_test.txt")   
subjectTrain <- read.table("./train/subject_train.txt")   
xTrain <- read.table("./train/x_train.txt")   
yTrain <- read.table("./train/y_train.txt")   

Column names were added to the data as follows:

### add column names
names(activityLabels) <- c('activity','activityDesc')   
names(subjectTest) <- "subject"   
names(xTrain) <- features[,2]    
names(yTrain) <- "activity"   
names(subjectTrain) <- "subject"    
names(xTest) <- features[,2]      
names(yTest) <- "activity"    

The various sections of data were then combined to make one complete dataset:

### make the consolidated data
test <- cbind(yTest,subjectTest,xTest)     
training <- cbind(yTrain,subjectTrain,xTrain)    
total <- rbind(test, training)   

Next a subset of the data was created which contains only mean and standard deviation features:

###subset to leave features with mean or std
theNames <- names(total)    
indx <- (grepl('activity', theNames) | grepl('subject', theNames) | grepl('mean', theNames) | grepl('Mean', theNames) | grepl('std', theNames))              
subTotal <- total[indx]    

The column names were expanded and cleaned as follows:

###add activity descriptions and clean feature names
subTotalwithDesc <- merge(subTotal,activityLabels,by='activity',all.x=TRUE)   
theNames <- names(subTotalwithDesc)    
for (i in 1:length(theNames))    
{     
  theNames[i] <- gsub("\\\\()","",theNames[i])    
  theNames[i] <- gsub("-std","StandardDeviation",theNames[i])    
  theNames[i] <- gsub("-mean","Mean",theNames[i])    
  theNames[i] <- gsub("-","",theNames[i])      
  theNames[i] <- gsub("\^(t)","Time",theNames[i])    
  theNames[i] <- gsub("\^(f)","Frequency",theNames[i])    
  theNames[i] <- gsub("tBody","TimeBody",theNames[i])   
}      
names(subTotalwithDesc) = theNames    

Finally a dataset containing the average of each variable for each activity and each subject was made:    

# Create a second tidy dataset
dataSet <- subTotalwithDesc[,names(subTotalwithDesc) != "activityDesc"]    
dataSet2  <- aggregate(dataSet[,names(dataSet) != c('activity','subject')],by=list(activity=dataSet$activity,subject = dataSet$subject),mean)    
dataSet2    = merge(dataSet2,activityLabels,by='activity',all.x=TRUE)    

###Resulting dataset description:

The resulting dataset includes the keys:   
activity - the id of each activity    
subject - the id of each subject    

###the activity descriptions:
WALKING (value 1): subject was walking during the test    
WALKING_UPSTAIRS (value 2): subject was walking up a staircase during the test   
WALKING_DOWNSTAIRS (value 3): subject was walking down a staircase during the test   
SITTING (value 4): subject was sitting during the test   
STANDING (value 5): subject was standing during the test    
LAYING (value 6): subject was laying down during the test   

###and the average of each of the following features by activity and subject:
TimeBodyAccMeanX
TimeBodyAccMeanY
TimeBodyAccMeanZ
TimeBodyAccStandardDeviationX
TimeBodyAccStandardDeviationY
TimeBodyAccStandardDeviationZ
TimeGravityAccMeanX
TimeGravityAccMeanY
TimeGravityAccMeanZ
TimeGravityAccStandardDeviationX
TimeGravityAccStandardDeviationY
TimeGravityAccStandardDeviationZ
TimeBodyAccJerkMeanX
TimeBodyAccJerkMeanY
TimeBodyAccJerkMeanZ
TimeBodyAccJerkStandardDeviationX
TimeBodyAccJerkStandardDeviationY
TimeBodyAccJerkStandardDeviationZ
TimeBodyGyroMeanX
TimeBodyGyroMeanY
TimeBodyGyroMeanZ
TimeBodyGyroStandardDeviationX
TimeBodyGyroStandardDeviationY
TimeBodyGyroStandardDeviationZ
TimeBodyGyroJerkMeanX
TimeBodyGyroJerkMeanY
TimeBodyGyroJerkMeanZ
TimeBodyGyroJerkStandardDeviationX
TimeBodyGyroJerkStandardDeviationY
TimeBodyGyroJerkStandardDeviationZ
TimeBodyAccMagMean
TimeBodyAccMagStandardDeviation
TimeGravityAccMagMean
TimeGravityAccMagStandardDeviation
TimeBodyAccJerkMagMean
TimeBodyAccJerkMagStandardDeviation
TimeBodyGyroMagMean
TimeBodyGyroMagStandardDeviation
TimeBodyGyroJerkMagMean
TimeBodyGyroJerkMagStandardDeviation
FrequencyBodyAccMeanX
FrequencyBodyAccMeanY
FrequencyBodyAccMeanZ
FrequencyBodyAccStandardDeviationX
FrequencyBodyAccStandardDeviationY
FrequencyBodyAccStandardDeviationZ
FrequencyBodyAccMeanFreqX
FrequencyBodyAccMeanFreqY
FrequencyBodyAccMeanFreqZ
FrequencyBodyAccJerkMeanX
FrequencyBodyAccJerkMeanY
FrequencyBodyAccJerkMeanZ
FrequencyBodyAccJerkStandardDeviationX
FrequencyBodyAccJerkStandardDeviationY
FrequencyBodyAccJerkStandardDeviationZ
FrequencyBodyAccJerkMeanFreqX
FrequencyBodyAccJerkMeanFreqY
FrequencyBodyAccJerkMeanFreqZ
FrequencyBodyGyroMeanX
FrequencyBodyGyroMeanY
FrequencyBodyGyroMeanZ
FrequencyBodyGyroStandardDeviationX
FrequencyBodyGyroStandardDeviationY
FrequencyBodyGyroStandardDeviationZ
FrequencyBodyGyroMeanFreqX
FrequencyBodyGyroMeanFreqY
FrequencyBodyGyroMeanFreqZ
FrequencyBodyAccMagMean
FrequencyBodyAccMagStandardDeviation
FrequencyBodyAccMagMeanFreq
FrequencyBodyBodyAccJerkMagMean
FrequencyBodyBodyAccJerkMagStandardDeviation
FrequencyBodyBodyAccJerkMagMeanFreq
FrequencyBodyBodyGyroMagMean
FrequencyBodyBodyGyroMagStandardDeviation
FrequencyBodyBodyGyroMagMeanFreq
FrequencyBodyBodyGyroJerkMagMean
FrequencyBodyBodyGyroJerkMagStandardDeviation
FrequencyBodyBodyGyroJerkMagMeanFreq
angle(TimeBodyAccMean,gravity)
angle(TimeBodyAccJerkMean),gravityMean)
angle(TimeBodyGyroMean,gravityMean)
angle(TimeBodyGyroJerkMean,gravityMean)
angle(X,gravityMean)
angle(Y,gravityMean)
angle(Z,gravityMean)
