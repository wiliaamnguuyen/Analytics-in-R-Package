# Forecasting Elantra Sales #

## INTRODUCTION ##
An important application of linear regression is understanding sales. 

Consider a company that produces and sells a product. 
- In each period, if the company produces more units than how many consumers will buy, the company will not earn money on the unsold units 
and will incur additional costs due to having to store those units in inventory before they can be sold. 
- If it produces fewer units than how many consumers will buy, the company will earn less than it potentially could have earned. 
- Being able to predict consumer sales, therefore, is of first order importance to the company.

In this problem, I predicted the monthly sales of the Hyundai Elantra in the United States. 
- The Hyundai Motor Company is a major automobile manufacturer based in South Korea. 
    - The Elantra is a car model that has been produced by Hyundai since 1990 and is sold all over the world, including the United States. 
- The linear regression model I built, predicts monthly sales using economic indicators of the United States as well as Google search queries.

The file elantra.csv contains data for the problem. 
Each observation is a month, from January 2010 to February 2014. For each month, the following variables are:
-	**Month** = the month of the year for the observation (1 = January, 2 = February, 3 = March, ...).
-	**Year** = the year of the observation.
-	**ElantraSales** = the number of units of the Hyundai Elantra sold in the United States in the given month.
-	**Unemployment** = the estimated unemployment percentage in the United States in the given month.
-	**Queries** = a (normalized) approximation of the number of Google searches for "hyundai elantra" in the given month.
-	**CPI_energy** = the monthly consumer price index (CPI) for energy for the given month.
-	**CPI_all** = the consumer price index (CPI) for all products for the given month; this is a measure of the magnitude of the prices paid by consumer households for goods and services (e.g., food, clothing, electricity, etc.).

## LINEAR REGRESSION MODEL ##
In modelling demand and sales, it is often useful to model seasonality: 
-	Seasonality refers to the fact that demand is often cyclical/periodical in time. 
-	E.g. In countries with different seasons, demand for warm clothing (jackets and coats) is higher in autumn and winter (due to colder weather) than in spring and summer. 
-	Further example to illustrate this point is the “back to school” period in North America: demand for stationary in late July and all of August is higher than the rest of the year due to the start of the school year in September. 

In our problem, since our data includes the month of the year in which the units were sold, I thought it was feasible to incorporate monthly seasonality. 

**Key Point**: 
- From a modelling point of view, it may be reasonable that the month plays an effect in how many Elantra units are sold. 
- I incorporated the seasonal effect due to the month by building a linear regression model that predicts Elantra sales using Month as well as Unemployment, CPI_all, CPI_energy and Queries. 

## NUMERIC VS FACTORS	##
- When modelling of the effect of the calendar month on the monthly sales of Elantra; I added Month as a variable, but it is an ordinary numeric variable. 
    - Thus, I converted variable Month to a factor variable before adding it to the model. The reason I did this is because:
      - By modelling Month as a factor variable, the effect of each calendar month is not restricted to be linear in the numeric coding of the month. 
-	This problem shows that for every month we move into the future (e.g. Jan to Feb, Feb to Mar), our predicted sales go up by 110.69m which doesn’t sound right since the effect of the month should be affected by the numeric coding. 
    - By modelling Month as a numeric variable, we cannot capture more complex effects. 
    For e.g., suppose that when other variables are fixed, an additional 500 units are sold from June to December, relative to other months. 
    - This type of relationship between the boost of sales and the Month variable would look like a step function at Month = 6, which cannot be modelled as a linear function. 
- Note: 
    - Before building any models, make sure any numeric variables are factor variables if need be. 
    - Use the **as.factor() function** to convert variables into factors. 
    - Observations with new model with Month as a factor variable shows R-Squared has increased. 

## FURTHER OBSERVATIONS ##
Notice with new regression model built with Month variable as a factor:
-	Queries variable sign has changed to negative sign 
-	CPI_energy has a positive coefficient – as the overall price of energy increases, we expect Elantra sales to increase, which seems counter-intuitive (if price of energy increases, we’d expect consumers to have less funds to purchase automobiles, leading to lower Elantra sales). 
As I understand, any changes in coefficient signs and observations that are counter-intuitive may be due to a collinearity problem. To check, it’s always best to compute the correlations of the variables in the training set. 
-	If variables with absolute value of correlation exceeds 0.6, it shows variables are highly correlated. 

## TEST SET PREDICTIONS ##
- When calculating the Sum of Squared Errors of the model on the test set, you firstly need to make predictions on the test set. 
- The baseline method is used in R-Squared calculation to compute SST to predict the mean of ElantraSales in the training set for every observation without any regard for any of the independent variable. 

