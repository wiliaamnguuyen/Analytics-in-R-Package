statedata = read.csv("statedata.csv")
str(statedata)

#Exploring the dataset for fun!
plot(statedata$x,statedata$y)
#bserve which region has highest average high school graduation rates of all the states in region
tapply(statedata$HS.Grad,statedata$state.region,mean)

#visualisation of murder rate by region 
boxplot(statedata$Murder ~ statedata$state.region)

#Looking into Northeast Data to identify outlier state
NortheastData = subset(statedata, state.region=="Northeast")
boxplot(NortheastData$Murder ~ NortheastData$state.abb)
#New York has outlier murder rate

#Predicting life expectancy 
linReg = lm(Life.Exp ~ Population+Income+Illiteracy+Murder+HS.Grad+Frost+Area, data=statedata)
#Plotting graph between income and life expectancy (what we're predicting)
plot(statedata$Income,statedata$Life.Exp)

#Refining the model
linReg = lm(Life.Exp ~ Population+Income+Illiteracy+Murder+HS.Grad+Frost, data=statedata)
summary(linReg)
linReg = lm(Life.Exp ~ Population+Income+Murder+HS.Grad+Frost, data=statedata)
summary(linReg)
linReg = lm(Life.Exp ~ Population+Murder+HS.Grad+Frost, data=statedata)
summary(linReg)


#Analyse how predictions compare to actual values
PredTest = sort(predict(linReg))
statedata$state.name[1]
#Predictions shows Alabama has the lowest life expectancy
#Actual values 
actual_Value = which.min(statedata$Life.Exp)
statedata$state.name[actual_Value]


#Observing predictions of state that has high life expectancy 
PredTest = sort(predict(linReg))
statedata$state.name[47]
#predictions shows washington has highest life exp.
#Actual data shows 
x = which.max(statedata$Life.Exp)
statedata$state.name[x]

#Vector residuals is difference between predicted and actual values
#Sort the list of absolute errors 
sort(abs(linReg$residuals))
largest_state_errors = statedata$state.name[11]
smallest_state_errors = statedata$state.name[14]

