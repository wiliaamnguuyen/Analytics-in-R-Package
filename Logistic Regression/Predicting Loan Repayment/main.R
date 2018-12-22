#Flying with Data
loans = read.csv("loans.csv")
str(loans)
summary(loans)

#Proportion of loans were not paid in full
table(loans$not.fully.paid)
proportion_not_paid = 1533/(1533+8045)

#Analyzing loans with missing data 
#Building a dataframe limited to observations with missing data
missing = subset(loans,is.na(log.annual.inc) | is.na(days.with.cr.line) | is.na(revol.util) | is.na(inq.last.6mths) | is.na(delinq.2yrs) | is.na(pub.rec))
nrow(missing)
#Only 62 observations of 9578 loans have missing data
#Removing this small number of observations would not lead to overfitting
table(loans$not.fully.paid)
#I see 12 of 62 loans with missing data weren't fully paid, 20%
#However, to predict risk for loans with missing data I need to fill in missing values instead of removing observations


#Filling in missing values filled in with multiple imputation
library(mice)
set.seed(144)
vars.for.imputation = setdiff(names(loans),"not.fully.paid")
imputed = complete(mice(loans[vars.for.imputation]))
loans[vars.for.imputation] = imputed

#Split into training and testing set 
library(caTools)
split = sample.split(loans$not.fully.paid,SplitRatio = 0.7)
train = subset(loans, split==TRUE)
test = subset(loans,split==FALSE)

#Using logistic regression to train on training set to predict dependent variable using all independent variables 
model1 = glm(not.fully.paid ~., data = train, family=binomial)
summary(model1)

#Predicting the probability of the test set loans not being paid back in full
predTest = predict(model1, newdata = test, type="response")
#Confusion matrix
table(test$not.fully.paid,predTest>=0.5)
#Accuracy of the model 
Accuracy = (2406+21)/(7+2406+439+21)
#Accuracy of baseline model 
table(test$not.fully.paid)


#Bivariate model 
bivariate = glm(not.fully.paid ~int.rate,data=train,family=binomial)
summary(bivariate)
#Making test set predictions for bivariate model 
predTest = predict(bivariate,newdata = test, type="response")
summary(predTest)
table(test$not.fully.paid,predTest>=0.5)

#Computing test set AUC of the bivariate model
library(ROCR)
prediction.bivariate = prediction(predTest, test$not.fully.paid)
as.numeric(performance(prediction.bivariate,"auc")@y.values)


#Investment strategy on risk
#Analyzing my investment strategy where investors only purchase loans with high interest rates (15%)
#importantly, also select loans where lowest predicted risk of not being paid back in full
highInterest = subset(test,int.rate>=0.15)
summary(highInterest$profit)
#Proportion of this high-interest loans not paid back in full? 
table(highInterest$not.fully.paid)

#But what's the smallest predicted risk probability of not paying in full loans? 
cutoff = sort(highInterest$predicted.risk,decreasing = FALSE)[100]
selectedLoans = subset(highInterest,predicted.risk <=cutoff)
nrow(selectedLoans)
#100 loans 
sum(selectedLoans$profit)
#Profit for all 100 loans, but I want to investigate how many of this 100 selected loans were not paid back in full
table(selectedLoans$not.fully.paid)











#Investment Strategy
test$profit = exp(test$int.rate*3)-1
test$profit[test$not.fully.paid ==1] = -1
summary(test$profit)
#Every for every dollar investment, you will get 88 cents














