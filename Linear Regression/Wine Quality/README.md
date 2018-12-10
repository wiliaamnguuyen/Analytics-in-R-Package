# Linear Regression #

## STORY ##
Linear regression is analysing data and make predictions into unexpected context.

Bordeaux is a region in France popular for producing wine. 
-	Large differences in price and quality between years although wine is produced in a similar way. 
-	Meant to be aged, so difficult to tell if wine will be good when it is on market 
-	Expert tasters predict which ones will be good 
-	**_Can analytics be used to come up with a different system for judging wine?_**

Further information on problem:
-	Hard to determine quality of wine when it is young
-	**_Can analytics make stronger prediction?_**

Orley Ashenfelter, a Princeton economics professor claims he can predict wine without tasting the wine. 
- They are the results of a mathematical model, using a method called linear regression. 
- Method predicts an dependent variable (outcome) based on independent variables. 
- For dependent; the typical price in 1990-1991 in Bordeux wine approximating quality. 
  - Dependent variable: typical price in 1990-1991 wine auctions (approximates quality).
- For independent variables, he used:
  -	Age – older wines are more expensive 
  -	Weather 
  - Average Growing season temperature
  - Harvest rain
  - Winter rain
- 4 Independent variables altogether on the x-axis, and on y-axis you observe the logarithm of the price (the realization in an auction). 
- Ashenfelter believed that his predictions are more accurate than those of the world’s most influential wine critic. 
- In response, an influential wine expert said:
> Rather like a movie critic who never goes to see the movie but tells you how good it is based on the actors and the directors.

## One-Variable Linear Regression ##
This uses one independent variable to predict the dependent variable. 

**The goal of linear regression is to create a predictive line through the measured data.**

In general form, a one-variable linear regression model is a linear equation to predict the dependent variable *y*, using the independent variable *x*. 
- This prediction is hopefully close to the true outcome, Y; but since the coefficients have to be the same for all data points, we often make a small error. 
    - We will call this error named epsilon *‘I’.* This error term is also called often a _residual._
- Our errors will only be 0 if our points lie perfectly on the same line which rarely happens. 
    - The best model or best choice of coefficients of *Beta 0* and *Beta 1* has the smallest error terms of smallest residuals. 
- One measure of the quality (accuracy) of a regression model line is the sum of squared errors, or SSE. 
    - This is the sum of squared residuals or error terms
    -	Let n equal the number of data points that we have in our data
    - **Sum** of Squared Errors = Error (1st Data Point) squared + Error (2nd Data Point) squared + … + Error (nth Data Point) squared
      -	The smaller the sum of squared error you get, the better the fit. 
      - **_Always try to find ways to minimize the SSE to get the optimal regression model._** 
- Limitations with SSE: 
    - Hard to interpret since it depends on N. 
      - Say we built the same model with twice as much data (2N), the SSE will be twice as big. 
      - This doesn’t necessarily mean it’s a worse model (added note). 
      - It’s hard to understand the units. Some of squared errors is in squared units of the dependent variables. 
    - Due to this problem, **Root-Mean-Square Error (RMSE)** is often used as it divides sum of squared errors by N and then takes a square root. 
      - Thus, it is normalized by N and is in the same units as the dependent variables. 
    - Another _common error measure for linear regression is R squared_
      - This error measure is nice because it compares the best model to a baseline model, the model that doesn’t use any variables. 
      - The baseline model **_predicts the average value of the dependent variable regardless of the value of the independent variable._**
      - Predicts same outcome (price) regardless of independent variable (temperature). 

We can compare the sum of squared errors for the best fit line (SSE) and the sum of squared errors for the base line (SST – sum of squared errors for the base line model/total sum of squares). 
>	R Squared = 1 – SSE/SST

Note: With the baseline model, we can set coefficient for independent variable = 0; thus our linear regression model will never be worse than the baseline model as indicated below. 
>	0<= SSE <= SST
>	0 <= SST

- **R Squared is nice because it captures the value added from using a linear regression model over just predicting the average outcome for every data point.**
    - R Squared = 0 means no improvement over baseline. 
      - Meaning, worse case scenario: _SSE = SST thus R Squared = 0. _
    - R Squared = 1 means a perfect predictive model. 
      - Meaning in our best case scenario, our linear regression model makes _no errors and SSE = 0 thus _R-Squared = 1._
- **_R-Squared is nice because it’s unitless and therefore universally interpretable between problems._**

- **Summary:**
    - Good models for easy problems will have R Squared close to 1
    -	Good models for hard problems will have R Squared close to 0
    -	Baseline prediction is found by calculating the average of dependent variables (data points). 
      - Just find average value of y-values of data points. 
    -	**_Find Total Sum of Squared (SST) by calculating the dependent variable (y-data points) relative to base line prediction and thus the total sum of squared._**
      -	R-Squared = 1 – (SSE/SST)


