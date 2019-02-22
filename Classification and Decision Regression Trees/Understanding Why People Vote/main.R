gerber = read.csv("gerber.csv")
table(gerber$voting)
#Propotion of people who voted in this election
108696/(108696+235388)

#Building logistic regression model for voting using the 4 treatment groups as independent variables
logreg = glm(voting ~ civicduty+hawthorne+self+neighbors,data=gerber,family='binomial')
summary(logreg)
#Observations: All variables are significant

#Using threshold 0.3, I investigated the accuracy of this model 
predictLog =predict(logreg,type='response')
#Table function to create confusion matrix
table(gerber$voting,predictLog>0.3)
#Compute accuracy = sum of true positives and true negatives divided by sum of all numbers
accuracyLog = (134513+51966)/(134513+51966+100875+56730)
#54% accuracy

#Adjusting threshold to 0.5 to look into accuracy again 
predictLog=predict(logreg,type='response')
table(gerber$voting,predictLog>0.5)
accuracyLog2 = 0.684
#Accuracy 68%


#Computing the AUC of the model (baseline accuracy) -- people who didn't vote
library(ROCR)
ROCRpred = prediction(predictLog,gerber$voting)
as.numeric(performance(ROCRpred,"auc")@y.values)
#53% accuracy 
#Even though, all the variables in my logistic regression model were significant, my model 
#my model doesn't improve over the baseline model of just predicting that someone will not vote
#AUC is low
#Treatment groups does make a difference, but this is a weak predictive model



#Testing out tree models 
#Building a CART tree for voting using all data and same 4 treatment variables 
#I am not setting option method='class'
#I am actually going to be creating a regression tree
#I am interested in building a tree to explore fraction of people who vote or probability of voting 
CARTmodel = rpart(voting~civicduty+hawthorne+self+neighbors,data=gerber)
prp(CARTmodel)
#No variables are used (tree is only a root node) - none of the variables make a big enough effect to be split on


#Building 2nd cart model to force the complete tree to be built 
CARTmodel2 = rpart(voting ~ civicduty + hawthorne + self + neighbors, data=gerber,cp=0.0)
prp(CARTmodel2)

#Including the sex variable in my tree
CARTmodel3 = rpart(voting ~ civicduty + hawthorne + self + neighbors + sex, data=gerber,cp=0.0)
prp(CARTmodel3)
#Men have a higher voting percentage 



#Focusing on the "Control" treatment group
#Creating regression tree using the control variable 
CARTcontrol = rpart(voting ~ control, data=gerber, cp=0.0)
prp(CARTcontrol,digits=6)
#Absolute difference between predicted probability of voting in control group vs being in a different group
#If control=1, predict 0.29; if control = 0, predict 0.34
abs(0.29-0.34)


#Then another tree with "control" and "sex"variables, both with cp=0.0
#Investigating who's affected MORE by not being in the control group
CARTsex = rpart(voting ~ control + sex, data=gerber, cp=0.0)
prp(CARTsex,digits=6)
#If control =1 (first split), go left. 
#If sex=1(women) predict 0.29, if sex=0; predict 0.30
#On the other side, control=0; if sex=1 (female), predict 0.33; if sex=0(male) predict 0.34
#Men and women are affected about the same in terms of voting 


#Logistic Regression Model including variables "sex" and "control"
LogModelSex = glm(voting~control+sex,data=gerber, family='binomial')
summary(LogModelSex)
#Negative coefficient for sex reflecting that women are less likely to vote (CONTRAST)

#Regression tree calculated the percentage voting exactly for every 4 possibilities
#However, logistic regression on the 'sex' and 'control' variables consider these variables separately, not jointly
#Thus, logistic regression doesn't do that well. 

#Creating a dataframe containing all possible values of sex and control
#Evaluating my logistic regression model using predict function 
Possibilities = data.frame(sex=c(0,0,1,1),control=c(0,1,0,1))
predict(LogModelSex,newdata=Possibilities,type='response')
#4 values correspond to 4 possibilities (Man,Not Control),(Man<Control)....
#CART Tree predicts 0.290456 for (Woman Control) case
#Logistic Regression Model) predicts 0.2908065
#The difference between two models isn't too big for this dataset, but there is still a difference. 

#Adding a new term into logistic regression model
#This variable is the combination of the "sex" and "control variable
#Variable named: sex:control
#If sex:control ==1, then person is a woman AND in the control group
LogModel2 = glm(voting~control+sex+sex:control,data=gerber, family='binomial')
summary(LogModel2)
#sex:control has a negative coeffcient 
#If a person is a woman AND in control group, the chance that she voted goes down. 
predict(LogModel2,newdata=Possibilities,type='response')
#CART model predicts 0.2904558 for (Woman,Control) case
#Small difference (practically 0) between CART and logistic regression 


















