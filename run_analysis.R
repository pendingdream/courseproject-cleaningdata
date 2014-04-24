## For Coursera : Getting and cleaning Data, project assignment
## please put all required files in working directory

## read in all data from files
X_train<-read.table("X_train.txt", comment.char = "")
y_train<-read.table("y_train.txt", comment.char = "")
subject_train<-read.table("subject_train.txt", comment.char = "")
X_test<-read.table("X_test.txt", comment.char = "")
y_test<-read.table("y_test.txt", comment.char = "")
subject_test<-read.table("subject_test.txt", comment.char = "")
features<-read.table("features.txt", comment.char = "")
activity_labels<-read.table("activity_labels.txt", comment.char = "")

## proper namings
names(X_train)<-features[[2]]
names(X_test)<-features[[2]]
names(y_train)<-"Activity"
names(y_test)<-"Activity"
names(subject_train)<-"Subject"
names(subject_test)<-"Subject"

## using descriptive activity names
y_test[[1]]<-factor(y_test[[1]])
levels(y_test[[1]])<-activity_labels[[2]]
y_train[[1]]<-factor(y_train[[1]]) 
levels(y_train[[1]])<-activity_labels[[2]]

##combine
data1<-rbind(cbind(cbind(subject_train,y_train),X_train),cbind(cbind(subject_test,y_test),X_test))

## Extracts only the measurements on the mean and standard deviation for each measurement. 
## tidy the names of data set
## final tiny data set is data1
meanorstd<-c(grep("mean()", features[[2]],fixed=TRUE,value=TRUE),grep("std()", features[[2]],fixed=TRUE,value=TRUE))
data1<-data1[,c("Subject","Activity",meanorstd)]
n<-names(data1)
n<-sub("BodyBody","Body",n,fixed=TRUE)
n<-sub("()","",n,fixed=TRUE)
names(data1)<-n

##output
write.table(data1,file="data1.txt", quote = FALSE, col.names=TRUE, row.names=FALSE)

## Creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject. 
## new data set is data2
data.col<-ncol(data1)
data2<-aggregate(data1[,3:data.col],by=list(data1$Subject,data1$Activity),mean,simplify=TRUE)
names(data2)[1:2]<-c("Subject","Activity")
names(data2)[3:data.col]<-paste("Average",names(data2)[3:data.col])
##output
write.table(data2,file="data2.txt", quote = FALSE, col.names=TRUE, row.names=FALSE)
