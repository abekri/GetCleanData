# Import data sets
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
vlabels <- read.table("./UCI HAR Dataset/features.txt")

# 1. Merge the training and the test sets to create one data set
X <- rbind(X_train, X_test)
colnames(X)<-vlabels[,2]
Y <- rbind(Y_train, Y_test)
Subjects <- rbind(subject_train, subject_test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
var_select <- vlabels[grep("mean\\(\\)|std\\(\\)",vlabels[,2]),]
X <- X[,var_select[,1]]

# 3. Uses descriptive activity names to name the activities in the data set
alabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(Y) <- "activity"
Y$activitylabel <- factor(Y$activity, labels = as.character(alabels[,2]))
activity_label <- Y[,-1]

# 4. Appropriately labels the data set with descriptive variable names
# Already Done


# 5. Tidy data set with the average of each variable for each activity and each subject.---------
colnames(Subjects) <- "subject"
tidydata <- cbind(X, activity_label, Subjects)
tidydata <- aggregate(. ~subject + activity_label, tidydata, mean)
library(dplyr)
tidydata <- tidydata %>%
        arrange(subject, activity_label)
write.table(tidydata, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE)