library(magrittr)
library(dplyr)
# Download the dataset and unzip 

fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "./Gettingandcleaningdata.zip")

unzip(zipfile = "./Gettingandcleaningdata.zip")

# Reading training datasets
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Reading test datasets, features and activity labels
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
activity = read.table("./UCI HAR Dataset/activity_labels.txt")

# labels the data set with descriptive variable names
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityID"
colnames(subject_train) <- "subjectID"
colnames(x_test) <- features[,2]
colnames(y_test) <- "activityID"
colnames(subject_test) <- "subjectID"
colnames(activity) <- c("activityID", "activityType")

# Merging the training and the test data sets to create one data set
train <- cbind(y_train, subject_train, x_train)
test <- cbind(y_test, subject_test, x_test)
dataset <- rbind(train, test)

# Extracts the meaurements on the mean and standard deviation for each measurement
mean_sd<- (grepl("mean|std",features[,2]))

dataset_mean_sd <- dataset[,mean_sd == TRUE]

# Use descriptive activity names to name the activities in the data set
datasetActivity <- merge(dataset_mean_sd, activity,
                              by = "activityID",
                              all.x = TRUE)

# Creating a second,  independent tidy data set with the average of each variable for each activity and each subject
tidy_data <- datasetActivity %>% group_by(activityID, subjectID) %>% summarise_all(funs(mean)) 

# write final tidy data
write.table(tidy_data, file = 'tidy_data.txt', row.names = FALSE, col.names = TRUE)