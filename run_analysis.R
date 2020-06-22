library(dplyr)

###Reading Activity files
ActTest <- read.table("/Users/chaitu/Downloads/UCI HAR Dataset/test/Y_test.txt", col.names = "code")
ActTrain <- read.table("/Users/chaitu/Downloads/UCI HAR Dataset/train/Y_train.txt", col.names = "code")

###Read features files
FeaTest <- read.table("/Users/chaitu/Downloads/UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
FeaTrain <- read.table("/Users/chaitu/Downloads/UCI HAR Dataset/train/X_train.txt", col.names = features$functions)

#Read subject files
SubTest <- read.table("/Users/chaitu/Downloads/UCI HAR Dataset/test/subject_test.txt",  col.names = "subject")
SubTrain <- read.table("/Users/chaitu/Downloads/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

####Read Activity Labels
ActLabels <- read.table("/Users/chaitu/Downloads/UCI HAR Dataset/activity_labels.txt",col.names = c("code", "activity"))

#####Read Feature Names
FeaNames <- read.table("/Users/chaitu/Downloads/UCI HAR Dataset/features.txt", col.names = c("n","functions"))

#####Merg dataframes: Features Test&Train,Activity Test&Train, Subject Test&Train
FeaData <- rbind(FeaTest, FeaTrain)
SubData <- rbind(SubTest, SubTrain)
ActData <- rbind(ActTest, ActTrain)
Totaldata<- cbind(FeaData, SubData, ActData)



####Create Tidy Data set with the average of each variable

TidyData <- Totaldata %>% select(subject, code, contains("mean"), contains("std"))

####Create a second, independent tidy data set with activity namea

TidyData$code <- activities[TidyData$code, 2]

##### Allocate names to tidy data
names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))

#Save this tidy dataset to local file
FinalData <- TidyData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "tidydata.txt", row.name=FALSE)