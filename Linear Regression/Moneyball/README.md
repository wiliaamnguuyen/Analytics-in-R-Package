# Moneyball #

## Story of Moneyball ##
This data comes from [Baseball Reference](Baseball-Reference.com)

Moneyball is a book by Michael Lewis (2003). 
- It discusses how sports analytics changed baseball. 
- The story of Oakland A’s were once a rich team, but the team was purchased by owners who enforced strict budget cuts; thus with new ownership and budget cuts in 1995, Oakland A’s were one of the poorest teams in baseball. . 
- Despite this, they were improving from years 1997-2001. 
- This puzzled many baseball experts who thought it was just luck. 
- In 2002, the A’s lost 3 key players. The key question is: 
    -	Could they continue winning without them?

The problem?
-	Rich teams can afford the all-star players. How do the poor teams compete? 
-	A graph showing “Salaries Vs Wins” shows highly paid players provided a higher average yearly win rate. 
    - For example, the New York Yankees won about 100 games and spent roughly $90 million during this period. Red Sox spent about $80 million and won about 90 games. 
    - However, the A’s won about 90 games and they spent under $30 million; they won about the same number of games during this period but the Red Sox spent more about $50 million more per year than the A’s. 
    - Clearly, rich teams like the Yankees and the Red Sox can afford all-star players but observe how efficient the A’s are. 
    - They won 90 games and their payroll was under $30 million compared to the Yankees, who spent almost 3-4 times, and they won a bit much more games.  
-	How do they do this? They took a quantitative approach, an analytics approach, they were able to find undervalued players and form teams that were very efficient. 

### A Different Approach ###
The A’s started using a different method to scout players
-	The traditional way was through scouting
    - Scouts would go watch high school and college players
    - Report back about their skills 
    - A lot of talk about speed and athletic build
-	The A’s selected players based on their statistics rather than looks. 
> “The statistics enable you to find your way past all sorts of sight-based scouting prejudices.”
> Billy Beane (Oakland A’s manager). “We are not selling jeans here.”

### Taking a Quantitative View ###
-	Paul DePodesta (Beane’s assistant) spent a lot of time looking at the data
- His analysis suggested that some skills were undervalued, and some skills were overvalued 
-	If they could detect the undervalued skills, they could find players at a bargain. 

## Making it to the Playoffs ##
The goal of the baseball team is to make the playoffs. The A’s approach way to get to the playoffs by using analytics. 
1.	Make Playoffs: First find how we can predict whether or not a team will make the playoffs by knowing how many games they won in the regular season. 
    -	How many games a team needs to win to make the playoffs. 
2.	Win Games: Use linear regression to predict how many games a team will win using the difference between runs scored and runs allowed, or opponent runs 
    -	How many more runs a team needs to score than their opponent to win that many games
3.	Score More Runs than Opponent: Use linear regression again to predict the number of runs a team will score using batting statistics, and the number of runs a team will allow using fielding and pitching statistics. 

### Questions ###
1.	How many games does a team need to win in the regular season to make it to the playoffs? 
    -	Paul DePodesta reduced the regular season to a math problem. 
        -	He judged how many wins it would take to make it to the playoffs: 95. 
2.	How does a team win games? 
    -	They score more runs than their opponent
        -	But how many more? 
    -	The A’s calculated that they needed to score 135 more runs than they allowed during the regular season to expect to win 95 games 
    -	I verified this using linear regression in R

#### Notes ####
-	Dataset includes observation for every team and year pair from **1962 to 2012 for all seasons with 162 games**. 
-	**15 variables** in dataset (Run Scored (RS), Runs Allowed (RA), Wins (W) etc.)
-	We are confirming the claims made in Moneyball, we want to build models using data Paul DePodesta had in 2002. (I subsetted the data to include years before 2002)

