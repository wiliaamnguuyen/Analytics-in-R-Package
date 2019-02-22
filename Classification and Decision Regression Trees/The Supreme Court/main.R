stevens <- read.csv("stevens.csv")
str(stevens)
#Reverse is the independent variable whether Stevens reverse the 
#case (1=reverse, affirm=0)

#Before building a model, I am splitting data into training and test set
#Using the sample.split() function
#load caTools package
library(caTools)
set.seed(3000)
#Putting 70% of the data in the training set
split = sample.split(stevens$Reverse, SplitRatio = 0.7)
#using the subset function to create train/test set
Train = subset(stevens, split == TRUE)
Test = subset(stevens, split == FALSE)

#To build the CART model, installing rpart plotting package
#Uncomment the line below if you haven't installed the packages
install.packages("rpart")
library(rpart)
install.packages("rpart.plot")
library(rpart.plot)

#Creating CART model using rpart function 
#Telling the rpart function with arguments to build classification tree instead of regression tree
#Last argument will give is minbucket = 25; this limits tree so it doesn't overfit training set
#I selected value 25
StevensTree = rpart(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data = Train, method = "class", minbucket = 25)
#Plotting the tree using PRP function
prp(StevensTree)

#seeing how well my CART model does in making decisions 
PredictCART = predict(StevensTree,newdata = Test,type ="class")

#Computing accuracy of model by building a confusion matrix
#First true outcome argument and second will be my predictions
table(Test$Reverse,PredictCART)
Accuracy = (41+71)/(41+36+22+71)

#Plotting ROCR package
library(ROCR)
PredictROCR = predict(StevensTree, newdata=Test)
#gives each observation in test set; giving two numbers (probabilities) for outcome 0/1
#generating ROC curve using prediction() function with 2nd column as our probabilities
pred = prediction(PredictROCR[,2],Test$Reverse)
#Arguments for performance() function is prediction function -> true positive rate -> false positive rate
#Essentially what you want on the ROC curve x axes and y axes 
perf = performance(pred,"tpr","fpr")
plot(perf)

#Computing AUC of CART model 
auc = as.numeric(performance(pred,"auc")@y.values)



#Building a model with minbucket parameter of 5
model = rpart(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data=Train, method = "class", minbucket=5)
prp(model)
#16 splits; tree is porbbaly overfit to training data
#not as interpretable

#minbucket =100
model2 = rpart(Reverse~Circuit+Issue+Petitioner+Respondent+LowerCourt+Unconst,data=Train,method = "class",minbucket=100)
prp(model2)
#only 1 split, thus tree doesn't probably fit well enough to training data. 

#Using random forest model to predict the decisions of Justice Stevens 
install.packages("randomForest")
library(randomForest)


#Regarding the classification problem, converting the dependent variable must be a factor
Train$Reverse = as.factor(Train$Reverse)
Test$Reverse = as.factor(Test$Reverse)
#Creating the random forest bottle
StevensForest = randomForest(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data=Train, nodesize = 25, ntree = 200)

#Making predictions using my model
PredictForest = predict(StevensForest, newdata = Test)
#I want to look at the accuracy of my predictions by computing a confusion matrix 
table(Test$Reverse,PredictForest)
#Accuracy is 67%


#Creating different random forest models to demonstrate different answers from setting random seed 
set.seed(100)
split = sample.split(stevens$Reverse, SplitRatio = 0.7)
Train = subset(stevens, split == TRUE)
Test = subset (stevens, split == FALSE)
randomForest100 = randomForest(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data=Train, ntree = 200, nodesize = 25)
predictForest100 = predict(randomForest100,newdata=Test)
table(Test$Reverse,predictForest100)
#Accuracy for more stable dataset will not very change much, but a noisy dataset can be affected by random samples


#selecting cp value by using cross validation for CART tree
install.packages("caret")
library(caret)
install.packages("e1071")
library(e1071)

#Defining cross validation experiment 
#Firstly, need to define how many folds I want 
#I used the train control function
numFolds = trainControl(method = "cv", number = 10)
cpGrid = expand.grid(.cp=seq(0.01,0.5,0.01))

#Performing cross validation
train(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data = Train, method = "rpart", trControl = numFolds, tuneGrid=cpGrid)

#Creating CART model with new cp value instead of minbucket
StevensTreeCV = rpart(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data=Train, method="class",cp=0.18)
#Making predictions on my test set using this model 
PredictCV = predict(StevensTreeCV, newdata = Test, type = "class")
#Creating confusion matrix to find the accuracy of the model 
table(Test$Reverse,PredictCV)
accuracy = (45+66)/(45+32+27+66)

#Plotting the tree I created using cross-validation
prp(StevensTreeCV)
#Tree with best accuracy only has one split















