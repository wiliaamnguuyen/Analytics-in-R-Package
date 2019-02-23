# State Data 
This dataset has, for each of the fifty U.S. states, the population, per capita income, illiteracy rate, murder rate, high school graduation rate, average number of frost days, area, latitude and longitude, division the state belongs to, region the state belongs to, and two-letter abbreviation. This dataset comes from the U.S. Department of Commerce, Bureau of the Census.
This dataset has 50 observations (one for each US state) and the following 8 variables:
-	Population - the population estimate of the state in 1975
-	Income - per capita income in 1974
-	Illiteracy - illiteracy rates in 1970, as a percent of the population
-	Life.Exp - the life expectancy in years of residents of the state in 1970
-	Murder - the murder and non-negligent manslaughter rate per 100,000 population in 1976 
-	HS.Grad - percent of high-school graduates in 1970
-	Frost - the mean number of days with minimum temperature below freezing from 1931–1960 in the capital or a large city of the state
-	Area - the land area (in square miles) of the state
**_I am building a model for life expectancy using regression tree, and employ cross-validation to improve my tree’s performance._**
## Linear Regression Model 
**Adjusted R-Squared** = 0.6922
I would further go deeper to analyse how well my predicted life expectancies using linear regression model compares to actual life expectancies using **Sum of Squared Errors (SSE)**.
**SSE** = 23.3
Rebuilding my linear regression model using the most significant variables: 
-	**Adjusted R-Squared** = 0.7126
-	**SSE of Reduced Model** = 23.3
Trying different combinations of variables in linear regression is like trying different umber of spits in a tree – this controls the complexity of the model. 
## CART Models 
Building a CART model to predict _Life.Exp_ using all of the other variables as independent variables. I will use the default minbucket parameter; **_I’m not interested in predicting life expectancies for new observations as I am understanding how they relate to the other variables I have, so I will use all of the data in my model._**
**Note**: I didn’t use _method=’class’_ since this is a regression tree. 
Regression tree observations:
-	**SSE** = 28.9
-	The error is higher than linear regression models. 
-	One reason is that I haven’t made the tree big enough; thus _I set the minbucket parameter to 4, and recreate the tree_. 
-	**NEW SSE** = 23.64
-	This new tree has more splits; it must be true that the default minbucket parameter was limiting the tree before being a larger value. By changing the parameters, I have improved the fit of my model. 
I want to do even better, because I feel this model still isn’t good enough. Based on previous tree, I built a new tree to predict _Life.Exp_ using only **Area** variable, with minbucket parameter set to 1:
-	**SSE** = 9.2 
-	This model still makes mistakes because there are some other parameters in rpart that are also trying to prevent the tree from overfitting by setting default values. 
-	Thus, the tree doesn’t necessarily have one observation in each bucket – by setting minbucket =1, I am allowing the tree to have one observation in each bucket. 
-	This is the lowest error I have seen so far; why? 
-	**_By making the minbucket parameter very small, I could build an almost perfect model using just one variable (not even my most significant variable). However, upon plotting the tree; there is 22 splits. This is not a interpretable model, and thus, will not generalize very well._**

## Cross Validation 
Adjusting the variables included in a lienar regression model is a form of _model tuning_. 
**Note:** Simpler models are more interpretable and generalizable. 
I can tune my regression tree to see if I can improve the fit of my tree while keeping it as simple as possible. 
Using k-fold cross validation:
1.	Loading _caret_ library. 
2.	Setting up the cross validation controls to tell my model I am using cross validation and 10 k-fold. 
3.	Using cp-values varying over the range (for example, 0.01 to 0.5 in increments of 0.01). 
4.	Using the _train_ function to determine the best cp value for CART model. 
5.	The purpose of cross-validation is to pick the tree that will perform the best on a test-set; so I expect the model I made with the best ‘cp’ value to perform best on a test set. 




