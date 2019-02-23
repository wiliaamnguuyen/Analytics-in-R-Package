# The Supreme Court
## Motivation/Context

I will be using the CART method and a related method called random forests to see whether these methods outperform experts in predicting the outcome of Supreme Court cases. 
-	In 2002, a group of political science and law academics decided to test if a model can do better than a group of experts at predicting the decisions of the Supreme Court. 
-	In this instance, a very interpretable analytics method was used; **_classification and regression trees_**

### The American Legal System
-	The legal system of the United States operates at the state level and at the federal level. 
-	Federal courts hear cases beyond the scopes of the state law. 
-	Federal courts are divided into: 
    -	**District Courts**
        -	Cases starts at district courts where an initial decision 
    -	**Circuit Courts**
        -	Hears appeals from the district courts and can change the decision that was made. 
    -	**Supreme Courts**
        -	Highest Level – makes final decision. 
        
### The Supreme Court of the United States 
-	Consists of nine judges (“justices”), appointed by the President 
    -	Justices are distinguished judges, professors of law, state and federal attorneys. 
-	The Supreme Court of the United States (SCOTUS) decides on most difficult and controversial cases
    -	Often involve interpretation of Constitution 
    -	Significant social, political and economic consequences
    
    
### Predicting Supreme Court Cases
-	Legal academics and political scientists regularly make predictions of SCOTUS decisions from detailed studies of cases and individual justices
-	In 2002, Andrew Martin, a professor of political science at Washington University in St. Louis, decided to predict decisions using a statistical model built from data. 
-	Together with his colleagues, he decided to test the model against a panel of experts. 
    -	They wanted to see if an analytical model could outperform the expertise and intuition of a large group of experts. 
-	Martin used a method called **Classification and Regression Trees (CART)**
-	Will the Supreme Court affirm the case or reject the case? The outcome is _binary_. Why didn’t Martin just logistic regression? 
    -	Logistic regression models are generally not ¬_interpretable_. 
    -	Model coefficients in logistic regression, indicate importance and relative effect of variables, but don’t give a simple explanation of how decision is made. 

## CART
-	To predict the outcomes of the Supreme Court, Martin used cases from 1994 through 2001. 
-	He chose this period because the Supreme court was composed of the same nine justices when he made his predictions in 2002. 
    -	This is a rare dataset – this was the longest period with the same set of justices in over 180 years. 
    -	This allowed Martin to use a larger data set then might have been available if he was doing this experiment at a different time. 
-	I will be focusing on predicting Justice Steven’s decisions
    -	He started out moderate, but became more liberal during his time on the Supreme Court 
    -	Although, he is a self-proclaimed conservative. 
    
### Variables 
-	**Dependent Variable:** Did Justice Stevens vote to reverse the lower court’s decision or overturn the lower courts decision? 1 = reverse, 0 = affirm. 
-	**Independent Variables:** Properties of the case such as: 
    -	Circuit court of origin is the circuit(1st – 11th, DC, FED)
    -	Issue area of case (e.g., civil rights, federal taxation)
    -	Type of petitioner, type of respondent (e.g., US, an employer)
    -	Ideological direction of lower court decision (conservative or liberal)
    -	Whether petitioner argued that a law/practice was unconstitutional 
    
### Using Logistic Regression 
-	There are some significant variables and their coefficients:
    -	Whether or not the case is from the 2nd circuit court: _+1.66_
    -	Whether or not the case is from the 4th circuit court: _+2.82_
    -	Whether or not the lower court decision was liberal: _-1.22_
-	While this tells me that the case being from the 2nd or 4th circuit courts is predictive of Justice Stevens reversing the case, and the lower court decision being liberal is predictive of Justice Stevens affirming the case. 
-	This is complicated to understand…
    -	Difficult to understand which factors are more important due to **scales of the variables, and the possibility of multicollinearity.**
    -	Difficult to understand to quickly evaluate what the prediction is for a new case. 

### Classification and Regression Trees
-	**_Instead of logistic regression, using a method called CART._**
    -	This method builds a **_tree_** by splitting on the values of the independent variables. 
    -	To predict the outcome for a new observation or case, I follow the splits in the tree and at the end, I will predict the most frequent outcome in the training set that followed the same path. 
-	Advantages of CART:
    -	Does not assume a linear model, like logistic regression or linear regression. 
    - Very interpretable model. 
-	CART tries to split this data into subsets so that each subset is as pure/homogenous as possible. 
    -	The standard prediction made by a CART model split is just the majority in each subset. 
    -	If a new observation fell into one of these two subsets, then predict the majority of the observations in those subsets. 
