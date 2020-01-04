## Raw data
the raw data is downloaded from here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

it consists of a training and a test set
each set has three files that are relevant for this analysis
- subject_{x}.txt - each row identifies a subject
- y_{x}.txt - each row identifies an activity the subject performed
- x_{x}.txt - each row corresponds to one observation. Each column is a measurement (as seen in features.txt)

there are also some additional files describing columns and values in the data sets
- features.txt - each row names a column for the measurement (x) data
- activity_labels.txt - these strings identify the actions specified in the y data

## Transformations

1. All data is read into different tables
The training + test data is then merged so we have 3 tables containing all data: **measureData**, **activityData** and **subjectData**

2. The second step extracts which indices in the features table contains mean or std data and then subsets **measureData** to only include these columns

3. The activity_labels.txt data set is now read in and used to convert **activityData** to factors

4. The feature names is cleaned up a bit to not contain "-" or "()". They are also converted to lower case. This is also where we merge together the three tables into a single data set containing subject, activity and mean/std-measurements

5. Now we can create the tidy data set with one observation for each activity and subject. The reshape2 library is required here for the melt function
The final data is stored in memory as **tidyData** and also written to disk as "tidy_data.csv" and "tidy_data.txt"
