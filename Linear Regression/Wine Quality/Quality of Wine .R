wine = read.csv("wine.csv")
str(wine)
summary(wine)

# Creating one-variable linear regression equation
# Call our regression model, called model1
# Use the lm() function whenever you want to build a linear regression model

model1 = lm(Price ~ AGST, data = wine)
summary(model1)

#To calculate SSE, we need to know our residuals/error terms
model1$residuals
SSE = sum(model1$residuals^2)

#Adding another variable to our regression model
model2 = lm(Price ~ AGST + HarvestRain, data = wine)
summary(model2)
SSE = sum(model2$residual^2)

#Adding all variables, to predict price based on independent variables
model3 = lm(Price ~ AGST + HarvestRain + WinterRain + Age + FrancePop, data=wine)
summary(model3)
SSE = sum(model3$residuals^2)

#Create Linear Regression Model to predict Price using Harvest Rain and WinterRain (independent)
#Find the Multiple R-Squared
new_model = lm(Price ~ HarvestRain + WinterRain, data = wine)
summary(new_model)
#Observation: The coefficient for HarvestRain is significant (two stars)


#Removing insignificant variables from model 
model4 = lm(Price ~ AGST + HarvestRain + WinterRain + Age, data=wine)
summary(model4)


#Computing correlation between WinterRain and Price
cor(wine$WinterRain, wine$Price)
#Answer = 0.13

#Correlation between age and France Population
cor(wine$Age, wine$FrancePop)
#Answer= 0.99, thus highly related

#Computing correlation between all variables in data
cor(wine)


#Removing two insignificant variables at the same time rather than one at a time to demonstrate
#why removing all insignificant variables isn't good 
model5 = lm(Price~ AGST+HarvestRain+WinterRain, data=wine)
summary(model5)
#Observation:AGST, HarvestRain, WinterRain coefficients table shows significance
#However, our Multiple R-Squared has dropped to 0.75. 
#Thus, had we removed Age and FrancePop at the same time, we would have missed a significant variable
#Thus, R-Squared in our final model would have been lower 
#Why didn't we keep FrancePopulation instead of Age? We intuitively expect older wine to be more expensive

#Correlation between HarvestRain and WinterRain
cor(wine$HarvestRain,wine$WinterRain)

#Testing data
wineTest = read.csv("wine_test.csv")
str(wineTest)
predictTest = predict(model4, newdata=wineTest)

#Finding R Squared
SSE = sum((wineTest$Price - predictTest)^2)
SST = sum((wineTest$Price - mean(wine$Price))^2)
R_Squared = 1 - (SSE/SST)































