census = read.csv("census.csv")

#Baseline Accuracy for the Testing Set 
table(train$over50k)
#Determine Most Frequent outcome is people earning less than 50,000 dollars a year
table(test$over50k)
baseline.accuracy = 9713/nrow(test)
#Baseline Accuracy for Testing Set: 75%


#A Logistic Regression Model 
library(caTools)
set.seed(2000)
split = sample.split(census$over50k,SplitRatio=0.6)
train = subset(census,split==TRUE)
test = subset(census,split==FALSE)

logModel = glm(over50k ~ .,data=train,family='binomial')
summary(logModel)

#Accuracy of this Logistic Regression Model 
#Setting threshold to 0.5
logModelpred = predict(logModel,newdata=test,type='response')
table(test$over50k,logModelpred >0.5)
accuracyglm = (9051+1888)/nrow(test)
#Logistic Regression Model Accuracy 85%


#Investigating the Area Under the Curve (AUC) for this model on the test set 
library(ROCR)
ROCRpred = prediction(logModelpred,test$over50k)
AUC = as.numeric(performance(ROCRpred,"auc")@y.values)

#Logistic Regression has high accuracy
#However, it does not tell me immediately which variables are more important than others in predicting over50k variable
#Building a CART model for better interpretability of significant variables 

library(rpart)
library(rpart.plot)
CARTmodel = rpart(over50k ~ .,data=train,method='class')
prp(CARTmodel)
#Tree has 4 splits 
#Determining the accuracy of this model on the testing set with a threshold of 0.5 
CARTmodelpred = predict(CARTmodel, newdata=test,type='class')
table(test$over50k,CARTmodelpred)
accuracyCART = sum(diag(table(test$over50k,CARTmodelpred)))/nrow(test)
#ACCURACY OF CART MODEL: 84%


#Calculating AUC of the CART model
CARTmodel = rpart(over50k ~ .,data=train,method='class')
CARTmodelpredAUC = predict(CARTmodel, newdata=test)
CARTmodelpredAUC = CARTmodelpredAUC[2]
ROCRpred2 = prediction(CARTmodelpredAUC,test$over50k)
as.numeric(performance(ROCRpred2,"auc")@y.values)
#AUC = 0.84


#Random Forest Model 
#Before buildin the model, I need to down-sample my training set
set.seed(1)
trainSmall = train[sample(nrow(train),2000),]

#Predicting "over50k"
set.seed(1)
randomForest = rpart(over50k ~.,data=trainSmall)
prp(randomForest)
randomForestpred = predict(randomForest,newdata=test)
table(test$over50k,randomForestpred)
#Accuracy is 83%

#Selecting cp parameter using k-fold cross validation 
set.seed(2)
library(caret)
#Specifying that I'm using k-fold cross validation with 10 folds
fitControl = trainControl(method='cv',number=10)
#Specifying the grid of cp values I wish to evaluate
cartGrid = expand.grid(.cp=seq(0.002,0.1,0.002))
#Running the train function 
train(over50k ~.,data=train,method='rpart',trControl = fitControl, tuneGrid=cartGrid)
#cp value used is 0.002 corresponding to the lowest cp value. 

#Fittign a CART model using this cp value==0.002
model=rpart(over50k~.,data=train,method='class',cp=0.002)
modelpred = predict(model,newdata=test,type='class')
table(test$over50k,modelpred)
accuracymodel = sum(diag(table(test$over50k,modelpred)))/nrow(test)
#86% Accuracy Model -- high accuracy compared to default cp value model.
prp(model)
#18 spits, too many splits