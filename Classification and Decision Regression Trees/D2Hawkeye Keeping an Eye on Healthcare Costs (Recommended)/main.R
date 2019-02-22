claims = read.csv("ClaimsData.csv")
str(claims)

#Giving the percentage of patients in each of the cost bucket. 
table(claims$bucket2009)/nrow(claims)*100

#Splitting into training and test set before building the model 
library(caTools)
set.seed(88)

split = sample.split(claims$bucket2009,SplitRatio = 0.6)
#Putting 60% of data into training set
ClaimsTrain = subset(claims, split=True)
ClaimsTest = subset(claims,split=False)

#Average age of patients in the training set
mean(ClaimsTrain$age)
summary(ClaimsTrain$age)

#Proportion of people in training set had at least one diagnosis for diabetes
table(ClaimsTrain$diabetes)/nrow(ClaimsTrain)
#38% has diabetes

#Classification matrix to compute accuracy of baseline model on test set
#Actual outcomes/Personal Predictions)
table(ClaimsTest$bucket2009,ClaimsTest$bucket2008)
#Accuracy is the sum of the diagonal/correct observations divided by total observations
(275105+26893+6778+3938+245)/nrow(ClaimsTest)
#Accuracy of baseline method is 68%

#Penalty Error
#Compute it using penalty matrix (predicted outcomes top, actual outcomes left)
PenaltyMatrix = matrix(c(0,1,2,3,4,2,0,1,2,3,4,2,0,1,2,6,4,2,0,1,8,6,4,2,0),byrow=TRUE,nrow =5)
#It is important to note, this penalty matrix is arbitrary and you can decide how you want to penalize your model

PenaltyErrorMatrix = as.matrix(table(ClaimsTest$bucket2009,ClaimsTest$bucket2008)) * PenaltyMatrix
PenaltyError = sum(as.matrix(table(ClaimsTest$bucket2009,ClaimsTest$bucket2008)) * PenaltyMatrix)/nrow(ClaimsTest)


#Now, to create a CART model that has higher accuracy than 68% (baseline model) and penalty error lower than 0.74
library(rpart)
library(rpart.plot)
ClaimsTree = rpart(bucket2009 ~ age + arthritis + alzheimers + cancer + copd + depression + diabetes + heart.failure + ihd + kidney + osteoporosis + stroke + bucket2008 + reimbursement2008, data=ClaimsTrain,method = 'class', cp=0.00005)
#looking at the tree model
prp(ClaimsTree)

#Making predictions on the test set
PredictTest = predict(ClaimsTree, newdata=ClaimsTest, type='class')
#Creating a classification matrix on the test set to compute the accuracy
#Actual outcomes vs Predicted
table(ClaimsTest$bucket2009,PredictTest)
#Accuracy = sum(diagonal)/(total observations in test set)
Accuracy = sum(diag(table(ClaimsTest$bucket2009,PredictTest)))/nrow(ClaimsTest)
#Accuracy of model is 71%

#Penalty Error by using a penalty matrix 
PenaltyMatrix2 = sum(as.matrix(table(ClaimsTest$bucket2009,PredictTest))*PenaltyMatrix)/nrow(ClaimsTest)
#Penalty error is 0.75

#Building my model again specifying the rpart function parameter loss
ClaimsTree = rpart(bucket2009 ~ age + arthritis + alzheimers + cancer + copd + depression + diabetes + heart.failure + ihd + kidney + osteoporosis + stroke + bucket2008 + reimbursement2008, data=ClaimsTrain,method = 'class', cp=0.00005, parms=list(loss=PenaltyMatrix))
PredictTest = predict(ClaimsTree, newdata=ClaimsTest, type='class')
table(ClaimsTest$bucket2009,PredictTest)
Accuracy2 = sum(diag(table(ClaimsTest$bucket2009,PredictTest)))/nrow(ClaimsTest)
#Accuracy is 64.7%
PenaltyMatrix3 = sum(as.matrix(table(ClaimsTest$bucket2009,PredictTest))*PenaltyMatrix)/nrow(ClaimsTest)
#Penalty error is 0.63




