## Multiple Linear Regression ##
There are many different variables that could be used to predict wine price such as; **Average Growing Season Temperature, Harvest Rain, Winter Rain, Age of Wine (suspected to be important) etc.**

- We can use each variable in one variable regression model: 
    -	Average growing season temperature gives the best R squared of 0.44 followed by harvest rain within R squared of 0.32. 
    -	France’s population and age gives R squared of 0.22 and 0.20 respectively. 
    -	Winter rain gives a pretty low R squared of 0.02 or just barely better than the base line. 
- Thus if we only used one variable, average growing season temperature is the best choice. 
    - HOWEVER, multiple linear regression allows you to use multiple variables at once to improve the model. 
    - MLR has coefficient for each independent variable, where we predict the dependent variable y using the independent variable variables x1, x2 … xk where k denotes the number of independent variables in our model. 
        - Noting β0 the coefficient of out constant intercept term. 
        - Multiple Linear Regression model with k varaiables 
        > Yi = β0 + β1xi1 + β2xi2 + …. + βkxik + €i
        - We use ‘I’ to denote the data for a particular data point/observation. 

- Best model coefficients selected to minimize SSE: 
    - Not all variables should be used since each new variable requires more data and causes overfitting: 
        - High R squared on data used to create model, but bad performance on unseen data. 
-	Adding of additional variables requires more data, and using more variables create a more complicated model. 
-	Overly complicated model causes overfitting; this happens when you have a higher R squared.


## Linear Regression in R ## 
- This data comes from Liquid Assets.
  - In order to look at the statistical summary of our data, use **summary function.** The summary function of our first linear regression model shows:
      - The estimate column gives us estimate of the beta values for our model.
      - The coefficient for the intercept term (beta0) is estimated to be -3.4 and coefficient for our independent variable (beta1) is estimated to be 0.635. 
      - **Adjusted R-Squared** value accounts for the number of independent variable used relative to the number of data point.
      - **Multiple R-Squared** will always _increase if you add more independent variable_ obviously, but Adjusted R-Squared will _decrease_ if you add an independent variable that **DOES NOT HELP THE MODEL.**
      - Thus determining if the an additional variable should even be included in the model. 
  - With lm() function, use this whenever you want to build a linear regression model
      - The arguments for lm() will be your dependent variable through using a tilde symbol
      - Also the argument data = wine, to tell lm() function which data to use to build model. 
-	To compute the sum of squared errors (SSE) for our model; our **_residuals or error terms are stored in the vector model1$residuals:_**
>	SSE = sum(model1$residual^2)
- Adding another variable to our regression model **(Harvest Rain)**
    - To do this, again you will need to use **lm() function**; remember to indicate the data that should be used in the lm() function argument. 
-	Observations: 
    - Coefficient for this new independent variable is negative 0.00457 upon looking at its statistical information. 
    - This variable really helped our model; our Multiple R-Squared and Adjusted R-Squared both increased significantly compared to the previous model. 
        - This indicates that this new model is probably better than previous model. 
    - Compute SSE = 2.97, which is better than sum of squared errors for model 1. 
- Build third model with the all independent variable:
    - Multiple R-Squared and Adjusted R-Squared has increased. 
    - Compute SSE, which is definitely better than before. 

## Understanding the Model ##
Understanding the model and coefficients:
-	Estimate column gives the coefficients for the intercept and for each of the independent variables in our models
- The remaining columns help **determine if a variable should be included in the model or if its coefficient is significantly different from 0.**
    - A coefficient of 0 means that the value of independent does not change our predication for the dependent variable. 
    - If coefficient is not significantly different from 0, then we should probably remove the variable from our model since it’s not helping to predict the dependent variable. 
