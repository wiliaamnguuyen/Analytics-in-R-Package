# Election Forecasting 

I will be using polling data from the months leading up to a presidential election to predict that election’s winner using a logistic regression model; importantly evaluating the model’s predictions. 
Election forecasting is the art and science of predicting the winner of an election before any votes are cast using polling data from likely voters. 
-	Each of the 50 states in the US is assigned a number of electoral votes based on its population:
    - More populous state (California 2012) had 55 electoral votes 
    - Least votes (2012) had 3 electoral votes 
    - These electoral votes are reassigned periodically based on changes of populations between states 
-	**_Winner takes all: candidate with the most votes in a state gets all its electoral votes._**
    -	Candidate with the most electoral votes wins election 
    -	The 2000 Presidential election between George W.Bush and Al Gore: 
        -	Al Gore received more than 500,000 more votes across the country than Bush in terms of the popular vote 
        -	In terms of the electoral vote; because of how the votes are distributed, Bush won the election since he received 5 more electoral votes than Al Gore 
-	My goal is to use polling data that’s collected from likely voters before the election to predict the winner in each state and therefore predict the winner of the entire election in the electoral college system. 

## Goal 

Use polling data collected in the months leading up to 2004, 2008, and 2012 US presidential election to predict state winners.
-	Each row in the dataset represents _name of state_ in a _specific election year_
The dependent variable:
-	**_Republican_** is a binary outcome where 1 if Republican won state, 0 if Democrat won
The independent variables are related to the polling data in that state:
-	_Rasmussen and SurveyUSA variables_ are related to two major polls that are assigned across many different states in the US. Note these are not the only polls that are run on a state by state basis
    -	This represents the percentage of voters who mentioned they were likely to vote Republican minus the percentage who said they were likely to vote Democrat. 
    -	For e.g. if variable SurveyUSA in my dataset has value -6%, it means that 6% more voters said they were likely to vote Democrat than said they were likely to vote Republican in that state. 
-	_DiffCount_: Counts the number of all the polls leading up to the election that predicted a Republican winner in the state, minus the number of polls that predicted a Democratic winner. 
-	_PropR (or Proportion Republican):_ has the proportion of all those polls leading up to the election that predicted a Republican winner. 

#Dealing with Missing Data
For the **_Rasmussen and SurveyUSA_** variable, there are a decent amount of missing values. 
To fill in this missing values, the approach is called **_multiple imputation_**. 
-	Fill in the missing values based on the non-missing values for an observation 
-	For instance, if the **_Rasmussen_** variable is reported and is very negative, then a missing **_SurveyUSA_** value would likely be filled in as a negative value as well. 
    -	Just like the sample.split() function, multiple runs of multiple imputation will in general, result in different missing values being filled in based on the random seed that is set. 
    -	Multiple imputation is in general a mathematically sophisticated approach, it is done easily through existing R libraries. 
    -	I will use the **_Multiple Imputation by Chained Equations (mice package)_**. 
-	For multiple imputation to useful, I have to find out the values of my missing variables without using the outcome of **_Republican_**. 
    -	Before multiple imputation action, I limited the data frame to just 4 polling related variables
    -	To perform imputation, I created a data frame named **_imputed_**, using the function _complete()_, called on the function mice, called on simple.  
    -	All of the variables have been filled in, no more missing values.
    -	Remember to copy the variables with completed values back into the original data frame which has all the variables for the problem 

#A Sophisticated Baseline Method

To build a model, I need to first split the data into the training and test set. 
I have decided to test the data on the 2012 presidential election based on the a model trained on 2004 and 2008 dataset. 
To understand the prediction of my baseline model against which I want to compare a later logistic regression model. 
-	**_table(Train$Republican)_** shows my simple baseline model is always going to predict the more common outcome; in this case which is Republican is going to win the state. 
-	My simple baseline model will have an accuracy of 53% on the training set
-	Unfortunately, this is a week model:
    -	It always predicts Republican, even for a very landslide Democratic state where the Democrat was polling by 15-20% ahead of the Republican 
    -	I do not find this a credible model; I need to find a smarter baseline model against which I can compare my logistic regression model that I will develop. 

-	A smarter baseline model:
    -	I will take the variable **_Rasmussen_** and make a prediction based on whose poll said was winning in the state
    -	For instance, if Republican is polling ahead, the Rasmussen smart baseline model would pick the Republican to be the winner. 
    -	If the Democrat was ahead, it would pick the Democrats.
    -	If they were tied, the model would not know which one to select. 
    -	To compute this smart baseline, we’re going to use a new function called the sign() function.
        -	This function passed a positive number, it returns 1. 
        -	If it passed 0, it returns 0. 
        -	If I passed **_Rasmussen_** variable into sign() function, whenever the Republican was winning the state, meaning Rasmussen is positive, it’s going to return a 1. 
        -	For instance, if value is 20 is passed, meaning the Republican is polling 20 ahead, it returns 1 i.e. _1 signifies that the Republican is predicted to win_.
        -	If Democrat is leading in the Rasmussen poll, it’ll take on a negative value; sign(-10) will return -1 value, and this means this smart baseline odel is predicting that Democrat won the state. 
        -	Finally, if I took the sign of 0, it means the Rasmussen poll had a tie returning a 0 value; this means the model is inconclusive about who’s going to win the state. 

-	To compute this prediction for all of my training set; I used the table function applied to the sign of the training set’s Rasmussen variable; “**_table(sign(Train$Rasmussen))_**. Observation shows:
    -	56 out of 100 training set observations, smart baseline model predicted Republican was going to win. 
    -	In 42 instances, it predicted the Democrat. 
    -	2 instances shows it was inconclusive.
    
