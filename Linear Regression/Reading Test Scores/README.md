# Reading Test Scores #
## Introduction ##
The program for International Student Assessment (PISA) is a test given every three years to 15-year-old students from around the world to evaluate their performance in mathematics, reading, and science. 

This test provides a quantitative way to compare the performance of students from different parts of the world. 

I predicted the reading scores of students from the United States of America on the 2009 PISA exam.

The datasets pisa2009train.csv and pisa2009test.csv contain information about the demographics and schools for American students taking the exam, derived from 2009 PISA Public-Use Data Files distributed by the United States National Center for Education Statistics (NCES). 

While the datasets are not supposed to contain identifying information about students taking the test, by using the data you are bound by the NCES data use agreement, which prohibits any attempt to determine the identity of any student in the datasets.

**Each row in the datasets pisa2009train.csv and pisa2009test.csv represents one student taking the exam**. 

The datasets have the following variables:
- **grade:** The grade in school of the student (most 15-year-olds in America are in 10th grade)
- **male:** Whether the student is male (1/0)
- **raceeth:** The race/ethnicity composite of the student
- **preschool:** Whether the student attended preschool (1/0)
- **expectBachelors:** Whether the student expects to obtain a bachelor's degree (1/0)
- **motherHS:** Whether the student's mother completed high school (1/0)
- **motherBachelors:** Whether the student's mother obtained a bachelor's degree (1/0)
- **motherWork:** Whether the student's mother has part-time or full-time work (1/0)
- **fatherHS:** Whether the student's father completed high school (1/0)
- **fatherBachelors:** Whether the student's father obtained a bachelor's degree (1/0)
- **fatherWork:** Whether the student's father has part-time or full-time work (1/0)
- **selfBornUS:** Whether the student was born in the United States of America (1/0)
- **motherBornUS:** Whether the student's mother was born in the United States of America (1/0)
- **fatherBornUS:** Whether the student's father was born in the United States of America (1/0)
- **englishAtHome:** Whether the student speaks English at home (1/0)
- **computerForSchoolwork:** Whether the student has access to a computer for schoolwork (1/0)
- **read30MinsADay:** Whether the student reads for pleasure for 30 minutes/day (1/0)
- **minutesPerWeekEnglish:** The number of minutes per week the student spend in English class
- **studentsInEnglish:** The number of students in this student's English class at school
- **schoolHasLibrary:** Whether this student's school has a library (1/0)
- **publicSchool:** Whether this student attends a public school (1/0)
- **urban:** Whether this student's school is in an urban area (1/0)
- **schoolSize:** The number of students in this student's school
- **readingScore:** The student's reading score, on a 1000-point scale

## Summarising the dataset ##
- To find the average reading test score of males I used the **tapply() function**. The 3 arguments I used:
    - Reading score
	  - Applying reading score argument on males 
	  - Taking the mean value of reading scores for final argument
    
## Removing missing values ##
Linear regression discards observations with missing data, so I removed all such observations from the training and testing set. 
Note: Imputation deals with missing data by filling in missing values with plausible information but we will not do this now. 
- I used the **na.omit() function** where:
    - This function deals with NAs in data frames where it returns the object with incomplete cases removed. 

## Factor variables ##
Factor variables are variables that take on a discrete set of values. 
- There is an unordered factor because there isn’t any natural ordering between the levels.
- An ordered factor has a natural ordering between the levels (an example would be the classification “large,” “medium,” and “small”). 
    - Male variable has only 2 levels (1 and 0). 
	  - No natural ordering between the difference value of race, so it is an unordered factor. 
	  - Grades is an order factor (8,9,10,11,12). 
- To include unordered factors in a linear regression model, we define one level as the “reference level” and add a binary variable for each of the remaining levels. 
    - A factor with n levels is replaced by n-1 binary variables 
    - The reference level is typically selected to be the most frequently occurring level in the dataset
    - For example: 
	      - Consider the unordered factor variable “color”. 
	      - It is an unordered factor with levels “red”, “green”, and “blue”. 
	      - If “green” were the reference level, then we would add binary variables “colored” and “colorblue” to a linear regression problem. 
	          - All red examples would have colorred = 1 and colorblue = 0. 
	          - All blue examples would have colorred=0 and colorblue =1. 
	          - All green examples would have colorred = 0 and colorblue = 0 
    - Further example:
	      - The variable “raceeth” in our problem, which has levels “American Indian/Alaska Native”, “Asian”, “Black”, “Hispanic”, “More than one race”, “Native Hawaiian/Other Pacific Islander”, and “White”. 
	      - We can create a binary variable for each level except the reference level, so we would create all these variables except for raceethWhite. 
	      - If an Asian student will have raceethAsian set to 1 and thus, all other raceeth binary variables set to 0. 
	           - Since “White” is the reference level, a white student will have all raceeth binary variables set to 0. 

## Building a model ##
Since the race variable takes on text values, it was loaded as a factor variable when we in the data set. 
**Note:** By default, R selects the first level alphabetically (“American Indian/Alaska Native”) as the reference level of our factor instead of the most common level “White”. 
- You can set the reference level of the factor by typing: 
```
pisaTrain$raceeth = relevel(pisaTrain$raceeth, “White”)
pisaTest$raceeth = relevel(pisaTest$raceeth, “White”)
```

- Building a model using all the remaining variables to predict **Reading Score**; 
    - I easily used the quick notation by R **_“readingScore ~.”_**
        - To predict **Reading Score** using the rest of other variables in the data frame. 
        - The period is used to replace listing out all of the independent variables. 
        - Instead: 
> LinReg = lm(Y ~ X1 + X2 + X3, data = Train)
        - Rather:
> LinReg = lm(Y ~ ., data = Train)

- Observations:
    - Multiple R-Squared = 0.32. 
	      - This R-Squared is lower than the ones for the models I have worked with before. 
	      - Remember, this doesn’t necessarily imply that the model is of poor quality. 
	      - Often, it simply means that the prediction problem at hand (predicting a student’s test score based on demographic and school-related variables) is more difficult than other prediction problems (like predicting a team’s number of wins from their run scored). 
    - Computing Root-mean squared error of the model
        - RMSE = √(SSE/(n(rows of observations)))
> RMSE (Alternative method) = sqrt(mean(model$residual^2))

## Interpreting model coefficients ##
The meaning of the coefficient associated with the variable raceethAsian:
- It predicts the difference in the reading score between an Asian student and a white student who is otherwise identical 
- The predicted reading score for these two students will differ by the coefficient on the variable raceethAsian

## Predicting on unseen data ##
I used the predict function and supplied the **“newdata =” argument**; where I predicted results using the regression model to predict the reading scores on the test set. 

With this new vector of predictions, I observed the range between the maximum and minimum predicted reading scores on the test set. 

To find the **SSE (Sum of Squared Errors)** of our regression model on the test set; **_I wanted to find the errors in my predicted test results by comparing its difference to the actual test set values of the reading scores (test set)._**

**Baseline Prediction and Test-Set SSE**
- Computing the sum of the difference squared between baseline (mean value of training set reading score predictions) and test set reading score. 
- Test-Set R-Squared
> R2 = 1 – (SSE/SST)

