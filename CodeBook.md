# Code book for project

An R script called run_analysis.R:

1. Download and unzip data;
2. Load features, subject, test and training data sets;
3. Merges the training and the test sets to create one data set;
4. Extracts only the measurements on the mean and standard deviation for each measurement;
5. From the data set in step 4, creates an independent tidy data set with the average
of each variable for each activity and subject pair.


Training set has 7352 observations and 561 variables; Test set has 2947 observations and 561 variables;
Feature names have duplicates, so feature IDs (1 to 561) are appended to feature names to resolve the problem

Merged data set has 10299 observations and 563 variables (including subject and activity)

Extracted data set has 10299 observations and 88 variables (subject, activity and 86 variables for
mean and sd of measurements.

The final tidy data set has 40 observations and 88 variables



