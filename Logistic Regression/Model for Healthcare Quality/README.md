# Logistic Regression 

## Modelling the Expert 

-	I want to assess the quality of healthcare, patients receive through using the technique logistic regression.
    -	Using analytics in identifying poor quality care using claims data. 
-	A data mining company received claims data: these are data that are generated when an insured patient goes to a medical provider to receive a diagnosis or a procedure (e.g. x-ray, obtain drugs etc.)
    -	The medical providers need to get compensated, so the claims data provides the means for them to get paid. 
-	Important aspect of data science is knowing to frame the right questions for your data science project. 
-	In this case, _can I assess the quality of healthcare given this claims data? 
    -	The reason why I would like to assess the quality of healthcare because it is important to identify patients that have low quality care, thus one can intervene and improve outcomes for these patients. Furthermore, assessing quality correctly can control costs better. 
    -	Please note that defining “quality” is a complex, not-well defined task. For example, consider what is involved when we talk about the quality of a book. It is not well-defined algorithmically understood task of defining such a quality. 
        -	Currently, assessing quality is done by physicians who are experts in the health space using their knowledge, their expertise, and their intuition. Nevertheless, they are limited by memory and time. They typically evaluate quality by examining the patient’s records, a time consuming and inefficient process. 
        -	Clearly, physicians cannot assess quality for millions of patients, and the data mining quality had millions of patients who receive claims data on a monthly basis that the quality of them needs to be assessed. 

**Key question**: Can we develop analytics tools that replicate expert assessment on a large scale?

**Goal**: To learn from expert human judgement by developing a model, interpret the results of the model, and further adjust the model to improve predictability. 

**Objective**: Make predictions and evaluations on a large scale basis, to be able to process millions of assessing the health care quality for millions of people. 

## Building the Dataset 

-	Medical claims are generated when a patient visits a doctor for diagnosis, procedures etc. 
-	Pharmacy claims involve drugs, the quantity of these drugs, the prescribing doctor, as well as medication costs. 
-	Claim data are **electronically available** and they are _standardized_.
    -	However, since humans generate them, they are not **100% accurate**. Often, **under-reporting** is common in the sense that it’s a tedious job to record these claims. Also, **_claims for hospital visits can be vague_**.
-	Objective: Creating a dataset to assess healthcare quality. 
    -	I used a large health insurance claims database, and randomly selected 131 diabetes patients aged from 35-55, and the costs were from $10,000 to $20,000; these claims were recorded from September 1, 2003 to August 31, 2005. 
    -	The dependent variable was the quality of care. 
    -	The independent variable involve the ongoing use of narcotics; only on Avandia, not a good first choice drug; had regular visits, mammogram, and immunizations; was given home testing supplies. 
        -	Overall, the independent variables involved diabetes treatment variables, patient demographics, healthcare utilization providers, claims, and prescriptions. 
    -	The dependent variable was modelled as a binary variable – 1 for low quality care and 0 for high-quality care. This is a **_categorical variable_** that takes only two possible values. 
-	We have seen linear regression as a way of predicting continuous outcomes. 
-	I can utilize linear regression to predict quality of care here, but then I have to round the outcome to 0 or 1. Instead, I used logistic regression, which is an extension of linear regression to environments where the dependent variable is categorical. In our case, 0 or 1. 

## Explaining Logistic Regression with Business Problem

-	**_Logistic Regression predicts the probability of the outcome being true._**
-	I want to use logistic regression to predict the probability that the patient is receiving poor care:
    -	Denotes dependent variable “Poor Care” by ‘y’ and the probability that y=1. 
    -	Denote “Poor Care” = 1 and “Good Care” = 0
    -	P(y=1)
