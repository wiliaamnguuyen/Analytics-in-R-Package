#PLaying around with data

parole = read.csv("parole.csv")
str(parole)
summary(parole)
#Number of parolees
nrow(parole)

#Number of parolees violated the terms of their parole 
table(parole$violator)


#Preparing the dataset
#Converting to unordered factors into factors
parole$state = as.factor(parole$state)
parole$crime = as.factor(parole$crime)
#Showing the breakdown of number of parolees with each level of factor 
summary(parole$state)
summary(parole$crime)

#Splitting into a Training and Test Set
set.seed(144)
library(caTools)
split = sample.split(parole$violator, SplitRatio = 0.7)
train = subset(parole, split == TRUE)
test = subset(parole,split==FALSE)


#Building a Logistic Regression Model 
model1 = glm(violator ~., data = parole, family = binomial)
summary(model1)

#Evaluating the Model on the Testing Set 
predTest = predict(model1,newdata = test, type="response")
#Maximum predicted probability of a violation
max(predTest)
summary(predTest)
#Evaluating my model's predictions on test set using threshold value 0.5
table(test$violator,predTest >=0.5)
#Sensitivity
Sensitivity = 12/(12+11)
#Specificity 
Specificity = 169/(169+10)
#Accuracy 
Accuracy = (169+12)/(169+10+12+11)


#Baseline model accuracy in predicting every parolee is a nonviolator 
table(test$violator)
# 0 is for non-violator, thus accuracy is 179/202



#AUC for Model to e
library(ROCR)
pred = prediction(predTest, test$violator)
as.numeric(performance(pred,"auc")@y.values)



































































