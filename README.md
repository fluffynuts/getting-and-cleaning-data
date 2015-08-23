This is the course project for part 3 of the Data Science Track
on Coursera: "Getting and cleaning data".

The required artifact is run_analysis.R which manipulates the data
provided at the url:

 https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

This data is provided in two sets: "train" and "test", which were created
by an arbitrary split selection. The data from both sets relates to telemetry
recorded by a smartphone whilst subjects performed certain activities.
The load is attempted by the following logic:

1. Load the test data
    1. Load the test data from test/X_test.txt
    2. Load the test labels from test/y_test.txt
    3. Load the subjects (identified by number only) from test/subject_test.txt
    4. Load the activity descriptors from activity_labels.txt
    5. combine the above into one large data frame linking subject, activity and recorded values
2. Load the train data
    1. Load the train data from test/X_test.txt
    2. Load the train labels from test/y_test.txt
    3. Load the subjects (identified by number only) from train/subject_test.txt
    4. Load the activity descriptors from activity_labels.txt
    5. combine the above into one large data frame linking subject, activity and recorded values
3. Merge the two data sets together and order by subject and activity
4. Produce a reduced version of the data which has means and standard deviations for the 561 columns provided in the raw data instead of the prior wide table
5. Persist that slimmer table to disk, in the file merged-data.csv
6. Produce a summary of this data with an average of all recorded values per subject and activity and persist that to summary-data.csv

