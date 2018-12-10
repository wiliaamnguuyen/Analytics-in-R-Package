# Moneyball to NBA #
## The Data ##
The data is imported from the National Basketball Association (NBA). 
-	The data contains data from all teams in season since 1980 except for ones with less than 82 games
    -	**Playoffs** is a binary variable for whether a team made it to the playoffs that year. If they made it to the playoffs, it’s a 1, if not it’s a 0.
    -	**SeasonEnd** variable is the year the season ended
    -	**W** stands for the number of regular seasons wins 
    -	**PTS** stands for points scored during the regular season
    -	**oppPTS** stands for opponent points scored during the regular season 
-	Note: The notation for ‘A’ it means the number that were attempted and if not, it means the number that was successful. E.g. FG is number of successful goals (two & three pointers) and FGA is the number of field goal attempts (also contains the number of unsuccessful field goals). 

## Playoffs and Win ##
### Goal ### 
The basketball team is to make the playoffs. 
**_How many games does a team need to win in order to make the playoffs?_**
-	In basketball, games are won by scoring more points than the other team. 
-	Can we use difference between points scored and points allowed throughout the regular season in order to predict the number of games that a team will win?
-	**With the regression equation: W = 41 + 0.0326*(PTSdiff) >= 42**
-	We need to win at least 42 games to have a good chance to make it to the playoffs. Find the point difference
-	**PTSdiff >= (42-41)/0.0326 = 30.67**
-	Need to at least score 31 points in order to win at least 42 games

## Points Scored ##
### Goal ### 
I built an equation to predict points scored using some common basketball statistics. 
-	**Dependent variable:** PTS | Independent variable: Common basketball statistics. E.g. Two-point field goal attempts, no. of three-point field goal attempts, offensive rebounds, defensive rebounds, assists, steals, blocks, turnovers, free throw attempts
-	When creating a new regression model, always and always look at its statistical summary. 

## Making Predictions ##
### Goal ###
We’ll need to make predictions for 2012-2013 season points scored and compute the out of sample R-Squared. 
-	Use the predict function with arguments of regression model (that determines points scored) and “newdata =” argument which is the test set. 
-	The R-Squared value for our model before is 0.8991; this is a measure of an in-sample R-Squared, which is how well the model fits the training data. 
-	To get a good measure of the predictions, we need to calculate the out-of sample R-Squared. Thus, compute the sum of squared errors. 