##### Goal ##### 
Build a linear regression equation to predict wins using the **_difference between runs scored and runs allowed_**
-	Creating new dataframe with _subset function_ to the take a subset of baseball (dataframe) and only take the observations for which _Year is less than 2002._
-	Create new variable **moneyball$RD**
    - Before you build a linear regression model, you have to check: 
    - Is there a linear relationship between Run Difference and Wins? Use scatterplot
        -	X-Axis = RD, Y-Axis = Wins 
        -	Scatterplot shows a very strong linear relationship between these two variables, 
        which is a good sign for our linear regression equation
- Create linear regression model:
    -	Use _lm() function_ to predict **Wins** using independent variable RD with the dataset moneyball 
    -	Looking at _summary function_, it shows **RD independent variable is very significant with three stars**. 
        - With R-Squared of our model being 0.88, we have a strong model to **_predict wins using difference between runs scored and runs allowed._**
        - **_Can we use this strong model to confirm the claim made in Moneyball that a team needs to score at least 135 more runs than they allow, to win at least 95 games?_**
        -	Our coefficients table tell us that that our regression equation, where the coefficient of **_Wins variable = intercept term 80.8814 + coefficient for RD 0.1058_**
            -	W = 80.8814 + 0.1058 (RD)
            -	We want Wins to be greater than or equal to 95, so that A’s make it to the playoffs 
            -	Thus, we want our regression equation W >= 80.8814 + 0.1058(RD) >= 95
            -	Rearranging equation: 80.8814 + 0.1058(RD) >=95
            -	Rearranging: RD >= (95-80.8814)/0.1058 = 133.4
        -	If Run Difference >= 133.4, we predict that team will win at least 95 games; this is very close to the claim made in Moneyball that needs to score at least 135 more runs than they allow to win at least 95 games.

- Summary: By using linear regression, we were able to verify Paul DePodesta’s claim 

## Predicting Runs ## 
Previously, we used linear regression to show _if team scores at least 135 more runs than their opponent through regular season_, then we predict that team will win at least 95 games and make playoffs. 

This means, we need to know how many **_runs a team will score_**, which we will show can be predicted with _batting statistics_, and how many _runs a team will allow_, which we’ll show can be predicted using **_fielding and pitching statistics._**

Creating linear regression model to **predict runs scored**. 

A’s were interested in the question: **_How does a team score more runs?_**

They discovered two specific baseball statistics were very predictive of runs scored: 
1.	**On-base percentage (OBP)**: _This is the percentage of time a player gets on base, including walks._
2.	**Slugging percentage (SLG)**: _Measures how far a player gets around the bases on his turn and measures the power of a hitter._
-	Most baseball teams and experts have traditionally focused on batting average, which measures how often a hitter gets on base by hitting the ball. 
    - It’s similar to OBP but excludes walks. 
-	Oakland A’s claimed that **OBP** was the most _important statistic for predicting runs_; that it doesn’t matter if a player gets on base by hitting the ball or walking, just that they got on base. 
-	They claimed **slugging percentage** was important, and _batting average was overvalued as an independent variable._ 

### Goal: ###
I used linear regression in R, to verify _which baseball statistic (independent variables) are important for predicting runs scored_. 
-	Our dataset contains many variables such as RS, OBP, SLG, and BA. 
-	**_We want to see if we can use linear regression to predict runs scored, using 3 hitting statistics (OBP, SLG, and BA)_**

#### Observations: #### 
We observe all our independent variables are significant and our R-Squared is 0.93. 
- But our coefficients table, the coefficient for batting average is negative. 
    - This implies that all else being equal, a team with a lower batting average will score more runs 
  - This is counterintuitive. 
  - What’s going on? Multicollinearity. 
  - These 3 hitting statistics are highly correlated, so it’s hard to interpret the coefficients of our model. 
-	_Remove batting average variable which is the least significant, to see what happens to our model._

#### New observations ####
New linear regression model without batting average variable:
-	This model is simpler with two independent variables 
-	Has about same R-Squared
-	Overall better model 
-	Looking at our model, OBP has higher coefficient than SLG. These variables are on about the same scale, thus OBP is worth more than SLG. 