-	Then P(y=0) = 1 – P(y=1)
-	Independent variables x¬1, x2, …, xk,, where k denotes the number of independent variables there are. 
-	To predict the probability that y=1, I used **_Logistic Response Function._**
    -	The Logistic Response Function contains a linear regression equation within this function and used to produce a number between 0 and 1 (probability). 
    -	A positive coefficient value for a variable increases the linear regression equation within the function (x-axis), and thus _increases the probability that y=1_ i.e. increases the probability of poor care. 
    -	A negative coefficient value for a variable decreases the linear regression piece, therefore decreasing the probability that y=1 i.e. increases probability of good care. 
    -	The coefficients are selected to
        -	Predict a high probability for the poor care cases and,
        -	Predict a high probability for the actual good care cases. 
    -	Think of Logistic Response Function in terms of Odds (like in gambling)
        -	Odds = P(y=1)/P(y=0)
        -	Odds > 1, if y=1 is more likely 
        -	Odds < 1, if y=0 is more likely
        -	If you substitute the Logistic Response Function for the probabilities of odds equation:
            -	Odds = eβ0 +β1x1 + β2x2+---+βkxk
            -	Log(Odds) = β0+β1x1 + β2x2+…+βkxk
            -	This is called the “Logit” and looks like linear regression and thus the above two equations effectively displays how coefficients (betas) affect our prediction of probability. 
                -	A positive coefficient increases the Logit, and in turn increases the Odds of 1
                -	A negative coefficient decreases the Logit, thus decreases the Odds of 1.
                -	The bigger the Logit is, the bigger P(y=1)

# Model for Healthcare Quality

-	**MemberID** numbers the patients from 1 to 131, and is just an identifying number.
-	**InpatientDays** is the number of inpatient visits, or number of days the person spent in the hospital.
-	**ERVisits** is the number of times the patient visited the emergency room.
-	**OfficeVisits** is the number of times the patient visited any doctor's office.
-	**Narcotics** is the number of prescriptions the patient had for narcotics.
-	**DaysSinceLastERVisit** is the number of days between the patient's last emergency room visit and the end of the study period (set to the length of the study period if they never visited the ER). 
-	**Pain** is the number of visits for which the patient complained about pain.
-	**TotalVisits** is the total number of times the patient visited any healthcare provider.
-	**ProviderCount** is the number of providers that served the patient.
-	**MedicalClaims**is the number of days on which the patient had a medical claim.
-	**ClaimLines** is the total number of medical claims.
-	**StartedOnCombination** is whether or not the patient was started on a combination of drugs to treat their diabetes (TRUE or FALSE).
-	**AcuteDrugGapSmall** is the fraction of acute drugs that were refilled quickly after the prescription ran out.
-	**PoorCare** is the outcome or dependent variable, and is equal to 1 if the patient had poor care, and equal to 0 if the patient had good care.

In a classification problem, a standard baseline method is to just predict the most frequent outcome for all observations. 
-	Since **Good Care** is more frequently common than **Poor Care**
-	I would predict that all patients are receiving good care, 98/131 observations would give an accuracy rating of 75%. 
-	My baseline method has an accuracy of 75%
-	Thus, I will use Logistic Regression to build a model to beat this

Splitting dataset into training and test set so the test set can measure the out-of-sample accuracy:
-	I used the sample.split() function from the caTools package to split data for a classification problem, balancing the positive and negative observations in the training and test sets. 
-	You need to set a seed to initialize a random number generator in order the function to split the data in a certain way. 
-	Function arguments are:
    -	First argument is the outcome variable which is the Poor Care quality variable.
    -	Second argument is the percentage of the data that I want in the **training set**.
    -	This function randomly splits the data and makes sure the outcome variable is well balanced in each piece.
    -	I found out earlier that 75% of the patients are receiving good care, thus in both my training and test set will have 75% of patients receiving good care. 
    -	Thus, my test set is representative of my training set
-	When building my training set and test set, I liked to use the subset() function where the conditional argument is split == TRUE/FALSE depending on the set. 

