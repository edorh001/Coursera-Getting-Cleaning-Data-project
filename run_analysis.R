# Coursera Getting and Cleaning Data. 
# Course Project
# Assignemnt:
# You should create one R script called run_analysis.R that does the following. 
#  1.Merges the training and the test sets to create one data set.
#  2.Extracts only the measurements on the mean and standard deviation for each measurement. 
#  3.Uses descriptive activity names to name the activities in the data set
#  4.Appropriately labels the data set with descriptive variable names. 

5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


# Prepare tools 


 if(require("downloader")){ 
     print("downloader is loaded correctly") 
   } else { 
       print("trying to install downloader") 
       install.packages("downloader") 
       if(require(downloader)){ 
           print("downloader installed and loaded") 
         } else { 
             stop("could not install required packages (downloader)") 
           } 
     } 
 

 if(require("data.table")){ 
     print("data.table is loaded correctly") 
   } else { 
       print("trying to install data.table") 
       install.packages("data.table") 
       if(require(data.table)){ 
           print("data.table installed and loaded") 
         } else { 
             stop("could not install required packages (data.table)") 
           } 
     } 
 

 print("To download data and prepare tidy data set, run download.data() and run.analysis()") 
 

 

 # Download dataset 
 

 download.data <- function(){ 
     url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip' 
     file <- 'dataset.zip' 
     download(url,file) 
     unzip(file) 
     print("Dataset downloaded. Please, proceed with run.analysis()") 
   } 
 

 # Loads and processes dataset of given type (train or test) 
 

 load.dataset <- function(type, selected.features, activity.labels){ 
      
     path <- paste(type, '/', sep = '') 
     feature.vectors.file <- paste(path, 'X_', type, '.txt', sep = '') 
     activity.labels.file <- paste(path, 'y_', type, '.txt', sep = '') 
     subject.ids.file <- paste(path, 'subject_', type, '.txt', sep= '') 
   
  
     # Load data files 
     feature.vectors.data <- read.table(feature.vectors.file)[,selected.features$id] 
     activity.labels.data <- read.table(activity.labels.file)[,1] 
     subject.ids.data <- read.table(subject.ids.file)[,1] 
      
     # Name variables  
     names(feature.vectors.data) <- selected.features$label 
     feature.vectors.data$label <- factor(activity.labels.data, levels=activity.labels$id, labels=activity.labels$label) 
     feature.vectors.data$subject <- factor(subject.ids.data) 
      
     # Return processed dataset 
     feature.vectors.data 
   
  
   } 
 

 run.analysis <- function(){ 
     setwd('UCI HAR Dataset/') 
   
  
     # Load id->feature label data 
     feature.vector.labels.data <- read.table('features.txt', col.names = c('id','label')) 
      
     # Select only the measurements on the mean and standard deviation for each measurement. 
     # Using grepl we can return logical vector of matching columns. 
     # Features we want to select have -mean() or -std() as a part of the name. 
     selected.features <- subset(feature.vector.labels.data, grepl('-(mean|std)\\(', feature.vector.labels.data$label)) 
   
  
     # Load id->activity label data 
     activity.labels <- read.table('activity_labels.txt', col.names = c('id', 'label')) 
   
  
     # Read train and test data sets 
     print("Read and process training dataset") 
     train.df <- load.dataset('train', selected.features, activity.labels) 
     print("Read and process test dataset") 
     test.df <- load.dataset('test', selected.features, activity.labels) 
   
  
     # Merge train and test sets 
     print("Merge train and test sets") 
     merged.df <- rbind(train.df, test.df) 
     print("Finished dataset loading and merging") 
      
     # Convert to data.table for making it easier and faster  
     # to calculate mean for activity and subject groups. 
     merged.dt <- data.table(merged.df) 
      
     # Calculate the average of each variable for each activity and each subject.  
     tidy.dt <- merged.dt[, lapply(.SD, mean), by=list(label,subject)] 
      
     # Tidy variable names 
     tidy.dt.names <- names(tidy.dt) 
     tidy.dt.names <- gsub('-mean', 'Mean', tidy.dt.names) 
     tidy.dt.names <- gsub('-std', 'Std', tidy.dt.names) 
     tidy.dt.names <- gsub('[()-]', '', tidy.dt.names) 
     tidy.dt.names <- gsub('BodyBody', 'Body', tidy.dt.names) 
     setnames(tidy.dt, tidy.dt.names) 
   
  
     # Save datasets 
     setwd('..') 
     write.csv(merged.dt, file = 'uci-har-raw-data.csv', row.names = FALSE) 
     write.csv(tidy.dt, 
                               file = 'uci-har-tidy-data.csv', 
                               row.names = FALSE, quote = FALSE) 
   
  
      
     print("Finished processing. Tidy dataset is written to uci-har-tidy-data.csv") 
 } 
Enter file contents here
