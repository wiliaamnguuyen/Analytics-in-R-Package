framingham = read.csv("framingham.csv")
str(framingham)
#4240 patients and 16 variables
#Variables include demographic risk factors, behavorial risk factors, medical history and physical exam risk factors
#Last variable is the outcome/dependent variable; whether patient developed CHD in next 10 years

#Splitting into Training and Test Set using sample.split() function
library(caTools)
set.seed(1000)
split = sample.split(framingham$TenYearCHD, SplitRatio = 0.65, group = NULL)
#Splitting into training set and test set using subset function
#For training set, take observations which split == TRUE
train = subset(framingham, split == TRUE)
test = subset(framingham, split==FALSE)

#Create Logistic Regression Model using all the independent variables
framinghamLog = glm(TenYearCHD ~ ., data = train, family = binomial)
summary(framinghamLog)





#Making predictions on test set; function takes arguments of model and type="response" to give me probabilities
predictTest = predict(framinghamLog, type="response", newdata = test)
#Using a threshold of 0.5 to make a confusion matrix, utilize table function 
table(test$TenYearCHD, predictTest >0.5)
#Calculating Accuracy
accuracy = (1069+11)/(1069+11+187+6)
#Computing baseline method accuracy to compare to model's accuracy 
baseline_model_accuracy = (1069+6)/(1069+11+187+6)
#Computing the out-of-sample AUC
library(ROCR)
#using prediction() function of ROCR package to make predictions 
ROCRpred = prediction(predictTest, test$TenYearCHD)
as.numeric(performance(ROCRpred,"auc")@y.values)

