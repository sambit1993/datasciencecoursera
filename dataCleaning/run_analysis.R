

activity_names<- c("walking","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING", "STANDING","LAYING")

##Subsituting activity names with formatted words in lower case using camelCase
activity_names<-gsub("_[a-z]","\\U",tolower(activity_names))

loadData<-function(){
    
    ##Reading train data
    trainData<-read.table("train/X_train.txt",sep="")
    trainDataPerson<-read.table("train/subject_train.txt",sep="")
    trainActivity<-read.table("train/y_train.txt",sep="")
    names(trainDataPerson)<-c("Person")
    names(trainActivity)<-c("Activity")
    trainActivity<-lapply(trainActivity,function(x){ activity_names[x]})
    
    ##Reading test data
    testData<-read.table("test/X_test.txt",sep="")
    testDataPerson<-read.table("test/subject_test.txt",sep="")
    testActivity<-read.table("test/y_test.txt",sep="")
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
    
    
    trainData<-cbind(trainDataPerson,trainActivity,trainData)
    testData<-cbind(testDataPerson,testActivity,testData)

    ret<-rbind(trainData,testData) 
    
    ret
}

mygsub<-function(pattern,replacement,string){
    for(i in seq_along(pattern)){
        string<-gsub(pattern[i],replacement[i],string)
    }
    string
}

find_stat<-function(x){
    means<-aggregate(x[,3:ncol(x)],by=list(x[,1],x[,2]),FUN=mean)
    names(means)[1:2]=c("Person","Activity")
    means<-means[order(means[,1],means[,2]),]
    names(means)<-gsub("$","Average",names(means))
    names(means)[1:2]<-c("Person","Activity")
    means
}

main<-function(){
    data<-loadData()
    pattern<-c("^t","^f","Acc","Gyro","-","mean\\(\\)","std\\(\\)","X","Y","Z")
    replacement<-c("time","frequency","AccelerometerReading","GyroscopeReading","","Mean","StandardDeviation","AlongXAxis","AlongYAxis","AlongZAxis")
    names(data)<-mygsub(pattern,replacement,names(data))
    aggregateData<-find_stat(data)
    write.table(aggregateData,file="output.txt",sep=" ",row.names=F)   
}