#### Summary: ####
-	Using linear regression, we verified the claims made in Moneyball: 
    - **_that batting average is overvalued, on-base percentage is the most important, and slugging percentage_**

- We can create similar model to **predict runs allowed (opponent runs).** This model uses pitching statistics: 
    -	Opponents On-Base Percentage (OOBP)
    -	Opponents Slugging Percentage (OSLG)
- These statistics are computed in the same way as OBP and SLG, but they use the actions of the opposing batters against our teams (Oakland A’s) pitchers and fielders. 
- Using our dataset in R, we can build a linear regression model to predict runs allowed, using OOBP and OSLG. 
    -	Runs Allowed = -837.38 + 2913.60(OOBP) + 1514.29(OSLG)
    -	This is a strong model with R-Squared value of 0.91 and both variables are significant. 
    -	R2 = 0.91

**_KEY MESSAGE: Simple models, using only a couple of independent variables, can be constructed to answer some of the most important questions in baseball._** 


## Using the Models to Make Predictions ##
### Learning Objective: ###
**We will apply these models to predict whether a team will make the playoffs.** 

Using our regression model, we will predict how many games the 2002 Oakland A’s will win:
1.	Firstly, we will have to **_predict how many runs the team will score AND how many runs they will allow._** 
    - When we are predicting for 2002 Oakland A’s before season has occurred, _we don’t know the team statistics_, _but we can estimate these statistics using past player performance_. 
        - **Note:** This approach assumes the past performance correlates with future performance. 
        - Thus, we can estimate the team statistics by using the 2001 player statistics. 
    -	We need to estimate the new team statistics using past player performance since, each year a baseball team is different. 
        -	This assumes past performance correlates with future performance and assumes fewer injuries
2.	Prediction for **Runs Scored:** Oakland A’s 2002 had 24 batters on roster, using 2001 regular season statistics for these players we can estimate an **_OBP of 0.339 and SLG of 0.430._** 
    - Thus, we can predict that 2002 Oakland A’s will score about 805 runs. 
    -	Similarly, prediction for Runs Allowed: 
        - Start of 2002, Oakland A’s had 17 pitchers on their roster. 
        - Using 2001 regular season statistics for these players, we estimate **_OOBP of 0.307 and OSLG of 0.373._** 
            - Our regression equation of runs allowed: 
            - **_OOBP = 0.307 and OSLG = 0.373_**
            - Ie predict 2002 Oakland A’s will allow 622 runs. 
3.	**_Run Difference = Run Scored – Run Allowed_**, we predict A’s will _win 100 games in 2002._ 
    -	Paul DePodesta took a similar approach to make predictions, and it shows our predictions closely match actual performance.
    -	For wins, we predicted they would win 100 games and Paul predicted they would win 93-97 games and they actually won 103 games.
    -	These predictions show us that by using available data and simple analytics, we can predict very close to what actually happened before the season even started. 

#### Summary ####: Billy and Paul’s job were making sure the team makes it to the playoffs, but they never won the World Series. Why not? 
-	“Over a long season the luck evens out, and the skill shines through. But in a series of 3 out of 5, or even 4 out of 5, anything can happen.”
-	The playoffs for the World Series suffer from the sample size problem. There are not enough games to make any statistical claims.
-	The number of teams in the playoffs has changed over the years. 

Is Playoff performance Predictable? 
-	Using data 1994 – 2011 (8 teams in the playoffs)
-	Correlation between winning the World Series and regular season wins is 0.03. 
-	We can compute whether the team wins the World Series – a binary variable – and the number of regular season wins, since we would expect teams with more wins to be more likely to win the World Series. However, correlation is 0.03, which is very low. So it turns out that winning regular season game gets you to the playoffs, but in the playoffs, there are two few games for luck to even out. 

