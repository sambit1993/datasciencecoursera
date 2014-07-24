##This file should be present inside UCI HAR Dataset directory
## For example a sample directory tree is given
##UCI HAR Dataset
## |-test
## |-train
## |-activity_labels.txt
## |-features.txt
## |-features_info.txt
## |-README.txt
## |-run_analysis.R

## To use this script call the function main as
## X<-main()
## X can be any name and it will be a vector of two data frames (X[1]:contains the answer to part 4,X[2]:contains the answer to part 5)
## The averages(as Required in Part 5) will be written in "output.txt" and is stored as aggregateData in main

activity_names<- c("walking","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING", "STANDING","LAYING")

##Subsituting activity names with formatted words in lower case using camelCase
activity_names<-gsub("_[a-z]","\\U",tolower(activity_names))


#Loads the data
#Does Part 1,2
loadData<-function(){
    
    ##Reading train data
    trainData<-read.table("train/X_train.txt",sep="")
    trainDataPerson<-read.table("train/subject_train.txt",sep="")
    trainActivity<-read.table("train/y_train.txt",sep="")
    ##Labeling the first two columns
    names(trainDataPerson)<-c("Person")
    names(trainActivity)<-c("Activity")
    trainActivity<-lapply(trainActivity,function(x){ activity_names[x]})
    
    ##Reading test data
    testData<-read.table("test/X_test.txt",sep="")
    testDataPerson<-read.table("test/subject_test.txt",sep="")
    testActivity<-read.table("test/y_test.txt",sep="")
    ##Labelling the first two columns
    names(testDataPerson)<-c("Person")
    names(testActivity)<-c("Activity")
    testActivity<-lapply(testActivity,function(x){ activity_names[x]})
    
    ##Reading common data
    featureNames<-read.table("features.txt")
    
    ##Labeling features
    names(trainData)<-featureNames[,2]
    names(testData)<-featureNames[,2]
    
    ##Filtering out non mean and non std columns
    trainData<-trainData[grepl("mean\\(\\)|std\\(\\)",names(trainData))]
    testData<-testData[grepl("mean\\(\\)|std\\(\\)",names(testData))]
    
    ##Adding the columns for activities and PersonIDs
    trainData<-cbind(trainDataPerson,trainActivity,trainData)
    testData<-cbind(testDataPerson,testActivity,testData)

    ret<-rbind(trainData,testData) 
    
    ##returning the merged data set
    ret
}

##Version of gsub which takes multiple patterns and replacement
##It replaces the pattern with the corresponding element in replacement vector
##Ex: s<-mygsub(c("a","b"),c("b","a"),"ab")
## s="ba"
mygsub<-function(pattern,replacement,string){
    for(i in seq_along(pattern)){
        string<-gsub(pattern[i],replacement[i],string)
    }
    string
}

##Find the mean for each person for each activity
##Does calculation for part 5
find_stat<-function(x){
    means<-aggregate(x[,3:ncol(x)],by=list(x[,1],x[,2]),FUN=mean)
    ##Labelling the first two columns
    names(means)[1:2]=c("Person","Activity")
    ##ordering the means data frame by name and activity
    means<-means[order(means[,1],means[,2]),]
    ##Adding average to end of each column names to make the names more descriptive
    names(means)<-gsub("$","Average",names(means))
    ##Restoring the names of first two columns
    names(means)[1:2]<-c("Person","Activity")
    means
}


##Main function, calls the helper functions and completes all the tasks
##Additionally does part 3,4 of the excercise
##Returns vector of (merged data,aggregate data) 
main<-function(){
    ##Loading Data
    data<-loadData()
    
    ##Filling the pattern and replacement vector to be passed to mygsub()
    pattern<-c("^t","^f","Acc","Gyro","-","mean\\(\\)","std\\(\\)","X","Y","Z")
    replacement<-c("time","frequency","AccelerometerReading","GyroscopeReading","","Mean","StandardDeviation","AlongXAxis","AlongYAxis","AlongZAxis")
    #Replacing the default column names to make the column names more descriptive
    names(data)<-mygsub(pattern,replacement,names(data))
    #Finding the average for each of the numerical columns of data frame
    aggregateData<-find_stat(data)
    ##Writing the first data frame to file
    write.table(aggregateData,file="output.txt",sep=" ",row.names=F)   
    
    ##Returns the vector of data frames (merged data,aggregate data) after performing Part 1,2,3,4,5 in the course project
    ##It can be used for verification
    c(data,aggregateData)
}
