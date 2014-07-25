##Introduction
    This script loads the training data and testing data and meeges them. Further it extracts only
    the mean and standard deviation of reading present in the orignal dataset as -mean() and -std() 
    respectively. Attempt has been made to make the column names as meaningful as possible.
    Further it averages each of the reading per person per activity and outputs the result as "output.txt"
##Usage Instructions
    This script must be present at the same level as the "UCI HAR Dataset" directory.For example:
        (top-level)
            |-UCI HAR Dataset
            |-run_analysis.R
    Before loading the script in rstudio remember to set the working directory appropriately. You
    can use "setwd()" command to do so.

    Call the function main. The result will be a list of two dataframes containg the answers to part 4
    and part 5 respectively. The data frame of the averages (the anwer to part 5) is also written to a
    file "output.txt".

    sample usage:

        ```X<-main()```
    
    X will be a list containing two dataframes(`X[[1]]` and `X[[2]]`) with
    ```X[[1]]``` : answer to part 4
    ````X[[2]]``` : answer to part 5 
##Functions
   `main()`-        It is the main function. It call all the helper functions and additionally does part 3,4 of 
                    the excercise.It returns a list of two dataframes
   
   `find_stat()` -  It calculates the average for each of the columns and stores the result as a new data frame.
                    Further it gives meaningful column names to the new data frame. It returns the the new data
                    frame it created.

   `mygsub()` -     Variant of `gsub()` . It is used to apply `gsub()` operation for multiple pattens and replacement.
                    Usage is documented in the inline comments.

   `loadData()` -   This function loads all the required data. Then it extracts only the mean and standard deviation part 
                    of the data. It also loads all the subject id and activity names and correctly associates it with
                    each row of data. Finally the data from test and train is combined and the resulting data frame is 
                    returned.

