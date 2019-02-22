# Boston Housing Data
## Regression Trees for Housing Data
This data comes from a paper, **”Hedonic Housing Prices and the Demand for Clean Air”** which has been cited more than a 1000 times.
-	It talks about the relationship between **house prices** and **clean air**.
-	Data set widely used to evaluate algorithms; for this dataset, **_I will be mostly discussing classification trees with the output as a factor or category_**.
## The R in CART
-	Trees can also be used for **regression** - the output at each leaf of the tree is no longer a category, but a number. 
-	Just like classification trees, **regression trees** can capture **nonlinearities** that linear regression can’t. 
o	For example, with classification Trees, I can report the average outcome at each leaf of the tree, e.g. if the outcome is “true” 15 times, and “false” 5 times, the value at that leaf is: 15/(15+5)=0.75.
o	If I used a default threshold of 0.5, this leaf would be true. 
o	With **Regression Trees**, I have continuous variables so I simply report the average of the values at that leaf. 
## Objectives
-	I will be comparing linear regression with regression trees to see the effectiveness of regression trees at fitting some data that linear models just can’t. 
-	Discussing what the “cp” parameter means.
-	Applying cross-validation to regression trees. 

## The Data
I will be using the dataset boston.csv to predict housing prices in Boston. Please download this dataset to follow along in this recitation. This data comes from the UCI Machine Learning Repository.
## Understanding Data
Each entry corresponds to a **census tract**, a statistical division of the area that is used by researchers to break down towns and cities. 
There will usually be multiple census tracts per **town**. 
-	**LON** and **LAT** are the longitude and latitude of the centre of the census tract. 
-	**MEDV** is the median value of owner-occupied homes, in thousands of dollars. 
-	**CRIM** is the per capita crime rate. 
-	**ZN** is related to how much of the land is zoned for large residential properties. 
-	**INDUS** is proportion of area used for industry. 
-	**CHAS** is 1 if the census tract is next to the Charles River. 
-	**NOX** is the concentration of nitrous oxides in the air. 
-	**RM** is the average number of rooms per dwelling. 
-	**AGE** is the proportion of owner-occupied units built before 1940. 
-	**DIS** is a measure of how far the tract is from centres of employment in Boston. 
-	**RAD** is a measure of closeness to important highways. 
-	**TAX** is the property tax rate per $10,000 of value. 
-	**PTRATIO** is the pupil-teacher ratio by town. 

## Geographical Locations
```r
points(boston$LON[boston$MEDV>=21.2],boston$LAT[boston$MEDV>=21.2],col='red',pch=19)
```

From this plot, I can see housing prices are not distributed in a linear way over the area; thus linear regression won’t do well at predicting house price. 

## Regression Trees
It is very important to note that I can plot a CART tree with different ways – by using the plot and text function instead of the prp function. This is just another way to visualize the CART tree and shows the tree in a slightly different way. Both are valid options for plotting your CART trees. 
It is difficult to compare out of sample accuracy for regression: 
-	With classification, I could easily say this method got X% correct and this method got Y% correct. 
-	Since, we’re doing continuous variables (linear regression), I calculated the sum of squared errors (SSE). 
-	Once computing the accuracy for the linear regression model, I demonstrated that I could beat this accuracy with a regression tree model. 

## CP Parameter
I will be applying cross validation to my tree to hopefully improve the results regarding my regression tree model. 
-	“cp” stands for **”complexity parameter”**
-	Recall the first tree I made using LAT/LON had many splits, but I were able to trim it without losing much accuracy. 
-	Intuition: having too many splits is bad for generalization i.e. _performance on the test set_; so I should penalize the **complexity**. 

Defining **RSS**, the **residual sum of squares**, the sum of the square differences. 
-	My goal when building the tree is to minimize the RSS by making splits, but I want to penalize too many splits. 
-	Define **S** to be the number of splits, and lambda to be the penalty. 
-	My goal is to find the tree that minimizes the sum of the RSS at each leaf + lambda*S (number of splits). 
-	**Note**: Picking a large value of lambda (penalty), there won’t be much splits because my model pays a big penalty price for every additional split that will outweigh the decrease in error. 
### Definition
-	The definition of “cp” is closely related to _lambda_. 
-	Consider a tree with no splits – I simply take the average of the data. Calculate RSS for that tree; calling **RSS (no splits)**. 
-	Cp = lambda/(RSS(nosplits))

**Intuition:** Small cp number encourages large trees. 
## Applying Cross-Validation to Training Data
Building my final tree using cross validation:
-	The tuning grid was fed a sequence/grid of cp values for my model to test. 
-	It tests all the different values of cp that I asked it to do and thus selects a optimal cp value that produces the best model with the best RMSE (Root Means Squared Error). 
-	The best cp values are **the numbers very close to 0**. 


