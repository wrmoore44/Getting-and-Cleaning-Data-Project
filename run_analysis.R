# import the data 
features <- read.table("features.txt")
activityLabels <- read.table("activity_labels.txt")
subjectTest <- read.table("./test/subject_test.txt")
xTest <- read.table("./test/x_test.txt")
yTest <- read.table("./test/y_test.txt")
subjectTrain <- read.table("./train/subject_train.txt")
xTrain <- read.table("./train/x_train.txt")
yTrain <- read.table("./train/y_train.txt")

# add column names
names(activityLabels) <- c('activity','activityDesc')
names(subjectTest) <- "subject"
names(xTrain) <- features[,2] 
names(yTrain) <- "activity"
names(subjectTrain) <- "subject"
names(xTest) <- features[,2] 
names(yTest) <- "activity"

# make the consolidated data
test <- cbind(yTest,subjectTest,xTest)
training <- cbind(yTrain,subjectTrain,xTrain)
total <- rbind(test, training)

#subset to leave features with mean or std
theNames <- names(total)
indx <- (grepl('activity', theNames) | grepl('subject', theNames) | grepl('mean', theNames) | grepl('Mean', theNames) | grepl('std', theNames))           
subTotal <- total[indx]

#add activity descriptions and clean feature names
subTotalwithDesc <- merge(subTotal,activityLabels,by='activity',all.x=TRUE)
theNames <- names(subTotalwithDesc)
for (i in 1:length(theNames)) 
{
  theNames[i] <- gsub("\\()","",theNames[i])
  theNames[i] <- gsub("-std","StandardDeviation",theNames[i])
  theNames[i] <- gsub("-mean","Mean",theNames[i])
  theNames[i] <- gsub("-","",theNames[i])
  theNames[i] <- gsub("^(t)","Time",theNames[i])
  theNames[i] <- gsub("^(f)","Frequency",theNames[i])
  theNames[i] <- gsub("tBody","TimeBody",theNames[i])
}
names(subTotalwithDesc) = theNames

# Create a second tidy dataset
dataSet <- subTotalwithDesc[,names(subTotalwithDesc) != "activityDesc"]
dataSet2  <- aggregate(dataSet[,names(dataSet) != c('activity','subject')],by=list(activity=dataSet$activity,subject = dataSet$subject),mean)
dataSet2    = merge(dataSet2,activityLabels,by='activity',all.x=TRUE)

#export the "average" data set
write.table(dataSet2,"dataSetTidy.txt", row.name=FALSE)