## Building the Model
Using the **glm() function** for “generalised linear model” to build my logistic regression model.
-	The first argument is the equation I feed to this function just like when I build my linear regression models. 
-	Then I gave the name to the function of the dataset I want to use to build this model
-	The last argument is the “family=binomial” to tell the glm() function to build a logistic regression model. 
Looking at the summary of the regression model, focusing specifically on the coefficients table:
-	It gives me the estimate values for the coefficients (betas) for my logistic regression model. 
-	The independent variables have positive coefficients, meaning higher values are indicative of poor care. 
-	Both variables are statistically significant in my model 
-	**_What’s also important to observe is the AIC value. This is a measure of the quality of the model like the Adjusted R Squared and it takes into account for the number of variables used, compared to number of observations._**
    -	The preferred model is the one with the minimum AIC

## Making Predictions on Training Set
I used the predict() function to make predictions on the logistic regression model I have just created and I told my predict() function to give me probabilities through a second argument **_type=”response”_**
-	Since I’m expecting probabilities
-	When I inspect the statistical summary of my predictions, I should expect numbers between 0 and 1. 

# Thresholding - Assessing Accuracy of Predictions
-	The outcome of a logistic regression model is a probability. 
-	I want to make a binary prediction
    -	Did this patient receive poor care or good care?
    -	I will do this using a _threshold value_ t.
        -	I can convert the probabilities to predictions using this threshold value ‘t’. 
        -	If P(PoorCare=1) >= t, predict poor quality care
        -	If P(PoorCare=1) < t, predict good quality care
        -	I need to determine which value, I need to pick for t. 
        
### Threshold Value
-	Threshold value is selected based on which errors are “better”
    -	It’s rare to have a model that predicts perfectly, so I am bound to make some errors
-	If ‘t’ is **large**, then predict poor care rarely since P(y=1) has to be very large to be greater than the threshold. 
    -	More errors where we say good care, but it is actually poor care 
    -	Detects all patients who might be receiving poor care and prioritize them for intervention
-	If ‘t’ is **small**, I predict poor care frequently and predict good care rarely.
    -	Meaning, I will make more errors where I say poor care, but it’s actually good care. 
    -	This approach detects all patients _who might be receiving poor care._
-	With no preference between the errors, select t = 0.5
    -	Predicts the more likely outcome 
-	Sensitivity = TP/(TP+FN), it measures the percentage of actual poor care cases that I classify correctly i.e. True Positivity Rate. 
-	Specificity = TN/(TN+FP), measures the percentage of actual good care cases that I classify correctly again i.e. True Negative Rate. 
    -	A model with a higher threshold will have a lower sensitivity and a higher specificity rate. 

Computing confusion matrices using different threshold values:
-	When using the table function, it takes the following arguments:
    -	The first argument (labelling the **rows**) should be the true outcome “PoorCare”. 
    -	The second argument (labelling the **columns**) will be **predictTrain > 0.5**
    -	This will return TRUE if my predictions is > 0.5, and false if < 0.5. 
-	Observations:
    -	For 70 cases, I predicted good care and they actually received good care; and for 10 cases who received poor care also actually received poor care. 
    -	I made 4 mistakes where I mentioned poor care, when it’s actually good care; and 15 mistakes where good care was suppose to be poor care. 
    -	Sensitivity Rate = 10/25 = 0.4
    -	Specificity Rate = 70 /74  = 0.94
-	Increasing the threshold values to 70%. 
    -	Sensitivity Rate = 8/25 = 0.32 
    -	Specificity Rate = 73/74 = 0.98 
    -	Notice by increasing threshold, my sensitivity rate went down and my specificity rate went up. 
    
