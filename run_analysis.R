library(reshape2)

# ------------------------------------------------------------------------
# 0. Download data
# ------------------------------------------------------------------------
dataDir = "data"
if (!file.exists(dataDir)) {
    dir.create(dataDir)
    
    fileName = "data.zip"
    url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(url, 
                  destfile=fileName, 
                  method="curl")
    downloadTime <- date()
    
    unzip(fileName, exdir=dataDir)
}

# ------------------------------------------------------------------------
# 1. Merges the training and the test sets to create one data set. 
# (Will actually create three sets but they will be merged in a 
# later step because I think it makes more sense)
# ------------------------------------------------------------------------
testX <- read.table("data/UCI HAR Dataset/test/X_test.txt")
testY <- read.table("data/UCI HAR Dataset/test/y_test.txt")
testSubject <- read.table("data/UCI HAR Dataset/test/subject_test.txt")

trainX <- read.table("data/UCI HAR Dataset/train/X_train.txt")
trainY <- read.table("data/UCI HAR Dataset/train/y_train.txt")
trainSubject <- read.table("data/UCI HAR Dataset/train/subject_train.txt")

measureData <- rbind(testX, trainX)
activityData <- rbind(testY, trainY)
subjectData <- rbind(testSubject, trainSubject)

# ------------------------------------------------------------------------
# 2. Extracts only the measurements on the mean and standard deviation
# for each measurement.
# ------------------------------------------------------------------------
featureLabels <- as.character(read.table("data/UCI HAR Dataset/features.txt")[,2])
# extract indices to labels that contain "mean(" or "std("
featureIndices <- grep("mean\\(|std\\(", featureLabels) 
# subset measure data to only include mean / std columns
measureData <- measureData[featureIndices]

# ------------------------------------------------------------------------
# 3. Uses descriptive activity names to name the activities in the data set
# ------------------------------------------------------------------------
activityLabels <- read.table("data/UCI HAR Dataset/activity_labels.txt")[,2]
activityData[,1] <- as.factor(activityData[,1])
levels(activityData[,1]) <- activityLabels

# ------------------------------------------------------------------------
# 4. Appropriately labels the data set with descriptive variable names.
# ------------------------------------------------------------------------
featureLabels <- featureLabels[featureIndices]
featureLabels <- gsub("-", "_", featureLabels)
featureLabels <- gsub("\\()", "", featureLabels)
featureLabels <- tolower(featureLabels)

testData <- cbind(subjectData, activityData, measureData)
colnames(testData) <- c("subject", "activity", featureLabels)

# ------------------------------------------------------------------------
# 5. From the data set in step 4, creates a second, independent tidy 
# data set with the average of each variable for each activity and 
# each subject.
# ------------------------------------------------------------------------
melted <- melt(testData, id = c("subject", "activity"))
tidyData <- dcast(melted, subject + activity ~ variable, mean)


# 6. Write tidy data to disk
write.csv(tidyData, file="tidy_data.csv")
write.table(tidyData, file="tidy_data.txt", row.name=FALSE)