-	A CART model is **represented by what I call a tree.** I always keep this in mind when reading trees:
    -	For trees generated in R, a _”yes”_ response is always to the left and a no response
    -	Starting at the top of the tree from reading 
    
### Splitting and Predictions
**_How does CART decides how many splits to generate? How are the final predictions are made?_**
-	There are different ways to control how many splits are generated. 
    -	One way is by setting a lower bound for the number of data points in each subset. 
-	In R, a parameter that controls this is **_minbucket_**
    -	The smaller minbucket is, the more splits will be generated. 
    -	If too small, overfitting will occur. Meaning, CART will fit the training set almost perfectly but this is bad, because model will probably not perform well on test set data/new data. 
    -	If minbucket parameter is too large, the model will be too simple and the accuracy will be poor. 
Predictions from CART:
-	In each subset of a CART tree, I have a bucket of observations which may contain both outcomes (i.e. affirm and reverse). 
    -	You can classify each subset by the majority of the one outcome in that subset.
-	Instead of taking the majority outcome to be the prediction … I computed the percentage of data in a subset of each type of outcome. 
-	Just like in logistic regression, I can use a threshold value to obtain a prediction. 
    -	For example, I can predict a scenario with a threshold of 0.5 since this threshold corresponds to picking most frequent outcome. 
    -	**_By varying the threshold value, I can compute a ROC curve and compute an AUC value to evaluate my model._**

## CART in R
This data comes from the Supreme Court Forecasting Project website.
Using the _”prp() function”_ visualize my tree:
-	The first split of the tree is whether the lower court decision is liberal. 
    -	If it is liberal, then I move to the left of the tree. 
-	Then, I check the respondent to see if it is a criminal defendant, injured person, politician, state, or the United States. 
    -	I predict 0, or affirm. 
    -	I observe that the prp() function abbreviates the values of the independent variables. If I’m not sure what the abbreviations are, I can create a table of the variable to see all of the possible values. 
-	If the petitioner is a city, employee, employer, government official, or politician then I predict 0, or affirm. 
-	If not, then I check the circuit of origin is the 10th, 1st, 3rd, 4th, DC, or Federal Court then I predict 0. 
    -	Otherwise, I will predict 1, or **_reverse_**

Comparing this to a logistic regression model, I can see that it’s very interpretable. A CART tree is a series of decision rules which can easily be explained. 
I want to see how well the CART model does at making predictions for the test set:
-	I want to make predictions using the model I just made on the test set. 
-	The last argument is _type=’class’_; need to give this argument for making predictions for CART model if you want the majority class predictions. 
    -	This is like using a threshold of 0.5
Computing accuracy of the model by building a confusion matrix:
-	Using the _table() function_; giving the first true outcome and then the second argument will be your predictions
-	Accuracy is 0.659 with my CART model; and the baseline model that always predicts **_Reverse_** (most common outcome) has an accuracy of 0.547. 
-	CART model significantly beats the baseline. 
-	To further evaluate my model, I generated an ROC curve for my CART model using the ROCR package. 
    -	For each observation in the test set, it gives two numbers which can be though of as a probability of outcome 0 and the probability of outcome 1. 

## Random Forests
There is a method like CART called Random Forests:
-	Designed to improve prediction accuracy of CART
-	Works by building many CART trees
    -	Unfortunately, this makes the model less interpretable than CART
    -	Often, I need to decide if I value the interpretability or the increase in accuracy more. 
-	To make a prediction for a new observation, each tree “forest votes” on the outcome, and I pick the outcome that receives the majority of the votes. 

### Building Many Trees
Random forests build many CART trees:
-	By having random forest trees that only allows each tree to split on a random subset of the available independent variables
-	Each tree is built from a _”bagged”/”bootstrapped”_ sample of the data. Meaning data used as the training data for each tree is selected randomly with replacement. 
    -	Select observations randomly with replacement
    -	Example – original data: 1 2 3 4 5 
    -	With this example, I will pick 5 data points randomly sampled with replacement – new data: 2, 4, 5, 2 and 1  1st tree
    -	*__Each time I pick one of the five data points regardless of whether it’s been selected already. These would be the five data points to use when constructing the first CART tree._**
    -	New “data”: 3 5 1 5 2  2nd tree; using this data when building the second CART tree. 
-	Repeating this process for each additional tree I want to create

