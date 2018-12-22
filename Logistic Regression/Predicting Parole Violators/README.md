# Predicting Parole Violators

## Motivation

In many criminal justice systems around the world, inmates deemed not to be a threat to society are released from prison under the parole system prior to completing their sentence. 

They are still considered to be serving their sentence while on parole, and they can be returned to prison if they violate the terms of their parole.

Parole boards are charged with identifying which inmates are good candidates for release on parole. 

They seek to release inmates who will not commit additional crimes after release. 

## Objective

In this problem, I will build and validate a model that predicts if an inmate will violate the terms of his or her parole. 

**_Such a model could be useful to a parole board when deciding to approve or deny an application for parole._**

For this prediction task, I will use data from the [United States 2004 National Corrections Reporting Program](https://www.icpsr.umich.edu/icpsrweb/NACJD/studies/26521), a nationwide census of parole releases that occurred during 2004. 

I limited my focus to parolees who served no more than 6 months in prison and whose maximum sentence for all charges did not exceed 18 months. 

## Dataset

The dataset contains all such parolees who either successfully completed their term of parole during 2004 or those who violated the terms of their parole during that year. 

The dataset contains the following variables:
-	**male:** 1 if the parolee is male, 0 if female
-	**race:** 1 if the parolee is white, 2 otherwise
-	**age:** the parolee's age (in years) when he or she was released from prison
-	**state:** a code for the parolee's state. 2 is Kentucky, 3 is Louisiana, 4 is Virginia, and 1 is any other state. The three states were selected due to having a high representation in the dataset.
-	**time.served:** the number of months the parolee served in prison (limited by the inclusion criteria to not exceed 6 months).
-	**max.sentence:** the maximum sentence length for all charges, in months (limited by the inclusion criteria to not exceed 18 months).
-	**multiple.offenses:** 1 if the parolee was incarcerated for multiple offenses, 0 otherwise.
-	**crime:** a code for the parolee's main crime leading to incarceration. 2 is larceny, 3 is drug-related crime, 4 is driving-related crime, and 1 is any other crime.
-	**violator:** 1 if the parolee violated the parole, and 0 if the parolee completed the parole without violation.

# Analysis 

## Preparing the dataset

With the unordered factors of at least 3 levels, I need convert them to factors for my prediction:
-	Using the as.factor() function to convert these variables to factors. 
-	Keep in mind, I am not changing the values but rather, just the way R understands them (the values are still numbers). 

## Splitting into a Training and Test set
I want to ensure consistent training/testing set splits:
-	SplitRatio == 0.7 causes split to take the value TRUE roughly 70% of the time, so train should contain roughly 70% of the values in the dataset. 
-	Note, if I instead called the function set.seed() with a different number, you will get a different training/testing set split. 

## Building a Logistic Regression Model

I built a model to predictor the variable “violator” using all the independent variables:
-	My model predicts that a parolee who committed multiple offenses has 5.01 times higher odds of being a violator than a parolee who didn’t commit multiple offenses but is otherwise identical:
    -	For parolees A and B who are identical other than A having committed multiple offenses, the predicted log odds of A is 1.6 more than the predicted log odds of B, then I have:
    -	Ln(odds of A) = Ln(odds of B) + 1.61
    -	Exp(Ln(odds of A)) = exp(Ln(odds of B))*exp(1.6)
    -	In the second step, I raised e to the power of both sides. 
    -	Odds of A= exp(1.51)* odds of B
    -	I used the exponential rule that e^(a+b) = e^a * e^b
    -	Odds of A = 5.01*odds of B
        -	I used the rule that e^(ln(x)) = x

I am considering a case where a parolee who is male, of white race, aged 50 years at prison release, from the state of Maryland, served 3 months, had a maximum sentence of 12 months, didn’t commit multiple offenses, and committed a larceny. 

Using the coefficients of my model and the Logistic Response Function, and the Odds equation to solve my problem; I want to find out:
-	The odds this individual is a violator is:
    -	Log(odds) = -4.2 + 0.38*male + 0.88*race – 0.00017*age + 0.44*state2 + 0.83*state3 – 3.39*state4 – 0.12*time.served + 0.08*max.sentence + 1.61*multiple.offenses + 0.68*crime2 – 0.27*crime3 – 0.011*crime4
        -	This parolee has male =1, race =1, age = 50, state2 = 0, state3 = 0, state4 = 0, time.served = 3, max.sentence = 12, multiple.offenses = 0, crime2=1, crime3=0, crime4 = 0. 
        -	Log(odds) = -1.7
        -	Odds ratio is exp(-1.7) = 0.183
    -	Logistic Response Function: Probability = 1/(1+exp^negative linear regression).
        -	Probability = 1/(1+exp(1.7) = 0.154

## Evaluating the Model on the Testing Set
Using the predict() function to obtain the model’s predicted possibilities for parolees in the testing set, remembering to pass the argument type=”response” to output probabilities. 

To evaluate my model’s predictions on the test set using a threshold of 0.5, I always observe:
-	Model’s Sensitivity = TP/(TP+FN) = 12/(12+11) = 0.52
-	Model’s Specificity = TN/(TN+FP) = 169/(169+10) = 0.94
-	Model’s Accuracy = (TN+TP)/All Observations

Computing the accuracy of a simple baseline model that predicts that every parolee is a non-violator:
-	Observation shows 179 negative examples, which are the ones that the baseline model would get correct. 
-	The accuracy of parolee being a non-violator is 179/202 = 88%

# Approach 
A parole board using a model like mine to predict whether parolees will be violators or not. 

The job of a parole board is to make sure that a prisoner is ready to be released into free society, and therefore parole boards tend to be particularly concerned about releasing prisoners who will violate their parole. 

The board would assign more cost to a false negative than a false positive, and should therefore use a logistic regression cut-off less than 0.5:
-	If the board used a model like mine for parole decisions, a negative prediction would lead to a prisoner being granted parole, while a positive prediction would lead to a prisoner being denied parole. 
-	The parole board would experience more regret for releasing a prisoner who then violates parole (a negative prediction that is actually positive, or false negative) than it would experience for denying parole to a prisoner who would not have violated parole (a positive prediction that is actually negative, false positive). 
-	Decreasing the cut-off leads to more positive predictions, which increases false positives and decreases false negatives. Meanwhile, increasing the cut-off leads to more negative predictions, which increases false positives and decreases false positives. 
-	The parole board assigns high cost to false negatives, and therefore should decrease the cut-off. 

Using the ROCR package, I calculate the AUC value on model’s ability to make predictions on the test set:
-	Using the prediction() function on my vector/matrix containing predictions and also pass the dependent variable of the test set. To calculate AUC:

```r
as.numeric(performance(pred,”auc”)@y.values)
>0.90
```

-	The probability of the model can correctly differentiate between a randomly selected parole violator and a randomly selected parole non-violator. 

# Bias in Observational Data

My goal has been to predict the outcome of a parole decision, and I used a publicly available dataset of parole releases for predictions. 

I am evaluating a potential source of bias associated with my analysis, it’s important to evaluate a dataset for possible sources of bias. 

The dataset contains all individuals released from parole in 2004, either due to completing their parole term or violating the terms of their parole.
-	_However, it does not contain parolees who neither violated their parole nor completed their term in 2004, causing non-violators to be underrepresented._
-	This is called **_”selection bias”_**, or **_”selecting on the dependent variable,”_** because only a subset of all relevant parolees were included in my analysis, based on my dependent variable in this analysis (parole violation); the way I improved my dataset to best address selection bias is:
    -	Start using a dataset tracking a group of parolees from the start of their parole until either they violated parole, or they completed their term, would be the best approach.  
        -	A prospective dataset that tracks a cohort of parolees and observes the true outcome of each is more desirable.
        -	Unfortunately, such datasets are often more challenging to obtain (e.g. a parolee had a 10-year term, it might require tracking that individual for 10 years before building the model). 
    -	Expanding the dataset to include missing parolees and labelling each as violator = 0 would improve the representation of non-violators; but it _does not capture the true outcome since the parolee might become a violator after 2004._
    -	Labelling these new examples with violator=NA correctly identifies that I do not know their true outcome, I cannot train or test a prediction model with a missing dependent variable. 

