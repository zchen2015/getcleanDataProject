######
## run_analysis.R

## download data
print("downloading data ...")
url1 = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url1, destfile="project1_data.zip", method="libcurl", quiet=TRUE)
unzip("project1_data.zip")

library(dplyr)
library(tidyr)

#setwd("./UCI HAR Dataset")

print("loading data ...")

## load activity labels and format the names
actlab <- read.table("UCI HAR Dataset/activity_labels.txt")
actlab$V2 <- tolower(actlab$V2)
actlab$V2 <- gsub("_up","Up", actlab$V2)
actlab$V2 <- gsub("_do","Do", actlab$V2)

# load features and
# add feature ID (1, ..., 561) to the end of feature name to
# fix the duplicated feature name problem
feat <- read.table("UCI HAR Dataset/features.txt")
feat <- feat %>% mutate(V2=paste(V2,V1,sep="_"))

## load test data
xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
names(xtest) <- feat[,2]
ytest <- read.table("UCI HAR Dataset/test/Y_test.txt")
subte <- read.table("UCI HAR Dataset/test/subject_test.txt")

merge(ytest, actlab) -> actlabte
date <- cbind(subject=subte[,1], activity=actlabte[,2], xtest)

## load training data
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
names(xtrain) <- feat[,2]
ytrain <- read.table("UCI HAR Dataset/train/Y_train.txt")
subtr <- read.table("UCI HAR Dataset/train/subject_train.txt")

merge(ytrain, actlab) -> actlabtr
datr <- cbind(subject=subtr[,1], activity=actlabtr[,2], xtrain)

da1 <- rbind(date, datr)
mest <- grep("mean|Mean|std", names(da1))
da2 <- da1 %>% select(subject, activity, mest)

## clean up the variable names by
## dropping the index since no duplicated name in this subset
## remove ()
names(da2) <- gsub("_[0-9]+", "", names(da2))
names(da2) <- gsub("\\()", "", names(da2))
names(da2) <- gsub("[\\()]", "", names(da2))
names(da2) <- gsub(",", "-", names(da2))
names(da2) <- gsub("-", "", names(da2))

## get average of each variable for each subject and activity
print("getting average of each variable for each subject and activity ...")
da3 <- da2 %>%
  mutate(subjActivity=paste(subject, activity, sep="_")) %>%
  select(-(subject:activity)) %>%
  group_by(subjActivity) %>%
  summarise_each(funs(mean)) %>%
  separate(col=subjActivity, into=c("subject", "activity")) %>%
  mutate(subject=as.integer(subject), activity=as.factor(activity)) %>%
  arrange(subject, activity)

## write out tidy data
print("wirting out tidy data ...")
write.table(da3, file="UCI HAR Dataset/project_tidydata.txt", row.name=FALSE, quote=FALSE, sep=",")

print("done, tidy data saved in project_tidydata.txt")