### Random Forests Parameters
-	**Since each tree sees a different set of variables and a different set of data, I get a forest of many different trees.** Just like CART, random forests has some parameter values that need to be selected. 
-	What needs to be selected is **_minimum number of observations in a subset or the minbucket parameter from CART_**
    -	Creating random forests in R, this is controlled by the _nodesize parameter_.
    -	Smaller value of _nodesize_, which leads to bigger trees, may take longer in R
-	Random forests is much more computationally intensive than CART, the second parameter is the **number of trees to build, which is called _ntree_ in R**. 
    -	In R, this is the _ntree_ parameter 
    -	This should not be set too small, because bagging procedure may miss observations
    -	Shouldn’t be too small, but the larger it is the longer it will take; more trees take longer to build. 

### Predicting Steven’s Decisions using Random Forest Model 
I used the argument _nodesize_ also known as minbucket for CART, to feed my **_randomForest_** function. 
-	I further need to set up the parameter _ntree_. This is the number of trees to build and I will build 200 trees here. 
-	The _randomforest_ function does not have a method argument; so when I do a classification problem I will need to make sure the outcome is a factor. 
-	Thus, I will need to convert the variable _Reverse_ to a factor variable in both my training and test set before creating this model. 


### Computing Predictions with Test Set
I always note when I want to compute the accuracy by first looking at the _confusion matrix_:
-	Using the **_table()_** function, the arguments I feed this function is the true outcome and then my predictions. 
-	Observations show accuracy of Random Forest model improved on accuracy a little bit over CART. 

## Optimal Trees 
### Random Forests/Boosting vs CART
The CART model shows variable by variable why the predictions are made. 
-	More interpretable model, _white box_, transparent, in that they **_provide insights in understanding the logic for decision making._**
In contrast, the random forest model, belonging to a class of _black box models_, also makes predictions, but the inner workings of how input translates into predictions are overly complex/unclear. 
-	Predictions are averaged across hundreds of models, making interpreting the meaning of variables and the models difficult. 
-	In practice, **_black box models often achieve higher accuracy_** as I have displayed with the Supreme Court example.
-	However, this comes at a cost of the low interpretability. 


**Optimal classification trees**:
-	This solution achieves both interpretability and performance. 
-	CART only learns the splits one step at a time in a greedy fashion, often resulting overall tree could be far from optimal. 
    -	CART’s greedy training means splits are only locally-optimal.
-	Instead, the MIT researchers use modern optimization technique **_to train the entire tree in one step, achieving holistic optimality._**
    -	Training the entire tree in one step, rather than split-by-split like existing methods. 
-	Due to this solution’s flexibility that the optimization framework provides; it comes in multiple flavours. An example would be:
    -	**OCT**: trees with parallel splits (one variable per split). Optimal trees can train parallel splits, meaning it splits one variable at a time. 
    -	**OCT-H**: trees with hyperplane splits (can use multiple variables per split if beneficial). Basically, optimal trees with hyperplane splits where multiple thereabouts can be used at a single split level. 
        -	This adds more modelling flexibility and power. 
        -	With large scale computational experiment with large datasets where hyperplanes significantly outperform CART in red. 


### Summary of Optimal Trees
-	Practitioners often have to choose between interpretability (CART) or performance (random forest)
-	Optimal Trees is a new method that maintains interpretability but delivers state-of-the-art performance. 

## Cross Validation

### Parameter Selection 
-	In CART, the value of “minbucket” can affect the model’s out-of-sample accuracy
    -	If _minbucket_ is too small, over-fitting might occur. 
    -	If _minbucket_ is too large, the model might be too simple. 
-	How should I set this parameter? 
-	I could select the value that gives the best testing set accuracy; but this isn’t right! 
-	**_The idea of the testing set is to measure model performance on data the model has never seen before. By picking the value of minbucket to get thebest test set performance, the testing set was implicitly used to generate the model._**
-	Instead, I am using a method called **_K_fold Cross Validation_**, which is one way to _properly select the parameter value_. 

### K-fold Cross-Validation
1.	Given the training set, I split the set into k equally sized subsets, or folds. In this example, I split into k pieces (k=5). 
2.	Then, I select k-1, or 4 folds, to estimate the model, and compute predictions on the remaining one fold, which is often referred to **_validation set_**. 
    -	Use k-1 folds to estimate a model, and test model on remaining one fold (“validation set”) for each candidate parameter value. 
3.	Repeat for each of the _k_ folds or pieces of our training set. 
    -	Thus, I would build a model using folds 1,2,3 and 5 to make predictions on fold 4. 
    -	Then, I would build a model using folds 1,2,4 and 5 to make predictions on fold 3, etc. 
