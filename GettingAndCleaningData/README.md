Course Project README
==========================

This document will describe how the "run_analysis.R" script works and some of the decisions made during development.

First thing you will notice is that I did not necessarily tackle the project in the steps provided, but decided to jump between steps to fit what I thought would work best for the data set. So I've started with Steps 1, 3 and 4 then moved on to steps 2 and 5 to complete the assignment. The source data set was pretty difficult for me to comprehend initially so I decided to add labels and column names as quickly as possible.

Here's a short description of how the "run_analysis.R" included is designed to run:

1. Move to my working directory for the class and download the file.
    * Note that I have these commented out, and that unzipping was done outside of R
2. Read in activity labels and features data sets
3. Construct a complete data set out of the training data
    * Bind training data to labels and subjects
    * Get feature names for the data set
    * Merge with activity labels to get a labeled data set
4. Complete the same process for the test data set
    * Bind test data to labels and subjects
    * Get feature names for the data set
    * Merge with activity labels to get a labeled data set
    * Note that this may return a warning, I believe due to the encoding differences between column names
5. Bind the training and test data sets
6. Select only features that were mean or standard deviation values
    * Determine which columns contained the mean values
    * Determine which columns contained the standard deviation values
    * Select the columns defined columns from the current data set
    * Note that this may return a warning, I believe due to the encoding differences between column names
7. Melt and dcast the data set with the mean function