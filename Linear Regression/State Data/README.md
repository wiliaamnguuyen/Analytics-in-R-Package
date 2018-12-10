# State Data #
## INTRODUCTION ##
We often take data for granted. 

However, one of the hardest parts about analyzing a problem you're interested in, can be to find good data to answer the questions you want to ask. 

In this problem, I examined the "state" dataset, which has data from the 1970s on all fifty US states. 

For each state, the dataset includes the population, per capita income, illiteracy rate, murder rate, high school graduation rate, average number of frost days, area, latitude and longitude, division the state belongs to, region the state belongs to, and two-letter abbreviation.

This dataset has 50 observations (one for each US state) and the following 15 variables:
-	**Population** - the population estimate of the state in 1975
-	**Income** - per capita income in 1974
-	**Illiteracy** - illiteracy rates in 1970, as a percent of the population
-	**Life.Exp** - the life expectancy in years of residents of the state in 1970
-	**Murder** - the murder and non-negligent manslaughter rate per 100,000 population in 1976 
-	**HS.Grad** - percent of high-school graduates in 1970
-	**Frost** - the mean number of days with minimum temperature below freezing from 1931–1960 in the capital or a large city of the state
-	**Area** - the land area (in square miles) of the state
-	**state.abb** - a 2-letter abreviation for each state
-	**state.area** - the area of each state, in square miles
-	**x** - the longitude of the center of the state
-	**y** - the latitude of the center of the state


## LINEAR REGRESSION MODELS ##
I built a model to predict life expectancy by state using the state statistics we have in our dataset. 

Our independent variable (income) used in our linear regression model to predict life expectancy is negative:
-	When we have negative coefficients in our model; it means when this independent variable increase, what we are predicting will instead decrease. 
-	Upon plotting the relationship between income and life expectancy, we see a somewhat positive correlation with income. 
-	Why doesn’t the model we built does not display this relationship from the plot I built (Life Expectancy vs. Income plot)? 
    - It is due to multi-collinearity. 
    - Income is an insignificant variable in this model, this doesn’t mean there is no association between income and life expectancy. 
-	However, in the presence of all the other variables, income doesn’t add statistically significant explanatory power to the model. 
    - This means that multicollinearity is probably the issue. 

## PREDICTING LIFE EXPECTANCY (REFINING MODEL AND ANALYSING PREDICTIONS) ##
It is important to note the strong principle of simplicity: that is, a model with fewer variables is preferable to a model with many unnecessary variables:
-	I experimented by removing independent variables from the original model 
-	I used the significant of the coefficients to decide which variables to remove (remove the one with the largest p-value first, or t-value closest to 0)
-	I removed each variable one at a time (backwards propagation selection)
-	It was important I removed each variable one at a time due to the multicollinearity issue – removing one insignificant variable may make another previously insignificant variable become significant. 
Removing insignificant variables changes the Multiple R-Squared value of the mode. 
-	When we remove insignificant variables, the “Multiple R-Squared” will always be worse but only slightly worse

I also observed how my predictions compare to the actual values:
-	I sorted my predictions by using the command “sort(predict(linReg))” to find out which state has the lowest life expectancy 
-	The index that answers this is [1]
-	Thus, to find which state, the command “statedata$state.name[1]” would spit out Alabama as the state that has the lowest life expectancy. 
-	To find the actual values: I used the which.min() function to find the row number of the state that has the lowest life expectancy. From there, I found the state name in the vector “statedata$state.name[x]” to find South Carolina to be the actual state to have the lowest life expectancy compared to Alabama. 

**Note:**
-	Vector residual is the difference between the predicted and actual values 
