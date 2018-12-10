NBA = read.csv("NBA_train.csv")
#Exploring the dataset 
str(NBA)

#how many games to winin order to make the playoffs? 
table(NBA$W,NBA$Playoffs)
#Results shows a team won 17 games and all 11 times team didn't make it to playoffs
#Another team shows a team with 61 wins then 10 of those times made it to playoffs and 0 times they didn't

#Difference of points between PS and PA can be used to predict no. games team will win
#add variable 
NBA$PTSdiff = NBA$PTS - NBA$oppPTS
#Create scatterplot to see if there's a linear relationship between number of team wins and point difference
plot(NBA$PTSdiff, NBA$W)
#incredibly strong linear relationship between 2 vriables 
#there seems linear regression is going to be a good way to predict how many wins a team will have given the point difference
#Independent variable: PTS diff | Dependent variable: Wins 
WinsReg = lm(W ~ PTSdiff, data = NBA)
summary(WinsReg)
#High R-Squared due to strong linear relationship between variables, significant variables

#Regression model to predict points scored regressing on the independent variables
PointsReg = lm(PTS ~ X2PA + X3PA + FTA + AST + ORB + DRB + TOV + STL + BLK, data = NBA)
summary(PointsReg)
#Some variables are significant, others are less significant 
#Steals only has one star significance star
#Defensive rebounds, turnovers and blocks aren't significant at all
#Strong R-Squared value due to strong linear relationship between points scored and all of the basketball stats


#Computing the residuals to compute sum of squared errors SSE
SSE = sum(PointsReg$residuals^2)
#SSE is very large. Not an interpretable quantity 
#Calculate root mean squared error (more interpretable)
#RMSE is sqrt(SSE/n), where n is number of rows in dataset
RMSE = sqrt(SSE/nrow(NBA))
#RMSE shows on average, we make an error of about 184.4 points which is a lot BUT
#Average no. points scored during season
mean(NBA$PTS)
#8370 points


#Need to improve model since not all variables are significant ONE at a time 
summary(PointsReg)
#remove variable Turnover since it has highest p-value is 0.6859 (least significant)
PointsReg2 = lm(PTS ~ X2PA + X3PA + FTA + AST + ORB + DRB + STL + BLK, data = NBA)
#R-Squared decreased slightly
#Remove turnovers variable due to insignicant variable (high p-value)
PointsReg3 = lm(PTS ~ X2PA + X3PA + FTA + AST + ORB + STL + BLK, data = NBA)
summary(PointsReg3)
#R-Squared decreased slightly. Remove defensive rebounds
PointsReg4 = lm(PTS ~ X2PA + X3PA + FTA + AST + ORB + STL, data = NBA)
summary(PointsReg4)
#R-Squared value stayed about the same. We have significant variables left 

#Check SSE and RMSE to make sure it has not increased 
#Previous SSE and RMSE was 28394314 and 184.4 respectively before 
SSE_4 = sum(PointsReg4$residuals^2)
RMSE_4 = sqrt(SSE_4/nrow(NBA))
#SSE_4 is not interpretable, RMSE_4 is increased from removing variables (small amount)
#Narrowed down on a simpler model

#MAKING PREDICTIONS FOR 2012-2013
#Load test set since training set only includes data 1980-2011
NBA_test = read.csv("NBA_test.csv")
#Predict how many points we'll see in 2012-2013 season 
PointsPredictions = predict(PointsReg4, newdata = NBA_test)
#Compute SSE for out-of sample R-Squared for this test data 
SSE = sum((PointsPredictions - NBA_test$PTS)^2)
SST = sum((mean(NBA$PTS)-NBA_test$PTS)^2)
R2 = 1 - (SSE/SST)
#Calculate RMSE
RMSE = sqrt(SSE/nrow(NBA_test))
#An average error of about 196 points





















