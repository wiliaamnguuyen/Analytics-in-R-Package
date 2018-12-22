polling = read.csv("PollingData.csv")
str(polling)
#There are 50 states and 3 elections so I expect 150 observations
#Structure shows there are only 146 observations in dataframe 


#Breaking down the polling dataframe's Year variable 
table(polling$Year)
#2012 is missing5 observations unlike the other election years. Why?
#The pollsters was so sure about the 5 missing states that they didn't perform any polls in the month leading up to 2012 election
#Since these 5 missing states are easy to predict, I feel comfortable making predictions just for 45 states

str(polling)
#I notice NA values signifying missing data; I want to find out how many NA values
summary(polling)


#The imputed results will be slightly different even if you set the random seed 
#This is due to the randomness involved in the multiple imputation process 


#Installing mice package 
install.packages("mice")
library(mice)
#Before performing multiple imputation, I will limit dataframe to 4 polling related variables
simple = polling[c("Rasmussen","SurveyUSA","PropR", "DiffCount")]
summary(simple)
#getting specific results from imputation
set.seed(144)



#Imputation code
imputed = complete(mice(simple))
summary(imputed)
#variables have no more NA missing values 


#Last step to copy Rasmussen and SurveyUSA variable back into original data frame 
polling$Rasmussen = imputed$Rasmussen
polling$SurveyUSA = imputed$SurveyUSA
summary(polling)



#BUILDING MODEL
#As usual, I will split data into training and test set
#I will train on data from 2004 and 2008 elections and test data on 2012 presidential election 
Train = subset(polling, Year == 2004 | Year == 2008)
Test = subset(polling, Year == 2012)

table(Train$Republican)
#47 out of the 100training observations, democrats has won the state 
#My simple baseline model is always going to predict the more common outcome, which is Republican is going to win the state

#Computing Smart Baseline Method
table(sign(Train$Rasmussen))

#Comparing the smart baseline method compared to actual result 
table(Train$Republican,sign(Train$Rasmussen))
#42 observations where Rasmussen smart baseline method predicted Democrat would win, and actually did. 
#52 observations where Rasmussen smart baseline method predicted Republican would win, and Republican actually did. 
#4 mistakes where smart baseline method predicted republican would win, but democrat won. 




#BUILDING REGRESSION MODELS
cor(Train[c("Rasmussen","SurveyUSA","DiffCount","PropR","Republican")])

#Building a single variable logistic regression model 
mod1 = glm(Republican ~ PropR, data=Train, family=binomial)
summary(mod1)

#looking at my predictive power of my model on predicting republican outcome on training set
pred1 = predict(mod1,newdata = Train, type="response")

#To see how well predictions are doing, I will use threshold of 0.5 
#Where if probabilitiy is at least 1/2, I'm going to predict Republican, otherwise predict Democrat
table(Train$Republican,pred1 >=0.5)


#Adding another variable to my model
mod2 = glm(Republican ~ DiffCount + Rasmussen, data=Train, family=binomial)
pred2 = predict(mod2, type="response")
#To see how well my model is doing in predicting Republican's outcome in training set 
table(Train$Republican, pred2>=0.5)
summary(mod2)


#Evaluating Models on Testing Set 
#Evaluating Smart Baseline Model - comparing testing set Republican variable (R/D win state) compare to actual outcome (sign of Rasmussens)
table(Test$Republican, sign(Test$Rasmussen))

#Will compare this smart baseline model to my logistic regression model
#need to obtain test set predictions on the model first
TestPrediction = predict(mod2, newdata=Test, type="response")
table(Test$Republican,TestPrediction>=0.5)
#Reviewing the mistake
subset(Test, TestPrediction >=0.5 & Republican == 0)