-	I want to see the breakdown of how well the smart baseline model does, compared to the actual result i.e. _who actually won the state._
    -	Using table function to compare the training set’s outcome against the sign of the polling data. 
    -	Rows are true outcome, 1 (Republican) and 0 (Democrat) and the columns are the smart baseline predictions -1, 0 or 1. 
    -	This is a more reasonable baseline method to move forward to compare against comparing logistic regression-based approach. 
    
#Logistic Regression Models 

I considered the possibility that there is a multicollinearity issue within the independent variable with building regression model; I am suspecting there is multicollinearity amongst the variables since they are all measuring how strong the Republican candidate is performing in a specific state. 
-	Normally, I would compute the correlation function on the training set, but it won’t work since ‘x’ must be numeric 
-	Looking at the structure of the training set, it shows why computing the correlation function would be an issue. 
    -	It is because I am taking the correlations of the names of state, which doesn’t many any sense to compute the correlation. 
-	To compute the correlation, I’m going to want to take the correlation amongst the independent variables that I’m using to predict and add in the dependent variable to the correlation matrix. 
    -	There are a lot high values; SurveyUSA and Rasmussen are independent variables that have a correlation of 0.94. 
    -	It means combining them together isn’t going to do much to produce a working regression model. 

I will build a logistic regression model with just one variable, but which variable? 
-	Looking at the correlation matrix, I see _PropR_ is the variable that is most correlated with what I am predicting; the Republican variable. 
    -	Nice model in terms of its significance and the sign of the coefficients of the variables 
    -	PropR is the proportion of the polls that said that the Republican won; it has high significance and high coefficient in terms of predicting that the Republican will win in that state; which makes intuitive sense. 
    -	Note: **_AIC_** measures the strength of the model at 19.8 which shows a very reasonable model. 
    -	**_How well does it do predicting the Republican outcome on the training set?_**
    
-	I want to compute the predictions, the predicted possibilities that the Republican is going to win on the training set using the model I created above. 
    -	I created a vector containing the prediction probabilities that Republican will win on training set. 
    -	Since I just want to make predictions on the training set, I do not need the “newdata=” argument since I am not looking at test set predictions now. 
    -	It is important to note I pass the “type=’response’” argument to get probabilities out as the predictions. 
    
-	Now, I want to see how well the predictions are doing using a threshold of 0.5. 
    -	Looking at the training set Republican value _against_ the logical of whether my predictions using the logistic regression model is greater than or equal to 0.5 with the table() function.
    -	The rows shows the outcome – 1 is Republican, 0 is Democrat. 
    -	Columns show – TRUE means that I predicted Republican, FALSE means I predicted Democrat. 
    -	On the training set, my model with one variable as a prediction makes 4 mistakes which is just about the same as my smart baseline method 
    -	To improve the performance, I want to add in another variable – will use correlation matrix to select model. 

-	Adding a variable to my model using the correlation matrix
    -	Note when I search for another variable, I am aware of the multicollinearity issue so I might search for a pair of independent variables that has relatively lower correlation with each other, because it might work well together to improve the prediction overall. 
    -	Note, when searching for a variable for my previous one variable model; I wanted an independent variable that is highly correlated with what I am predicting i.e. dependent variable_. However, when I am adding another independent variable; I want to make sure that this variable has lower correlation with the present independent variable in the model. 
        -	If two independent variables are highly correlated, they’re less likely to improve predictions together
        -	I tried out SurveyUSA and DiffCount in my second model 
        -	To see how well my second model’s predictions are doing at predicting Republican outcome on my training set; I can see I made one less mistake; so a little better than the smart baseline model but not impressive enough. 
        -	Summary on my model shows lower AIC value suggesting a stronger model; estimate coefficient shows positive in predicting if Republican wins the state which makes sense. However, this model is weak since neither variables is statistically significant. 
        -	I will use this two-variable model to make predictions on the testing set. 


#Test Set Predictions
Looking at the smart baseline model that basically just took a look at the polling results from the Rasmussen poll and used those to determine who was predicted to win the election. 
-	Very easy to compute the outcome for this simple baseline on the testing set. 
-	Will table the testing set outcome variable, **Republican** and compare that against the actual outcome of the smart baseline, which is the sign of the testing set’s Rasmussen variables. 
    -	There are 18 times that the smart baseline method predicted Democrat would win and did; 21 times a Republican was predicted would win and was correct. 
    -	2 times it was inconclusive; 4 times where it predicted a Republican would win but it was actually a Democrat who won. 
        -	4 mistakes and 2 inconclusive results on the testing set. 
        -	This is what I’m going to compare my logistic regression-based model against. 
        -	Need to obtain final testing set predictions from my logistic regression model. 
-	Creating my final test set predictions from my model:
    -	Table the test set Republican value against the test prediction being greater than or equal to 0.5, at least a 50% probability of the Republican winning. 
    -	For the total 45 observations, I am wrong once. 
    -	I want to pull out this mistake by using the subset() function and limit it when I predicted TRUE but a Democrat actually won. 
        -	Year 2012; state – Florida; and looking through these predictor variables I see why I made the mistake. 
        -	The Rasmussen poll gave the Republican a 2% point lead, SurveyUSA called a tie, DiffCount said there were 6 more polls that predicted Republican than Democrat and 2/3 of the polls predicted Republican was going to win. 
              -	However, actually the Republican didn’t win since Barack Obama won the state of Florida in 2012 over Mitt Romney. 
        -	Despite this mistake, overall it seems to be outperforming the smart baseline that I selected so maybe this would be a nice model to use in the election prediction. 
