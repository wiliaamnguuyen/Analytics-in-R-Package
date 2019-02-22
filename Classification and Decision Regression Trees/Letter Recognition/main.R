letters = read.csv("letters_ABPR.csv")

#Predicting whether a letter is B or not. 
#Creating a dataframe taking values TRUE if observation corresponds to letter B
letters$isB = as.factor(letters$letter == 'B')

library(caTools)
#Splitting data set into training and test set. 
set.seed(1000)
split = sample.split(letters$isB,SplitRatio = 0.5)
train = subset(letters, split==TRUE)
test = subset(letters,split==FALSE)

#Before building my model, I will consider a baseline model predicting the most frequent outcome (not "b")
#Computing accuracy of baseline model on test set steps
#1. Which outcome value is more frequent in training set using table() function
table(train$letter)
#This tells me "not B" is more common
#Baseline model is to predict "Not B" for everything 
table(test$isB)
1175/(383+1175)
#Accuracy of baseline model is 75%

#Building a classification tree to predict whether letter is B or not 
#Drop variable letter out of the model since it's what I'm predicting 
library(rpart)
library(rpart.plot)
CARTb = rpart(isB ~ .-letter,data=train,method='class')
predictB = predict(CARTb,newdata=test,type='class')
#Calculating accuracy of CART model on the test set 
table(test$isB,predictB)
accuracy.isB = sum(diag(table(test$isB,predictB)))/nrow(test)
#93% Accuracy CLASSIFICATION MODEL


#Buidling a random forest model to predict whether letter is B or not B 
#Building a model with all independent variables except letter since it's helping me define what I'm trying to predict
set.seed(1000)
install.packages('randomForest')
library(randomForest)
RFb = randomForest(isB ~ .-letter,data=train)
predictions = predict(RFb, newdata=test)
table(test$isB,predictions)
accuracyRFb = sum(diag(table(test$isB,predictions)))/nrow(test)
#Accuracy 98% RANDOM FOREST
#Note that random forest tends to improve on CART in terms of predictive accuracy




#Predicting whether a letter is A,B,P,R
#Data preparation
letters$letter = as.factor(letters$letter)
split = sample.split(letters$letter,SplitRatio = 0.5)
train2 = subset(letters, split==TRUE)
test2 = subset(letters,split==FALSE)
#In a multiclassification problem, a simple baseline model is to predict the most frequent class of all of the options. 
#Baseline accuracy on testing set 
#Need to figure out which is the most frequent outcome in the training set 
table(train2$letter)
#P has the most observations
#Need to predict P for all letters 
table(test2$letter)
#Test set accuracy of the baseline method is:
401/nrow(test)
#25% Accuracy BASELINE MODEL

#Building classification tree to predict "letter"
multiTree = rpart(letter ~ .-isB,data=train2,method='class')
#Test set accuracy of my CART model 
#Use a confusion matrix for this to add everything in the main diagonal 
multiTreepred = predict(multiTree,newdata=test2,type='class')
table(test2$letter,multiTreepred)
accuracy.multiTree = sum(diag(table(test2$letter,multiTreepred)))/nrow(test)
#ACCURACY OF CART TREE: 86%

#Building Random FOrest Model on Training Data 
set.seed(1000)
RFtree = randomForest(letter ~ .-isB, data=train2)
RFtreepred = predict(RFtree,newdata=test2)
table(test2$letter,RFtreepred)
accuracy.RFtree = sum(diag(table(test2$letter,RFtreepred)))/nrow(test)
#Accuracy of Random Forest tree is 98%