- Further columns:
    - The standard error column gives a measure of how much the coefficient is likely to vary from the estimate value. 
    - The **t-value** is the estimate divided by the standard error (estimate/std error). 
        - _Larger the absolute value of t-value, the more likely the coefficient is to be statistically significant_
        - Thus, we want independent variable with a large absolute value in this column. 
    -	The last column gives a measure of how reasonable it is that the coefficient is actually 0, given the data we used to build the model. 
        - The less reasonable it is/smaller the probability number in this column, the less likely it is that our coefficient estimate is actually 0. 
        - This number will be large if the absolute value of the t-value is small, and it will be small if absolute value is large. 
        - We want independent variable with small values in this column (Pr(>|t|). How to remember? 
- With R, we need to determine if a variable is significant; we do this by looking at the stars at the end of each row. 
    -	3 stars (***) has the highest level of significance and corresponds to a probability value less than 0.001. 
- In our R console, we can see the summary output of the Linear Regression model we built with all independent variable: 
    - However, Age and FrancePopulation are insignificant in our model due to summary information. 
        - Thus we need to remove these variables from our model, which we intuitively don’t expect to be predictive of wine price. 
    - Once we remove FrancePopulation, we see that we our new model4 is a stronger model due to its Adjusted R-Squared increasing by removing this variable. 
        - Observe that after removing FrancePopulation; variable Age has become more significant in this new model. 
        - Why? This is due to **multicollinearity** where Age and France Population are highly correlated. 

## Correlation and Multicollinearity ##
- **Correlation is a measure of the linear relationship between variables and is a number between -1 and +1.**
    -	+1 = perfect positive linear relationship 
    -	0 = no linear relationship 
    -	-1 = perfect negative linear relationship
- Correlation:
    -	When we say that two variables are highly correlated, we mean that absolute value of the correlation is close to 1. 
- Computing correlation between a pair of variables in R: 
  -	Use **cor() function**
  -	Arguments for cor() function is the names of the two variables WinterRain and Price
  - We can also compute the correlation between all pairs of variables in our data: 
    -	Cor(data_frame)
    -	Outputs variables in our data sets
    -	This way, you can see if a specific variable is highly correlated with any other variables in dataset
    - How does this help information help with understanding linear regression model? 
    - **Since we know Age and France Population are definitely highly correlated; we have multicollinearity problems in our model.**
    - **_Multicollinearity refers to the situation when two independent variables are highly correlated_**
-	A high correlation between an independent variable and the dependent variable is a great thing since we’re trying to predict the dependent variable using independent variables. 

How to solve multicollinearity problem: 
-	Always remove insignificant variables one at a time 
-	Had you had removed both Age and France Population at the same time (since they were insignificant); the results would be wrong. Why?
    - Create a model where you had taken our both insignificant variables at the same time. 
    - The coefficients table shows significance for all significant variables BUT, our Multiple R-Squared has dropped to 0.75.
    - Thus, had we removed Age and France Population at the same time, we would have missed a significant variable. 
    - Thus, R-Squared in our final model would have been lower 
-	Why didn't we keep FrancePopulation instead of Age? We intuitively expect older wine to be more expensive. Age makes more intuitive sense in our model. 
used. 
- **Note:** Typically, a correlation greater than 0.7 and less than 0.7 is cause for concern of multicollinearity problem. 

## Making Predictions ##
### Predictive Ability ###
-	Our wine model had a value of R2 = 0.83
    - This tells our accuracy on the data that we used to build the model 
    - However, does this model perform well on new data it’s never seen before so we can use the model to make predictions for later years. 
-	Bordeaux wine buyers profit from being able to predict the quality of wine years before it matures. 

**Problem:**
-	They know values of independent variables (age and weather), but do not know the price of wine will eventually sell for. 
-	It’s important to build a model that predicts data well it’s never seen before. 

Notes:
-	The data that we use to build a model is often called the training data, and the new data is called test data

Model performance on test data:
-	We will use the predict function for these two observation points (test points)
    -	Predict function takes two arguments: first argument is our linear regression model of which the predict function will use to make predictions; second argument, you need to indicate the new data that you want to make predictions FOR is in winetest.csv file
-	Please note that the two observations of Price is originally 6.95 and 6.5; our linear regression model used to predict on two test points had given 6.76 and 6.84 respectively (very close). 
- To quantify how accurate this above model is, we will use R2 = 1 – (SSE/SST)
    -	SSE = sum ((wineTest$Price – predictTest)^2)
    -	SST = sum((wineTest$Price – mean(wine$Price))^2)
    -	R2 is pretty good, but keep in mind our test set is really small (only two test points). We should increase the size of our test set to be more confident about out-of-sample accuracy of our model

Conclusion:
-	When selecting a model, we want one with a good model R-Squared but also with a good test set R-Squared
-	We need more data in our test set, it isn’t enough to reach a conclusion
-	SST is calculated using the mean value of the dependent variable on the training set. 
-	SSE and SST are the sums of squared terms, which are positive; thus (SSE/SST) >=0

## Comparing the Model to the Experts ##
Robert Parker predicted that 1986 Bordeaux wine is “very good to sometimes exceptional”.
However, Ashenfelter said 1986 Bordeaux wine:
-	Mediocre 
-	1989 will be “the wine of the century” and 1990 will be even better!

Results, the wine auction shows:
-	1989 sold for more than twice the price of 1986
-	1990 sold for even higher prices

Later, Ashenfelter predicted 2000 and 2003 would be great. Later, Park has stated that “2000 is the greatest vintage Bordeaux has ever produced”. 
Notes:
-	We have developed a linear regression model, a simple powerful model for predicting the quality of wines. 
-	It only used a few variables and we have seen that it predicted wine prices quite well 
-	In many cases, it outperformed wine expert’s opinion
-	It is a quantitative approach to a traditionally qualitative problem 


 



