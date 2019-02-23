# Predicting Earnings from Census Data
## Context
The United States government periodically collects demographic information by conducting a census.

I am using census information about an individual to predict how much a person earns -- in particular, whether the person earns more than $50,000 per year. 

This data comes from the [UCI Machine Learning Repository]( http://archive.ics.uci.edu/ml/datasets/Adult).

The file census.csv contains 1994 census data for 31,978 individuals in the United States.

The dataset includes the following 13 variables:
-	age = the age of the individual in years
-	workclass = the classification of the individual's working status (does the person work for the federal government, work for the local government, work without pay, and so on)
-	education = the level of education of the individual (e.g., 5th-6th grade, high school graduate, PhD, so on)
-	maritalstatus = the marital status of the individual
-	occupation = the type of work the individual does (e.g., administrative/clerical work, farming/fishing, sales and so on)
-	relationship = relationship of individual to his/her household
-	race = the individual's race
-	sex = the individual's sex
-	capitalgain = the capital gains of the individual in 1994 (from selling an asset such as a stock or bond for more than the original purchase price)
-	capitalloss = the capital losses of the individual in 1994 (from selling an asset such as a stock or bond for less than the original purchase price)
-	hoursperweek = the number of hours the individual works per week
-	nativecountry = the native country of the individual
-	over50k = whether or not the individual earned more than $50,000 in 1994

## A Logistic Regression Model 
To predict whether an individual earnings are above 50,000 dollars using all of the available independent variables. 
To measure the accuracy of the model on the testing; I set a threshold of 0.5 whilst making predictions on the test set using this model. 
-	After calculating the accuracy of this logistic regression model; I compared it to the baseline accuracy for the testing set (determining most frequent outcome). 
-	I understand, my model did well compared to my baseline model. What’s the AUC for this model on the testing set? 
-	I installed “ROCR” package to do this and used both the _prediction_ and _performance_ functions to calculate AUC. 
-	Logistic regression model for this data achieves a high accuracy. Moreover, this model is good since it gives me an idea which variables are significant for this prediction task. 
-	**_However, it is not immediately clear which variables are more important than others, especially due to the large number of factor variables in this problem. Hence, for better interpretability; I built a classification tree to predict “over50K._**

## A CART Model
I am interested in finding out the accuracy of this CART model performing on the test set with a threshold of 0.5. My observations:
-	Accuracy of Logistic Regression model is 85%
-	Accuracy of CART model is 84%
-	**_This highlights a very regular phenomenon when comparing CART and logistic regression. CART often performs a little worse than logistic regression in out-of-sample accuracy. However, CART model is often much simpler to describe and understand._**
Considering the ROC curve and AUC for the CART model on the test set:
-	I need to get the predicted probabilities for the observations in the test set to build the ROC curve and compute the AUC just like in logistic regression. 
-	I did this by removing the _type=’class’_ argument when making predictions, and taking the second column of the resulting object. 
-	Then, plotting the ROC curve I have estimated and comparing it to the logistic regression ROC curve; **_the CART ROC curve is less smooth than logistic regression ROC curve_**. Why? 
-	**The probabilities from the CART model take only a handful of values (five, one for each end bucket/leaf of the tree); the changes in the ROC curve correspond to the setting the threshold to one of those values.**
-	**The breakpoints of the curve correspond to the false and true positive rates when the threshold is set to the 5 possible probability values.**
Calculation of AUC of CART model:
-	Generating the predictions for the tree by leaving out the argument _type=’class’_ from the function call. 
-	Without this extra part, I will get the raw probabilities of the dependent variable values for each observation which I need to generate the AUC. 
-	Take 2nd column of the output. 

## A Random Forest Model 
Before building my random forest model, I down-sampled my training set. My research shows that while some modern personal computers can build a random forest model on the entire training set, others might run out of memory when trying to train the model since **_random forests is much more computationally intensive than CART or Logistic Regression_**. Thus, before continuing I will define a new training set to be used when building my random forest model containing 2000 randomly selected observations from the original training set. 

```r
set.seed(1)
trainSmall = train[sample(nrow(train),2000),]
```


Random forest models work by building a large collection of trees; as a result, I lose some of the interpretability that comes with CART in terms of seeing how predictions are made and which variables are important. **However, I can still compute metrics that give me insight which variables are important.**
One metric that I can look at is the number of times, aggregated over all the random forest model, that a certain variable is selected for a split. To view this metric, run the following lines of R. 

```r
vu = varUsed(model,count=True)
vusorted = sort(vu,decreasing=FALSE,index.return=TRUE)
dotchart(vusorted$x,names(MODEL$forest$xlevels[vusorted$ix]))
```

This produces a chart for each variable and measures the number of times that variable was selected for splitting (value on the x-axis). 


## Selecting cp by Cross-Validation
This is my favourite part. Let’s get into it. 
I want to study how CART behaves with different choices of its complexity parameters. 
-	Selecting the cp parameter for my CART model using **_k-fold cross validation_**, with k=10 folds. 
-	I did this using the train() function. 
-	Testing cp values from 0.002 to 0.1 in 0.002 increments

```r
cartGrid = expand.grid(.cp=seq(0.002,0.1,0.002))
```


Compared to the original accuracy using the default value of cp, this new CART model using the optimal cp value (0.002) is an improvement. However, do I favour this new model over the old just because it has a higher accuracy? 
-	Upon plotting the tree, it has 18 splits. 
-	This highlights one important trade-off in building predictive models. 
-	By tuning cp, I improved my accuracy by over 1%, but my tree became significantly more complicated. 
-	In some applications, such an improvement would be worth the loss in interpretability. In other, I may prefer a less accurate model that is simpler to understand and describe over a more accurate – but more complicated model. 

