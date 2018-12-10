elantra = read.csv("elantra.csv")
training_set = subset(elantra, Year <= 2012)
testing_set = subset(elantra, Year > 2012)
#observing how many observations are in training set
nrow(training_set)

#Linear Regression model to predict monthly Elantra sales 
LinReg = lm(ElantraSales ~ Unemployment + CPI_all + CPI_energy + Queries, data = training_set)
summary(LinReg)
#Multiple R-Squared = 0.43
#Model R-Squared is low
#Need to improve. 

#Adding month variable to model
LinReg2 = lm(ElantraSales ~ Month + Unemployment + Queries + CPI_energy + CPI_all, data=elantra)
summary(LinReg2)

#New regression model with Month variable as a factor variable 
training_set$MonthFactor = as.factor(training_set$Month)
testing_set$MonthFactor = as.factor(testing_set$Month)
LinReg3 = lm(ElantraSales ~ Unemployment + Queries + CPI_energy + CPI_all + MonthFactor, data= training_set)
summary(LinReg3)

#Calculating correlation to check multicollinearity issue since changes in coefficients signs
cor(training_set[c("Unemployment","Month","Queries","CPI_energy","CPI_all")])

#Simplifying model 
LinReg4 = lm(ElantraSales ~ Unemployment + CPI_energy + CPI_all + MonthFactor, data=training_set)
summary(LinReg4)

#Sum of Squared Errors 
PredTest = predict(LinReg4, newdata = testing_set)
SSE = sum((PredTest - testing_set)^2)
