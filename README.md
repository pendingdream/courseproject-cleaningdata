Cleaning Procedure for HAR Dataset
========================================================
For Coursera - Getting and Cleaning Data - Course project  
2014.4.25


### Raw Data
The script run_analysis.R cleans the **UCI HAR Dataset**.  
Raw data are downloaded [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).  
For more information about the dataset, please visit http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

To start using run_analysis script, please download and put the following files in your working directory:
 * X\_train.txt: Training set, each row is a 561-feature vector
 * y\_train.txt: Training labels.
 * X\_test.txt: Test set, each row is a 561-feature vector
 * y\_test.txt: Test labels.
 * subject\_train.txt: Each row identifies the subject who performed the activity for training set.
 * subject\_test.txt: Each row identifies the subject who performed the activity for test set.
 * features.txt: List of all features. 
 * activity_lables.txt: Links the labels with their activity name.

The features are variables, including mean (indicated by _mean()_) and standard deviation (indicated by _std()_), estimated from these signals:  
 tBodyAcc-X, tBodyAcc-Y, tBodyAcc-Z  
 tGravityAcc-X, tGravityAcc-Y, tGravityAcc-Z  
 tBodyAccJerk-X, tBodyAccJerk-Y, tBodyAccJerk-Z  
 tBodyGyro-X, tBodyGyro-Y, tBodyGyro-Z  
 tBodyGyroJerk-X, tBodyGyroJerk-Y, tBodyGyroJerk-Z  
 tBodyAccMag  
 tGravityAccMag  
 tBodyAccJerkMag  
 tBodyGyroMag  
 tBodyGyroJerkMag  
 fBodyAcc-X, fBodyAcc-Y, fBodyAcc-Z  
 fBodyAccJerk-X, fBodyAccJerk-Y, fBodyAccJerk-Z  
 fBodyGyro-X, fBodyGyro-Y, fBodyGyro-Z  
 fBodyAccMag  
 fBodyAccJerkMag  
 fBodyGyroMag  
 fBodyGyroJerkMag  
 
e.g. the feature named _tBodyAcc-mean()-Z_, is the mean of signal _tBodyAcc_ on _Z_ axis.
 
### Processing Data
#### Tidy data set: data1
Load all data sets into R
```{r}
## read in all data from files
X_train<-read.table("X_train.txt", comment.char = "")
y_train<-read.table("y_train.txt", comment.char = "")
subject_train<-read.table("subject_train.txt", comment.char = "")
X_test<-read.table("X_test.txt", comment.char = "")
y_test<-read.table("y_test.txt", comment.char = "")
subject_test<-read.table("subject_test.txt", comment.char = "")
features<-read.table("features.txt", comment.char = "")
activity_labels<-read.table("activity_labels.txt", comment.char = "")
```
The column names of `X_train`,`X_test`,`y_train`,`y_test` are missing.  
Using the following code to **assign proper names**. The column name of X sets are the features.
```{r}
## proper namings
names(X_train)<-features[[2]]
names(X_test)<-features[[2]]
names(y_train)<-"Activity"
names(y_test)<-"Activity"
names(subject_train)<-"Subject"
names(subject_test)<-"Subject"
```
In `y_train` and `y_test`, activity is represented by index numbers. The following code **translates the index into descriptive activity names**
```{r}
## using descriptive activity names
y_test[[1]]<-factor(y_test[[1]])
levels(y_test[[1]])<-activity_labels[[2]]
y_train[[1]]<-factor(y_train[[1]]) 
levels(y_train[[1]])<-activity_labels[[2]]
```

After assigning proper names, we will **combine** all data set in following steps:
- Combine `subject_train`,`y_trian` and `X_trian` to a full training data set. Column 1 of new data set will be "Subject", column 2 will be "Activity" and rest are 561-feature vectors for each subject and each activity
- Do the same combination to test set.
- Combine training set and test set together to get the full set.  

All the steps can be done by one line:

```{r}
##combine
data1<-rbind(cbind(cbind(subject_train,y_train),X_train),cbind(cbind(subject_test,y_test),X_test))
```

Then we look at the names of the new data set and use `grep()` to decide whether they are mean or standard deviation variables. Basically we are looking for those names with either _mean()_ or _std()_ inside. **Extracts only the measurements on the mean and standard deviation for each measurement** by following code
```{r}
meanorstd<-c(grep("mean()", features[[2]],fixed=TRUE,value=TRUE),grep("std()", features[[2]],fixed=TRUE,value=TRUE))
```

Clean up the names by remove all brackets and duplicated "Body"
```{r}
data1<-data1[,c("Subject","Activity",meanorstd)]
n<-names(data1)
n<-sub("BodyBody","Body",n,fixed=TRUE)
n<-sub("()","",n,fixed=TRUE)
names(data1)<-n
```

