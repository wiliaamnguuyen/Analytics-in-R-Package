#Creating first model 
#Read the dataset into R
climate_change = read.csv("climate_change.csv")
#Split into training data and test data using subset function
#subset normally takes 2 arguments, the dataframe you're subsetting 
#and the condition of what data to subset
training_set = subset(climate_change, Year <=2006)
test_set = subset(climate_change, Year>2006)

#Build regression model to predict dependent variable Temp
#Use training set to the build the model 
climate_model = lm(Temp ~ MEI + CO2 + CH4 + N2O + CFC.11 + CFC.12 + TSI + Aerosols, data = climate_change)
#Check Multiple R-Squared value
summary(climate_model)

#Correlations between all variables in the training set
#Find which independent variables is highly correlated with N20
#Note, absolute correlation greater than 0.7 shows variables are highly correlated
#In order to calculate correlations at once, use cor(training_set)
cor(training_set)

#Simplifying model without highly correlated variables 
climate_model2 = lm(Temp ~ N2O + MEI + TSI + Aerosols, data=climate_change)

#Using step function to create an automated simplified model 
step_model = step(climate_model)
summary(step_model)

#Testing step model on test set data to calculate temp predictions 
tempPredict = predict(step_model, newdata = test_set)
SSE = sum((tempPredict - test_set$Temp)^2)
SST = sum((mean(training_set$Temp)-test_set$Temp)^2)
R2 = 1 - (SSE/SST)





















