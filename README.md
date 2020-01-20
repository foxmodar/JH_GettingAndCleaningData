# Getting & Cleaning Data Course Project
Block_1-  * Check if a data dir exist, create one if not
          * Download zip file
Block_2
          * read the data into objects in R
          * Create a list of Features by name & list of activities by name
          * Read Test data: 30% of the subject generated the test data 
          * Read training data : 70% of the subject generated the test data 
Block_3
          * Merge Data 
          * merge Subject data from test & Train
          * merge Activities data from test & Train
          * merge Features data from test & Train
Block_4          

          * consolidation | One Datasett.
          * Cleanup and add descriptive naming
Block_5
          * calculate the mean of every variable
          * Order data by SubjectID & Activity
          * replicate file to file.txt

Variable List :

                FileUrl  : URL for raw data zip
                Activities: List of Activities by Name
                Features : features list - 561
                Test_Activities:  Activities from test data set
                Test_Features  : Features  from test data set
                Test_Subjects : Subjects from test data set 
                Train_Activities:  Activities from test data set
                Train_Features  : Features  from test data set
                Train_Subjects : Subjects from test data set 
                A_Data : Consolidated Activities Data
                F_Data  : Consolidated Features Data
                S_Data : Consolidated Subject Data
                Consolidated: one dataset - consolidated data across Train & Test
                Extract  : Extracted Features containing mean or std
                Extract_replica : Replica of extract 
