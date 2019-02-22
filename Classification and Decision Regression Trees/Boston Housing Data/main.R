boston = read.csv("boston.csv")
str(boston)

#Building a model of how prices vary by location across a region
plot(boston$LON,boston$LAT)
#The density in the middle of the plot corresponds to the cities.

#Finding out which areas lie near the CHAS river
points(boston$LON[boston$CHAS==1],boston$LAT[boston$CHAS==1],col='blue',pch=19)
#The blue dots represent the census tracts that lie along the Charles River

#Adding another point to represent location of MIT (census tract=3531)
points(boston$LON[boston$TRACT==3531],boston$LAT[boston$TRACT==3531],col='red',pch=19)

#Investigating how air pollution affects housing prices
#Air pollution variable is NOX
summary(boston$NOX)
#Looking into the census tracts (areas) that have above-average pollution
points(boston$LON[boston$NOX>=0.55],boston$LAT[boston$NOX>=0.55],col='green',pch=19)

#Looking into how prices vary throughout the area
#Resetting plot
plot(boston$LON,boston$LAT)
summary(boston$MEDV)
#Plotting above-average price points
points(boston$LON[boston$MEDV>=21.2],boston$LAT[boston$MEDV>=21.2],col='red',pch=19)
#From the graph, above-average and low-average prices are mixed in with each other. Not simple. 
#Housing prices from the red point plot, shows a non-linear distribution over the area. 

#Resetting plot to plot relationship between house prices and lon/lat
plot(boston$LON,boston$MEDV)
plot(boston$LAT,boston$MEDV)
#I will try fitting linear regression as an example 
latlonlm = lm(MEDV ~ LAT + LON, data=boston)
summary(latlonlm)
#Latitude is not significant (north south is not useful)
#Bad R Squared 0.1 
plot(boston$LON,boston$LAT)
#Median values with the above medium value census tracts  


#Investigating to what my linear model thinks is above median
latlonlm$fitted.values
#This is what my model predicts (housing prices) for each of my 506 census tracts
#Keep in mind, I want to plot the linear regression dots but still see the actual red dots
#I'm interested in seeing how linear regression compares to the actual values
#Need to find a way to make sure I can still see the blue and red dots. 
points(boston$LON[latlonlm$fitted.values>=21.2],boston$LAT[latlonlm$fitted.values>=21.2],col='blue',pch="$")
#Graph shows linear regression plotting a blue dot each time a census tract exceeds median value
#Graph looks vertical, and this is because latitude variable was not very significant in the regression
#This is interesting and wrong. Linear regression isn't doing a good since it ignored everything on the right side of the graph 


#Regression Trees 
library(rpart)
library(rpart.plot)
latlontree = rpart(MEDV ~ LAT + LON, data = boston)
prp(latlontree)
#In regression trees, the leaves predict the number
#That number is the average median house price in that leaf
plot(boston$LON,boston$LAT)
#Plotting the above average median house price
points(boston$LON[boston$MEDV>=21.2],boston$LAT[boston$MEDV>=21.2],col='red',pch=19)
#I want to predict what the Tree model thinks is "above median" just like I did with the linear regression model
fitted.values = predict(latlontree)
points(boston$LON[fitted.values>=21.2],boston$LAT[fitted.values>21.2],color='blue',pch="$")
#This model does a much better job and have managed to correctly classify some of those points
#This is good since this model is able to make nonlinear predictions on latitude and longitude. 

#Can I make a simpler tree? 
#Change the minbucket size
latlontree = rpart(MEDV ~ LAT + LON,data=boston,minbucket=50)
plot(latlontree)
text(latlontree)
#This has far fewer splits and it's far more interpretable 
plot(boston$LON,boston$LAT)
#First split of the tree
abline(v=-71.07)
abline(h=42.21)
abline(h=42.17)
points(boston$LON[boston$MEDV>=21.2],boston$LAT[boston$MEDV>=21.2],col='red',pch=19)
#I am demonstrating here, how the regression trees carves out that right middle rectangle in the bottom of Boston 
#and says that is a low value area 
#Regression trees can do things that linear regression can't do
points(boston$LON[boston$MEDV>=21.2],boston$LAT[boston$MEDV>=21.2],col='red',pch=19)


#Looking to see if my model can predict things better than linear regression
#Predicting house prices using all the variables
library(caTools)
#Setting seed for the results to be reproducible 
set.seed(123)
split = sample.split(boston$MEDV,SplitRatio = 0.7)
train = subset(boston, split==TRUE)
test = subset(boston,split==FALSE)

linreg = lm(MEDV ~ LAT+LON+CRIM+ZN+INDUS+CHAS+NOX+RM+AGE+DIS+RAD+TAX+PTRATIO,data=train)
summary(linreg)
#longitude and latitude is not significant for linear regression model 
#R-Squared is good(0.65).

linreg.pred = predict(linreg,newdata = test)
#Sum of Squared Errors = sum(predicted values - actual values)**2
linreg.sse = sum((linreg.pred-test$MEDV)**2)
linreg.sse
#SSE = 3037.088 (linear regression)

#Creating a regression tree model to beat this SSE
tree = rpart(MEDV ~ LAT+LON+CRIM+ZN+INDUS+CHAS+NOX+RM+AGE+DIS+RAD+TAX+PTRATIO,data=train)
prp(tree)
#Tree shows longitude and latitude isn't important 
#The tree shows **room** is the most important plot
#Pollution appears in twice, crime and age also. 
#Investigating how my model does compared to linear regression
tree.pred = predict(tree,newdata=test)
#Sum of Squared Errors is the sum of tree's predictions versus what they should be 
tree.sse = sum((tree.pred-test$MEDV)**2)
tree.sse
#SSE = 4328. 
#Regression trees are not as good as linear regression for this problem. 


#Building my tree model using cross validation
library(caret)
library(e1071)
#Telling my caret package exactly how I want to do my parameter tuning 
#Restricting myself to a 10-fold cross validation 
tr.control = trainControl(method='class',number=10)
#Telling caret which range of cp parameters to test/0<cp<1

#Creating a grid of cp values to test
cp.grid = seq(0,0.01,0.001)
#storing results of the cross validation fitting in a variable
tr = train(MEDV ~ LAT+LON+CRIM+ZN+INDUS+CHAS+NOX+RM+AGE+DIS+RAD+TAX+PTRATIO,data=train,method='rpart',trControl=tr.control,tuneGrid=cp.grid)
#Using trees (rpart), and tuning grid is trying all the different values of cp that I asked it to do
#It decided that cp=0.001 was the best because it had the best RMSE (root mean squared error)

best.tree = tr$finalModel
prp(best.tree)
best.tree.pred=predict(best.tree,newdata=test)
best.tree.sse=sum((best.tree.pred-test$MEDV)^2)
best.tree.sse
#This tree is better on the testing set
#Always try cross validating them to get as much performance out of them as you can