# The Framingham Heart Study

The Framingham Heart Study is one of the most important epidemiological studies ever conducted, and the underlying analytics that led to our current understanding of cardiovascular disease. 

There was misconceptions of blood pressure in the first half of the 20th century:
-	High blood pressure (hypertension) was considered important to force blood through the arteries and it was considered harmful to lower blood pressure 
-	Today, with better knowledge. 

In the late 1940s, the US government set out to better understand cardiovascular disease (CVD). 
-	Plan: **_Track large cohort of initially healthy patients over their lifetime._**
-	Framingham was the city to conduct this experiment; _an appropriate sample size. 
    - Note: Framingham was selected since it had an appropriate size; a stable population, and the doctors and residents in the town were willing to participate. 
    -	_However_, the city does not represent ALL types of people in US and there were not an abnormally large number of people with heart disease.
    
-	Patients were given questionnaire and an examination every 2 years.	
    -	Physical characteristics 
    -	Behavioural characteristics
    -	Test results
   
-	The key point of the study was the trajectory of the patient’s health over the lifespan. 
-	**_I built a model using the Framingham data to predict and prevent heart disease_**. 

I will use the dataset framingham.csv to build a logistic regression model. 

Please download this dataset to follow along. This data comes from the [BioLINCC website](https://biolincc.nhlbi.nih.gov/media/teachingstudies/framdoc.pdf)

# Logistic Regression Model 

## An Analytical Approach
-	Randomly split patients into training and testing sets
    -	I used the **_sample.split()_** function from the **_caTools_** library
    -	The first argument is the outcome variable i.e. _what I’m predicting_. 
    -	I have a lot of data in this dataset, so I can afford to put 65% of it into the training set. 
    -	The more data I have, the more I can put into the testing set to increase my confidence in the ability of the model to do well with new data. 
-	Use logistic regression on training set to predict whether a patient experienced CHD within 10 years of first examination 
    -	All of the risk factors were collected at the first examination of the patients
    -	Demographic risk factor variables such as male, age, and education; behavioural risk factors “**currentSmoker**” and “**cigsPerDay**”; medical history risk factors and physical exam risk factors. 
-	I will then evaluate the predictive power on the test set

## Model Observations

I observed which variables are significant after creating my model and also whether the significant variables have positive coefficients or not; meaning high values of these variables contribute to a higher probability of a 10-year coronary heart disease. 

## Making Predictions on Test Set 

Using the model, I will use the predict() function on my test set; the arguments I used:
-	First argument is the model that I will use to make predictions on the test data
-	Second argument is “**_type=’response’_**” where this argument will return probabilities 
-	The last argument is predicting on the test set

To create a confusion matrix with a preference threshold (0.5); I will use the table function; the arguments used:
-	Actual values **_”test$TenYearCHD”_**
-	Second argument will be my predictions predictTest > 0.5
    -	With a threshold of 0.5, the observations tell me that my model rarely predicts a 10-year CHD risk above 50%
    -	What’s the accuracy of this model? The sum of the cases I get right (TP+TN)/Total No. Observations  
    -	Model accuracy is 84.8%. 
        -	I want to compare this model accuracy to the accuracy of a simple baseline method: 84.4%. 
        -	My model barely beats the baseline in terms of accuracy 
        -	The next question I ask myself is how I can have a valuable model by varying the threshold? 
        -	Computing the out-of-sample AUC
            -	Loading ROCR package to use prediction() function of its package
            -	First argument is my predictions 
            -	Second argument is the true outcome “**_test$TenYearCHD_**”
            
```r
>  as.numeric(performance(ROCRpred,”auc”)@y.values)
```

-	AUC of about 74% on my test set which means that the model can differentiate between low risk patients and high-risk patients pretty well
    -	The model I built rarely predicted 10-year CHD risk patients above 50% threshold so the accuracy of model was very close to the baseline model 
    -	However, the model could differentiate between low risk patients and high risk patients well with an out-of-sample of 0.74. 
-	Some significant variable suggests interventions:
    -	Smoking
    -	Cholesterol 
    -	Systolic blood pressure 
    -	Glucose

# Validating the Model 
Internal Validation (to test model): Taking the data from one set of patients and split them into a training set and a testing set.
-	While this is good for making predictions for patients in the Framingham Heart Study population; it is unclear the model generalizes to other populations. 
-	The Framingham cohort of patients were white, middle class adults. 
-	To be sure that that the model extends to other types of patients, I need to test on other populations; this is **_external validation._**
-	Note: For my model that will can be used on different populations than the one used to create my model, external validation is critical. 

# Interventions 
1.	Identify Risk Factors 
2.	Predict Heart Disease
3.	Validate Model 
4.	**_Define Interventions using Model_**

Drugs to Lower Blood Pressure
-	The first intervention has to do with drugs to lower blood pressure 
-	Diuretic chlorothiazide was developed, and after trials to test its affect for blood pressure drugs has found that the drugs led to decreased risk of CHD. 

Drugs to Lower Cholesterol 
-	This is another intervention; despite Framingham results, early cholesterol drugs were too toxic for practical use
-	In the 70’s, the first statins were developed. 
-	Of a study of 4,444 patients with CHD: statins cause 37% risk reduction of second heart attack 


# Impact of the Heart Study Through the Years
-	More than 2,400 studies use Framingham data 
-	A lot of risk factors evaluated 
    -	Obesity
    -	Exercise 
    -	Psychosocial issues
    -	…
    
-	In addition to the study, there is an online tool that assesses the risk for your 10-year risk of having a heart attack using input of your age, gender, total cholesterol, the HDL cholesterol etc. then it calculates 10-year risk. 
-	A very important impact of the study is:
    -	The development of clinical decision rules. 
    -	The early work on the study paved the way for clinical decision rules as it is done today 
