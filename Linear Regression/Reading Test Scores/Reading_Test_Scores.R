pisaTrain = read.csv("pisa2009train.csv")
pisaTest = read.csv("pisa2009test.csv")

#Observe amount of students in training set
str(pisaTrain)
nrow(pisaTrain)

#Explore average reading test scores of males
tapply(pisaTrain$readingScore,pisaTrain$male,mean)

#Removing observations with missing values from test and training set
pisaTrain = na.omit(pisaTrain)
pisaTest = na.omit(pisaTest)
#Observe how many observations in training set now 
nrow(pisaTrain)
str(pisaTrain)

#setting reference level in a factor vartiable 
pisaTrain$raceeth = relevel(pisaTrain$raceeth, "White")
pisaTest$raceeth = relevel(pisaTest$raceeth, "White")

#Building linear regression model 
#Predicting Reading Score using all independent variables
lmscore = lm(readingScore ~., data= pisaTrain)
#Looking RSquared
summary(lmscore)

#Calculating RMSE of above regression model 
SSE = sum(lmscore$residuals^2)
#Number of observations
n = nrow(pisaTrain)
RMSE = sqrt(SSE/n)

#Another way of calculating RMSE
RMSE = sqrt(mean(lmscore$residuals^2))
#Predicting on Unseen Data
predTest = predict(lmscore, newdata=pisaTest)
#Looking at range of predicted reading scores
summary(predTest)
max(predTest)
min(predTest)

#Finding SSE on regression model on test set
#Finding the Sum of Squared Errors between predicted set and actual test set
SSE = sum((predTest - pisaTest$readingScore)^2)
#RMSE 
RMSE = sqrt(SSE/nrow(pisaTest))

#Baseline prediction and test-set SSE 
baseline = mean(pisaTrain$readingScore)
#SST: sum of squared errors of the baseline model on test set
SST = sum((mean(pisaTrain$readingScore)-pisaTest$readingScore)^2)
#R Squared on Test Set 
R2 = 1 - (SSE/SST)







































