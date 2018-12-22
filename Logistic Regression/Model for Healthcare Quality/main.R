quality = read.csv("quality.csv")
str(quality)
#131 observations for 131 patients for 14 different variables
#PoorCare is dependent variable and is equivalent to 1
#Patient had good care, then PoorCare = 0

#Want to investigate how many patients received good care
table(quality$PoorCare)
#33 patients received poor care

#Before building any models, I'm utilising simple baseline method 
#So I compare my predictions of my model to the baseline method of predicting the average outcome for all datapoints
Baseline_Method_Accuracy = 98/131 
#Will use Logistic Regression model to beat this accuracy percentage


#Splitting dataset into training set and test set randomly
#install.packages("caTools")
#library(caTGools)
set.seed(88)
split = sample.split(quality$PoorCare,SplitRatio = 0.75)
print(split)
#Creating training and test set using subset function
qualityTrain = subset(quality,split==TRUE)
qualityTest = subset(quality,split==FALSE)
nrow(qualityTrain)
nrow(qualityTest)
#The rows/observations adds up to 131 observations



#Building a logistic regression model using Office visits and Narcotics as independent variables
QualityLog = glm(PoorCare ~ OfficeVisits + Narcotics, data = qualityTrain, family = binomial)
summary(QualityLog)

#Making Predictions on Training Set
predictTrain = predict(QualityLog, type="response")
summary(predictTrain)

#Investigating if predictions has higher probabilities for poor cases
tapply(predictTrain, qualityTrain$PoorCare,mean)
#For all the actual poor care cases, I predicted an average probability of 0.44
#For all the true good care cases, I predict an average probability of 0.19
#This is a good sign since I'mpredicting higher probability for the actual poor care cases


#Creating a different logistic regression model with different independent variables
QualityLog2 = glm(PoorCare ~ StartedOnCombination + ProviderCount, data=qualityTrain, family= binomial)
summary(QualityLog2)
#StartedOnCombination is a binary variable, when equated to 1, patients is started on combination of drugs
#Equal to 0 if patient is not started on a combination of drugs 
#Coefficient value of this variable is positive, thus making outcome of 1 more likely (poorcare)


#Classification Tables Using Different Threshold Tables
table(qualityTrain$PoorCare,predictTrain > 0.5)
#Increasing threshold values to 70%
table(qualityTrain$PoorCare,predictTrain > 0.7)
#By increasing my threshold, my specificity rate increased and sensitivity rate decreased

#ROC Curves
install.packages("ROCR")
library(ROCR)

#I made predictions on Training set, in variable predictTrain
#Using these predictions to create ROC curve 
ROCRpred = prediction(predictTrain,qualityTrain$PoorCare)
ROCRperf = performance(ROCRpred, "tpr","fpr")
#Added threshold values below
plot(ROCRperf,colorize = TRUE,print.cutoffs.at=seq(0,1,0.1),text.adj=c(-0.2,1.7))
#The third argument, prints threshold values in increments of 1
#To get finer incremenets, I can decrease value of 0.1 above
#ROC curve with threshold values added
#I can use this curve to determine which threshold value I want to use depending on me 


#Computing Test Set Predictions 
predictTest = predict(QualityLog,type="response",newdata=qualityTest)
#Computing test set AUC 
ROCRpredTest = prediction(predictTest,qualityTest$PoorCare)
auc = as.numeric(performance(ROCRpredTest,"auc")@y.values)

#Given a random patient from the dataset who actually received poor case
#and a random patient from the dataset who actually received good care
#The AUC percentage of time that my model will classify which is which correctly
#80%





















