FluTrain = read.csv("FluTrain.csv")

#From a time period 2004-2011, observe which week has highest percentage of ILI-related visits
max_percentage_week = subset(FluTrain, ILI == max(ILI))
#Alternative method 
max_percentage_row_ILI = which.max(FluTrain$ILI)
max_percentage_week = FluTrain$Week[max_percentage_row_ILI]

#Observe which week correspond to highest percentage of ILI-related query fraction
max_percentage_ILI_Queries = subset(FluTrain, Queries == max(Queries))

#Plotting histogram of dependent variable ILI
hist(FluTrain$ILI)

#Predict the logarithm of the skewed dependent variable not just the dependent variable itself  
plot(FluTrain$Queries, log(FluTrain$ILI))
#There is a positive, linear relationship between log(ILI) and Queries
#Use linear regression model due to plot observation

FluTrend1 = lm(log(ILI) ~ Queries, data=FluTrain)

#There is a direct relationship in single variable linear relationship 
#between R-SQuared and correlation between independent and dependent variables. 
R2 = (cor(log(FluTrain$ILI),FluTrain$Queries)^2)

#PERFORMANCE ON THE TEST
FluTest = read.csv("FluTest.csv")
PredTest1 = exp(predict(FluTrend1,newdata=FluTest))
#Find the estimate percentage of ILI-Related Physician Visits for March 11,2012
which(FluTest$Week == "2012-03-11 - 2012-03-17")
#Looking for prediction number 11 
PredTest1[11]


#Relative Error between the estimate (our prediction) and observed value for the week of March 11
#Relative Error = (Observed ILI - Estimated ILI)/Observed ILI
Relative_Error = (2.29 - 2.18)/2.29
#RMSE between our estimates and the actual observations for percentage of ILI-Related Physician Visits
# on the test set
SSE = sum((PredTest1 - FluTest$ILI)^2)
RMSE = sqrt((SSE)/nrow(FluTest))
#Alternatively 
RMSE = sqrt(mean((PredTest1 = FluTest$ILI)^2))

#Training a Time Series Model 
install.packages("zoo")
library(zoo)
#Creating the ILILag2 variable in the training set
ILILag2 = lag(zoo(FluTrain$ILI), -2, na.pad = TRUE)
FluTrain$ILILag2 = coredata(ILILag2)
#The value -2 passed to lag means to return 2 observations before the current one 
#A positive value instead would have returned future observations
#The parameter na.pad=TRUE means to add missing missing values for the first 2 weeks
#in our dataset, where we can't compute the data from 2 weeks earlier

#I wanted to check how many missing values are there?
summary(FluTrain$ILILag2)

#Showing a strong positive relationship between log(ILILag2) & log(ILI)
plot(log(FluTrain$ILILag2),log(FluTrain$ILI))


#Training linear regression model on FluTrain dataset
#to predict the log of ILI variable using Queries variable 
#as well as the log of ILILag2 variable
FluTrend2 = lm(log(ILI) ~ log(ILILag2) + Queries, data = FluTrain)
#Observing statistical significance of coefficients (p-value=0.05)
str(FluTrend2)


#Making predictions with FluTrend2 model, add ILILag2 to FluTest dataframe 
ILILag2 = lag(zoo(FluTest$ILI),-2,na.pad = TRUE)
FluTest$ILILag2 = coredata(ILILag2)
summary(FluTest$ILILag2)
#There are two missing values NA's


#Filling in the missing values of ILILag2 in the FluTest
FluTest$ILILag2[1] = FluTrain$ILILag2[416]
FluTest$ILILag2[2] = FluTrain$ILILag2[417]

#Obtaining test set predictions of the ILI variable from FluTrend2 model 
PredTest2 = exp(predict(FluTrend2, newdata = FluTest))
SSE = sum((PredTest2-FluTest$ILI)^2)
RMSE = sqrt(SSE/ nrow(FluTest))


































