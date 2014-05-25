# On my own machine: setwd("C:\\Projects\\github\\Coursera\\Work\\GettingAndCleaningDataProject\\getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset")

# First, create a table with the column names
features <- read.table("features.txt", col.names=c("num", "feature"), stringsAsFactors=F)

# Normalize the feature names to be better identifier names
featureNames <- features$feature
featureNames <- gsub("\\(", "", featureNames)
featureNames <- gsub("\\)", "", featureNames)
featureNames <- gsub("-", ".", featureNames)
featureNames <- gsub(",", ".", featureNames)

features$feature <- featureNames

# Pull in activity labels
activities <- read.table("activity_labels.txt", col.names=c("id", "name"), stringsAsFactors=F)

# A function to map from integer ID to friendly name:
getName <- function(matchId) subset(activities, id == matchId)$name[1]

# Pull in training data
dataTrain <- read.table("train/X_train.txt", col.names=featureNames, stringsAsFactors=F)
# And the ids of the participants
subjTrain <- read.table("train/subject_train.txt", stringsAsFactors=F)
dataTrain$subject <- subjTrain$V1
# Get the activities
actTrain <- read.table("train/y_train.txt", stringsAsFactors=F)
dataTrain$actId <- actTrain$V1
dataTrain$activity <- sapply(dataTrain$actId, getName)

# And test data
dataTest <- read.table("test/X_test.txt", col.names=featureNames, stringsAsFactors=F)
# And the ids of the participants
subjTest <- read.table("test/subject_test.txt", stringsAsFactors=F)
dataTest$subject <- subjTest$V1
# Get the activities
actTest <- read.table("test/y_test.txt", stringsAsFactors=F)
dataTest$actId <- actTest$V1
dataTest$activity <- sapply(dataTest$actId, getName)

# Now, merge both of them together into one data.frame!
meanFeatures <- features[grep("mean", features$feature), ]
stdFeatures <- features[grep("std", features$feature), ]

# Only take features with mean or std in the name
featuresToTake <- merge(meanFeatures, stdFeatures, all=T)
featuresToTakeNames <- featuresToTake$feature
featuresToTakeNames <- c(featuresToTakeNames, "subject", "activity")

# Merge all together first
merged <- merge(dataTrain, dataTest, all=T)

# And take just the subset of columns
merged <- subset(merged, select=featuresToTakeNames)

# Write to disk, at last:
write.table(merged, "merged.txt")