
## Code BooK Description:
This code book includes information about the source data, the transformations performed after collecting the data and some information about the variables of the resulting data sets.

## Proceesing Data : Steps to run the code
***

1- Downloaded the data set
2.Unzipped the data set into my chosen working directory
3.Loaded test and training data sets into data frames
4.Loaded source variable names for test and training data sets
5.Loaded activity labels
6.Combined test and training data frames using rbind
7.Paired down the data frames to only include the mean and standard deviation variables
8.Replaced activity IDs with the activity labels for readability
9.Combined the data frames to produce one data frame containing the subjects, measurements and activities
10.Produced "merged_tidy_data.txt" with the combined data frame as the first expected output
11.Created another data set using the data.table library to easily group the tidy data by subject and activity
12.Then applied the mean and standard deviation calculations across the groups
13.Produced "calculated_tidy_data.txt" as the second expected output