Ultimately, cross validation builds many models, one for each fold and possible parameter value. Then, for each candidate parameter value, and for each fold, I can compute the accuracy of the model. Thus, I can average the accuracy over the k folds to determine the final parameter value I want to use. 
-	If parameter value is too small, then the accuracy is lower because the model is probably over-fit to the training set. 
-	If parameter value is too large, then the accuracy is also lower, because the model is too simple. 

### Cross-Validation in R
-	Before, I’ve used the parameter minbucket to limit my tree in R
-	When I use cross-validation in R, I will use a parameter called _cp_ instead. 
    -	**_Complexity Parameter_**
-	Complexity parameter is like _Adjusted R-Squared_ for linear regression, and _AIC_ for logistic regression
    -	In the sense, it measures the **_trade-off between model complexity and accuracy on the training set._**
-	A smaller cp value leads to a bigger tree (might overfit the model to training set). However, a cp value that’s too large might build a model that’s too simple. 

I used cross-validation in R to select the **cp value** for my CART tree. 
1.	I installed **_”caret” packages_** and the **_”e1071”_**
2.	Need to define how many folds I want using the trainControl function. 
    -	Using the cross validation method argument and also feeding the number of folds. 
3.	Picking the possible values for my _cp parameter_, using the _example.grid() function_.
    -	The argument I used defines my cp parameters to test as numbers from 0.01 to 0.5 in increments of 0.01. 
4.	Ready to perform cross validation, using the _train function_ where arguments are similar to building models.
    -	Arguments _”rpart”_ was used since I wanted to cross validate a CART model
    -	I get a table describing cross validation accuracy for different _cp parameters_. 
    -	The first column gives the cp parameter that was tested, and the second column gives the cross validation accuracy for that cp-value. 
    -	The bottom of the output, the most important take-away is **_”Accuracy was used to select the optimal model using the largest value. The final value used for the model was cp=0.18.”_**
    -	**_This is the cp value I will use in my CART model._**
5.	Creating a new CART model with this value of cp, instead of the minbucket parameter. 
6.	I took a step further to make predictions using this model to test its out-of-sample accuracy using a confusion matrix.
    -	With creating the confusion matrix using a _table()_ function; it’s important that I note that I feed arguments firstly, the true outcome and then my predictions to actually find the accuracy of the model. 
    -	Accuracy beats previous CART model. 
    -	This tree with the best accuracy has only one split!

#### Summary
Cross validation helps me ensure I’m selecting a good parameter value; and often this will **significantly increase the accuracy.** By using cross validation, I can be sure I am selecting a smart parameter value. 

## The Model v. The Experts
I want to illustrate whether a CART model can predict Supreme Court case outcomes better than a group of experts?
-	Martin used 628 previous Supreme Court cases between 1994 and 2001 to build their model. 
-	They made predictions for the 68 cases that would be decided in October 2002, before the term started. 
-	Their model had **_two stage approach based on CART_**:
    -	First stage: one tree to predict an unanimous liberal decision, other three to predict unanimous conservative decision. 
        -	If tree gave conflicting decisions or both predicted no, then they moved onto the next stage. 
        -	It turns out 50% of Supreme Court cases result in an unanimous decision; so this first stage is perfect for detecting the easier cases. 
    -	Second stage: consists of predicting decision of each individual justice, and using majority decision of all nine justices as a final \\\\\/;0’prediction

### The Experts
-	Martin and his colleagues recruited 83 legal experts
    -	71 academics and 12 attorneys 
    -	38 previously clerked for a Supreme Court justice, 33 were chaired professors and 5 were current or former law school deans
-	Experts only asked to predict within their area of expertise; more than one expert to each case
-	Allowed to consider any source of information, but not allowed to communicate with each other regarding predictions

### The Results 
-	For the 68 cases in October 2002:
-	Overall case predictions: Models had a significant edge over the experts in predicting the overall case outcomes.
    -	Model accuracy: 75%
    -	Experts accuracy: 59%
-	Individual justice predictions: Predictions were run for individual justices, the model and the experts performed very similarly. 
    -	Model accuracy: 67%
    -	Experts accuracy: 68%

## Conclusion
-	Predicting Supreme Court decisions is very valuable to firms, politicians and non-governmental organizations. 
-	A model that predicts these decisions is both more accurate and faster than experts
    -	CART model based on very high-level details of case beats experts who can process much more detailed and complex information
