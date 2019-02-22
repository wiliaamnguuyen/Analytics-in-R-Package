statedata = read.csv("statedataSimple.csv")
statedata = data.frame(state.x77)

#Linear Regression Model 
lm = lm(Life.Exp ~.,data=statedata)
#Sum of Squared Errors (SSE) between predicted life expectancies using this model and actual life expectancies
lmpred = predict(lm)
SSElm = sum((lmpred-statedata$Life.Exp)^2)
#OR
SSElm = sum(lm$residuals^2)

lm2 = lm(Life.Exp ~ Population + Murder + Frost + HS.Grad,data=statedata)
summary(lm2)
SSElm2 = sum(lm2$residuals^2)

#Regression Tree
library(rpart)
library(rpart.plot)
tree = rpart(Life.Exp ~ .,data=statedata)
prp(tree)

#Using this tree to predict life expectancies
treepred = predict(tree)
#SSE
SSEtree = sum((treepred-statedata$Life.Exp)^2)

#Rebuilding a larger tree since its error is higher than linear regression 
tree2 = rpart(Life.Exp~.,data=statedata,minbucket=5)
prp(tree2)
treepred2 = predict(tree2)
SSEtree2 = sum((treepred2 - statedata$Life.Exp)^2)

#Can I do a better model? 
tree3 = rpart(Life.Exp ~ Area, data=statedata, minbucket=1)
treepred3 = predict(tree3)
SSEtree3 = sum((treepred3-statedata$Life.Exp)^2)


#CROSS VALIDATION
library(caret)
set.seed(111)
#Telling my model that I am using k-fold cross validation
#Setting up cross validation controls
fitControl = trainControl(method = 'cv', number = 10)
cartGrid = expand.grid(.cp=seq(0.01,0.5,0.01))
#Using train function to determine the best cp value for a CART model
train(Life.Exp ~.,data=statedata,method='rpart',trControl = fitControl,tuneGrid=cartGrid)
#Best value of cp is 0.12

#Creating a tree with this cp value 
CARTmodel = rpart(Life.Exp ~ .,data=statedata,cp=0.12)
#SSE of this new model 
CARTmodelpred =predict(CARTmodel)
SSECART = sum((CARTmodelpred-statedata$Life.Exp)^2)
#SSE = 32.856

#Creating tree where independent variables are Area 
set.seed(111)
fitControl = trainControl(method='cv',number=10)
cartGrid = expand.grid(.cp=seq(0.01,0.5,0.01))
train(Life.Exp ~ Area, data=statedata,method='rpart',trControl = fitControl,tuneGrid=cartGrid)
#Best cp value is 0.01
tree4 = rpart(Life.Exp ~ Area, data=statedata,cp=0.01)
prp(tree4)
#I am simplifying this model using cross-validation
#SSE of this cross-validated "Area Tree"
tree4pred = predict(tree4)
SSEtree4 = sum((tree4pred - statedata$Life.Exp)^2)
#Area variable isn't as predictive as Murder rate
#Original area tree was overfitting the data (uninterreptable)
#Area isn't as useful as Murder rate
#Cross-validation isn't designed to improve the fit on data; it won't make it worse either
#Cross validation can't guarantee improving the SSE on unseen data 