Finally we have a tidy data set **`data1`**. It will be saved as data1.txt in working directory.
It has 68 columns and 10299 rows. Column names are:
* Subject
* Activity
* tBodyAcc-mean-X
* tBodyAcc-mean-Y
* tBodyAcc-mean-Z
* tGravityAcc-mean-X
* tGravityAcc-mean-Y
* tGravityAcc-mean-Z
* tBodyAccJerk-mean-X
* tBodyAccJerk-mean-Y
* tBodyAccJerk-mean-Z
* tBodyGyro-mean-X
* tBodyGyro-mean-Y
* tBodyGyro-mean-Z
* tBodyGyroJerk-mean-X
* tBodyGyroJerk-mean-Y
* tBodyGyroJerk-mean-Z
* tBodyAccMag-mean
* tGravityAccMag-mean
* tBodyAccJerkMag-mean
* tBodyGyroMag-mean
* tBodyGyroJerkMag-mean
* fBodyAcc-mean-X
* fBodyAcc-mean-Y
* fBodyAcc-mean-Z
* fBodyAccJerk-mean-X
* fBodyAccJerk-mean-Y
* fBodyAccJerk-mean-Z
* fBodyGyro-mean-X
* fBodyGyro-mean-Y
* fBodyGyro-mean-Z
* fBodyAccMag-mean
* fBodyAccJerkMag-mean
* fBodyGyroMag-mean
* fBodyGyroJerkMag-mean
* tBodyAcc-std-X
* tBodyAcc-std-Y
* tBodyAcc-std-Z
* tGravityAcc-std-X
* tGravityAcc-std-Y
* tGravityAcc-std-Z
* tBodyAccJerk-std-X
* tBodyAccJerk-std-Y
* tBodyAccJerk-std-Z
* tBodyGyro-std-X
* tBodyGyro-std-Y
* tBodyGyro-std-Z
* tBodyGyroJerk-std-X
* tBodyGyroJerk-std-Y
* tBodyGyroJerk-std-Z
* tBodyAccMag-std
* tGravityAccMag-std
* tBodyAccJerkMag-std
* tBodyGyroMag-std
* tBodyGyroJerkMag-std
* fBodyAcc-std-X
* fBodyAcc-std-Y
* fBodyAcc-std-Z
* fBodyAccJerk-std-X
* fBodyAccJerk-std-Y
* fBodyAccJerk-std-Z
* fBodyGyro-std-X
* fBodyGyro-std-Y
* fBodyGyro-std-Z
* fBodyAccMag-std
* fBodyAccJerkMag-std
* fBodyGyroMag-std
* fBodyGyroJerkMag-std

e.g. the feature named _tBodyAcc-mean-Z_, is the mean of signal _tBodyAcc_ on _Z_ axis.
Each row is a 66-feature vector for the corresponding subject and activity.


#### Tidy data set: data2  
Use `aggregate()` to creates a second, independent tidy data set `data2`with the average of each variable for each activity and each subject. It will be saved as data2.txt in working directory.  
Use `paste()` to add "Average" in front of orignal column names, indicating this is a set of mean values.
```{r}
data.col<-ncol(data1)
data2<-aggregate(data1[,3:data.col],by=list(data1$Subject,data1$Activity),mean,simplify=TRUE)
names(data2)[1:2]<-c("Subject","Activity")
names(data2)[3:data.col]<-paste("Average",names(data2)[3:data.col])
```

It has 68 columns and 180 rows.Column names for `data2` are:
* Subject
* Activity
* Average tBodyAcc-mean-X
* Average tBodyAcc-mean-Y
* Average tBodyAcc-mean-Z
* Average tGravityAcc-mean-X
* Average tGravityAcc-mean-Y
* Average tGravityAcc-mean-Z
* Average tBodyAccJerk-mean-X
* Average tBodyAccJerk-mean-Y
* Average tBodyAccJerk-mean-Z
* Average tBodyGyro-mean-X
* Average tBodyGyro-mean-Y
* Average tBodyGyro-mean-Z
* Average tBodyGyroJerk-mean-X
* Average tBodyGyroJerk-mean-Y
* Average tBodyGyroJerk-mean-Z
* Average tBodyAccMag-mean
* Average tGravityAccMag-mean
* Average tBodyAccJerkMag-mean
* Average tBodyGyroMag-mean
* Average tBodyGyroJerkMag-mean
* Average fBodyAcc-mean-X
* Average fBodyAcc-mean-Y
* Average fBodyAcc-mean-Z
* Average fBodyAccJerk-mean-X
* Average fBodyAccJerk-mean-Y
* Average fBodyAccJerk-mean-Z
* Average fBodyGyro-mean-X
* Average fBodyGyro-mean-Y
* Average fBodyGyro-mean-Z
* Average fBodyAccMag-mean
* Average fBodyAccJerkMag-mean
* Average fBodyGyroMag-mean
* Average fBodyGyroJerkMag-mean
* Average tBodyAcc-std-X
* Average tBodyAcc-std-Y
* Average tBodyAcc-std-Z
* Average tGravityAcc-std-X
* Average tGravityAcc-std-Y
* Average tGravityAcc-std-Z
* Average tBodyAccJerk-std-X
* Average tBodyAccJerk-std-Y
* Average tBodyAccJerk-std-Z
* Average tBodyGyro-std-X
* Average tBodyGyro-std-Y
* Average tBodyGyro-std-Z
* Average tBodyGyroJerk-std-X
* Average tBodyGyroJerk-std-Y
* Average tBodyGyroJerk-std-Z
* Average tBodyAccMag-std
* Average tGravityAccMag-std
* Average tBodyAccJerkMag-std
* Average tBodyGyroMag-std
* Average tBodyGyroJerkMag-std
* Average fBodyAcc-std-X
* Average fBodyAcc-std-Y
* Average fBodyAcc-std-Z
* Average fBodyAccJerk-std-X
* Average fBodyAccJerk-std-Y
* Average fBodyAccJerk-std-Z
* Average fBodyGyro-std-X
* Average fBodyGyro-std-Y
* Average fBodyGyro-std-Z
* Average fBodyAccMag-std
* Average fBodyAccJerkMag-std
* Average fBodyGyroMag-std
* Average fBodyGyroJerkMag-std

Each row is a 66-element mean value vector for the corresponding subject and activity.