# ROC Curves
Receiver Operator Characteristic Curve (ROC) can help me decide which t-value is best. Choosing the best threshold for the **best trade off** based on:
-	Cost of failing to detect positives 
-	Cost of raising false alarms
Generating ROC curves:
-	Using the prediction() function, I used two arguments; first is the prediction I made, and second argument is the true outcomes of my data points **qualityTrain$PoorCare**. 
-	The next function I implemented is the performance() function to define what I’d like to plot on the x and y-axes of my ROC curve
```r
ROCRpred = prediction(predictTrain,qualityTrain$PoorCare)
ROCRperf = performance(ROCRpred, "tpr","fpr")
plot(ROCRperf,colorize = TRUE,print.cutoffs.at=seq(0,1,0.1),text.adj=c(-0.2,1.7))
```
Understanding threshold values and ROC curves:
-	If I wanted to pick a threshold to _correctly_ identify a small group of patients receiving the worst quality care with high confidence
    -	I would pick a threshold of 0.7
    -	At this threshold, I make very few false positive mistakes and identify about 35% of the true positives 
    -	Threshold 0.8 is not a good choice since it makes the same number of false positives, but only identifies 10% of the true positives. 
    -	Threshold 0.2/0.3 both identifies more of the true positives, but make much more false positive mistakes so my confidence decreases. 
-	If I wanted to pick a threshold to correctly identify half o f the patients receiving good care, while making as few errors as possible then:
    -	A threshold value of t = 0.3 would be excellent since t = 0.2 also identifies half of the patients receiving poor care (true positives) but it makes many more false positive mistakes. 

# Interpreting the Model
-	Multicollinearity could be a problem; it occurs when various independent variables are correlated, and this confuses the coefficients (betas) in the model. I make sure to test to address that involve checking the correlations of the variables. 
    -	Do the coefficients make sense? Does the signs of the coefficient make sense? Is the coefficient beta positive or negative? If intuition suggests a different sign, then this might be a sign of multicollinearity. 
    -	Check correlations. 
-	To interpret whether I have a good model or not, I always look at the **_significance_**.

## Area Under the ROC Curve (AUC)
-	Given a random patient from the dataset who received poor case and a random patient from the dataset who actually received good care. The AUC percentage of time that my model will classify which is which correclty
-	The area under the curve shows an absolute measure of quality of prediction; a measure of quality 
    -	Less affected by sample balance than accuracy
-	What is a good AUC? 
    -	Maximum of 1 (perfect prediction). 
    -	Minimum of 0.5 is _pure guessing_. 
-	Sensitivity is an important component of an ROC curve; sensitivity is TP (True Positives) whenever I predict poor quality and it is actually poor quality care the patient is receiving; divided by TP (True Positives) + FN; which is the total number of cases of poor quality. 
    -	Sensitivity (True Positive Rate) is the total number of times that I predict poor quality and it is, indeed, poor quality, versus the total number of times the actual quality is, in fact poor. 
    -	False Negative Rate 
-	Just like in linear regression, I want to make predictions on a test set to compute out-of-sample metrics
    -	The below makes prediction for probabilities; the test utilises 32 cases
    -	**_Logistic regression makes predictions about probabilities and then I transform them into a binary outcome i.e. quality is good or quality is bad using a threshold._**
```r
predictTest = predict(QualityLog,type=”response”,newdata=qualityTest)
```

# Summary 
-	An expert-trained model can accurately identify diabetics receiving low-quality care
    -	Out-of-sample accuracy of 78%
    -	Identifies most patients receiving poor care 
-	In practice, the probabilities returned by the logistic regression model can be used to prioritize patients for intervention
-	While the accuracy is 78%, which is reasonably high; it can of course be improved further.
-	In that respect, I expect that electronic medical records (not only claims) could be used in the future to enhance predictive capability of such models. 
    -	Such a model like the one I built can be used to analyse literally millions of records, granted that such a model can be scaled significantly larger. 
    -	Whereas a human can only accurately analyse rather small amounts of information, models allow larger scalability. 
-	Keep in mind, that models don’t replace expert judgement
    -	What Data Scientist can do is improve and refine the model 
    -	Models provide a way to translate expert judgement to a reproducible, testable prediction methodology that has significantly higher scalability. 
