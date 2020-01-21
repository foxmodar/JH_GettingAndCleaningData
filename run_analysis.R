# Getting & Cleaning Data Course Project

library(tidyverse)
library(reshape2)
# Block_1
#----------------------------------------Check if a data dir exist, create one if not

  if(!file.exists("./RawData")){
  dir.create("./RawData")
  }

#---------------------------------------------------Download zip file

FileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(FileUrl, destfile = "./RawData/JHProjectData.zip", method = "curl")
# ---------------------------------------------------unzip the zip folder

setwd("RawData/")
unzip("JHProjectData.zip") 
setwd("..")
#-----------------------------------------------------List contenet of the unziped folder

list.files("RawData/UCI HAR Dataset/") 

# [1] "activity_labels.txt" "features_info.txt"   "features.txt"        "README.txt"          "test"                "train"              

list.files("RawData/UCI HAR Dataset/test/") 

# [1] "Inertial Signals" "subject_test.txt" "X_test.txt"       "y_test.txt"      
list.files("RawData/UCI HAR Dataset/train//") 

# [1] "Inertial Signals"  "subject_train.txt" "X_train.txt"       "y_train.txt"      
#-------------------------------------------------------------Read Files-------------------------------------------------------------------------- 

# Block_2

# 1- Create a list of Features by name & list of activities by name

# Features List
Features <- read.table("RawData/UCI HAR Dataset/features.txt")
# Rename the Columns in feature's list
colnames(Features) <- c("F-ID", "F-Name")

#  Activities List
Activities <- read.table("RawData/UCI HAR Dataset/activity_labels.txt") 
# Rename the Columns in Activities list
colnames(Activities) <- c("Act-Code", "Act-Name")

#------------------------------------------------------------------------------------
# Read Test data: 30% of the subject generated the test data 
list.files("RawData/UCI HAR Dataset/test/")
# [ "Inertial Signals" "subject_test.txt" "X_test.txt"       "y_test.txt" ]

Test_Subjects <- read.table("RawData/UCI HAR Dataset/test/subject_test.txt") # subject ID only of 2947 observation
colnames(Test_Subjects) <- "SubjectID"  # Rename columns

Test_Activities <- read.table("RawData/UCI HAR Dataset/test/y_test.txt")  # Activities codes only of 2947 observation
colnames(Test_Activities) <- "Act-Code" # Rename columns 

Test_Features <- read.table("RawData/UCI HAR Dataset/test/X_test.txt", header = FALSE) # 2947 Observation - 561 columns(features)

#-------------------------------------------------------------------------------------
# Read training data : 70% of the subject generated the test data 

Train_Subjects <- read.table("RawData/UCI HAR Dataset/train/subject_train.txt") # subject ID only of 7352 observation
colnames(Train_Subjects) <- "SubjectID" # rename column


Train_Activities <- read.table("RawData/UCI HAR Dataset/train/y_train.txt") # Activities codes only of 7352 observation
colnames(Train_Activities) <- "Act-Code"    # Rename columns 

Train_Features <- read.table("RawData/UCI HAR Dataset/train/X_train.txt", header = FALSE)  # 7352 Observation - 561 columns(features)

#-------------------------------------------------------------------------------------

# Block_3

# Merge each category [subjects, Features, Activites]

# merge Subject data
S_Data <- rbind(Test_Subjects, Train_Subjects) # 10299 Observation of subject IDs

# Merge Activities data
A_Data <- rbind(Test_Activities, Train_Activities) # 10299 Observation of Activity codes

A_Data <-  left_join(A_Data, Activities, "Act-Code") # join with activites to get the activity name corespond to the code

A_Data <- A_Data[,2] # only extract Act-Name

# Merge Features data
F_Data <- rbind(Test_Features, Train_Features) # 10299 Observation- 561 Column(Features)
names(F_Data) <- Features[,2]  # Rename each of the 561 column/features

#Block_4
# consolidation | One Datasett.
Consolidated <- cbind(S_Data, A_Data, F_Data) # combine all data

Extract <- Consolidated[,grep("mean|std", Features[,2])] # extract all features containing mean & std

#-----------------------------------------------------------------------------------------
# use make.names() to Make syntactically valid names out of the character vectors.
names(Extract) <- make.names(names(Extract))

names(Extract)[2] <- "Activity" # change the second variable name 
#----------------------------------------------------
# use descriptive labels for the Features

names(Extract) <- gsub("^t", "Time-", names(Extract))
names(Extract) <- gsub("^f", "Frequency-", names(Extract))
names(Extract) <- gsub("Acc", "Accelerometer-", names(Extract))
names(Extract) <- gsub("Gyro", "Gyroscope-", names(Extract))
names(Extract) <- gsub("Mag", "Magnitude-", names(Extract))
names(Extract) <- gsub("BodyBody", "Body-", names(Extract))
names(Extract) <- gsub("mean", "Mean-", names(Extract))
names(Extract) <- gsub("std", "STD-", names(Extract))

#Block_5

####Create a second, independent tidy data set with the average of each variable for each activity and each subject
# melt the SubjectID and Activities Columns
Extract_Melted <- melt(Extract,(id.vars=c("SubjectID","Activity")))

#calculate the mean of features and save into a new object
Extract_replica <- dcast(Extract_Melted, SubjectID + Activity ~ variable, mean)

names(Extract_replica)[-c(1:2)] <- paste("Mean-" , names(Extract_replica)[-c(1:2)])
#Save this replica to local file
write.table(Extract_replica, file = "tidydataset.txt", sep = ",")
