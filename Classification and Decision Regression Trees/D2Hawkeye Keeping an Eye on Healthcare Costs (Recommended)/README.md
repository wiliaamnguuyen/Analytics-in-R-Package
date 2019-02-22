# Keeping an Eye on Healthcare Cost

## The Story of D2Hawkeye
-	D2Hawkeye combines expert knowledge and databases with analytics to improve quality and cost management in healthcare. 
-	It starts with medical claims consisting of diagnoses, procedures and drugs. These claims are then processed via aggregate, cleaning and normalization. This data then enters secure databases on which predictive models are applied. The output of these predictive models are specific reports that give insight into various questions that D2Hawkeye aspires to answer. 

### Healthcare Case Management
-	D2Hawkeye tries to improve healthcare case management
    -	Identify high risk patients
    -	Work with patients to manage treatment and associated costs
    -	Arrange specialist care
-	Medical costs often relate to severity of health problems, are an issue for both patient and provider. 
-	Goal: improve the quality of cost predictions 

### Impact
-	Many different types of clients
    -	Third party administrators are companies hired by the employer who manage the claims of the employees
    -	Case management companies 
    -	Benefit consultants 
    -	Health plans 

### Pre-Analytics Approach
-	Based on human judgement – doctors manually analysed patient histories and developed rules. This was costly and inefficient; can we use analytics instead?
-	Using analytics will allow D2Hawkeye to analyse millions of patients and make predictions on cost faster. 

**Note**: It is very important that the models are interpretable, thus trees are a great model to use in this situation. 



## Claims Data
-	Data sources in health care industry; healthcare industry is data-rich but hard to access. 
    -	Unstructured – doctor’s notes. 
    -	Unavailable – hard to get due to differences in technology in different states. 
    -	Inaccessible – strong privacy laws around health care data sharing. 

### Available Healthcare Data
-	Claims data are requests for reimbursement submitted to insurance companies or state-provided insurance from doctors, hospitals and pharmacies. 
-	Claims data are rich, structured data source. 
-	However, this collection of data doesn’t capture all aspects of a person’s treatment or health – many things must be inferred. 
-	Unlike electronic medical records, we don’t the results of a test, only that a test was administered. 


### D2Hawkeye’s Claim Data
A common problem in analytics that I understand is that data is available, but it’s not the ideal dataset; which is the core problem for D2Hawkeye’s situation where they only have the _claims data_. An important piece of information is that it does not contain the results of any procedure performed on a patient. 

## The Variables
To build an analytics model, I want to go through the variables. 
-	There was 13,000 diagnoses; the codes for diagnosis that claims data utilize. 
-	22,000 different codes for procedures
-	45,000 codes for prescription drugs. 
To work with this amount of variables, they aggregated variables as follows:
-	Out of 13,000 diagnoses, **217 diagnoses groups**were defined
-	Out of 22,000 procedures; data was aggregated to **213 procedure groups**. 
-	From 45,000 prescription drugs; there was ***189 therapeutic groups**.

### Additional Variables
-	Indicating whether patient has chronic or acute condition cost indicators
-	In collaboration with medical doctors, 269 medically define risk rules 
    -	Interactions between various illnesses; for e.g., obesity and depression. 
    -	Interaction between diagnosis and age; for e.g. more than 65 years old and coronary disease. 
    -	Noncompliance to treatment; for e.g. not taking a drug order. 
    -	Illness severity; for e.g. severe depression. 
-	Gender and age. 

### Cost Variables 
-	Rather than using cost directly, the costs are bucket and consider everyone in the group equally. 
-	Meaning, rather than have individual costs for millions of the claims data that are submitted; the cost of an individual person fall into one of the 5 buckets; thus categorizing the costs data into 5 ranges. 
    -	**_Medical interpretation of “Buckets_**: Costs of individuals fall into one of the buckets to see their needs to be in a Wellness Program, ranging Bucket 1 (low chance) to Bucket 5 (very high chance of being selected to be in the program).
    -	Further explanation: Bucket 5 are where high risk patients fall into and thus they are candidates for disease management programs. 

Ideally, it would be great to have all the data for this problem; what to do to get around is define new variables using the data that is available. This solution is conveyed through the following variables that were created to help predict health care costs.
-	Variables to capture chronic conditions
-	Noncompliance to treatment
-	Illness severity
-	Interactions between illnesses

These variables were defined using claims data to improve cost predictions and shows how to define new variables and improve the model when given the problem of not an ideal dataset. 

## Error Measures
Typically, I use R Squared but others can be used:
-	The next measure, **_”penalty error”_**; is motivated by the fact that I can classify a very high-risk patient has a low-risk patient, this is more costly than the reverse i.e. classifying a low-risk patient as a high-risk. 
-	In the case of D2Hawkeye, failing to classify a **high-cost patient** correctly is **worse** than failing to classify a **low-cost patient** correctly. 
-	Thus, using a “penalty error” is best to capture this asymmetry. 

### Penalty Error. 
-	Key idea: use asymmetric penalties. 
-	Define a “penalty matrix” as the cost of being wrong. 

### Baseline 
-	To judge the quality of the analytics model developed; compare it to the baseline. 
-	The baseline is to simply predict that the cost in the next “period” will be the cost in the current period. 
-	Accuracy of 75%, meaning when I predict that the risk is **bucket 3**; it will be indeed **bucket 3** 75% of the time. 
-	Average penalty error of 0.56. 

## CART to Predict Cost
The method for predicting the bucket number is **classification and regression trees** and in this case, I am using **_multi-class classification_** since there are 5 classes, buckets 1-5. 
Consider the following example: 
-	Patients having two types of diagnoses: coronary artery disease and diabetes. 
-	If a patient doesn’t have this disease, I would classify the patient as bucket 1. 
-	If it has a coronary artery disease, then I check whether the person has diabetes or doesn’t have diabetes. If it does, then it’s bucket five, very high risk. If it doesn’t have diabetes; it is classified as bucket three. 
In the application of Hawkeye, the most important factors were related to cost in the beginning. 
-	The classification trees involved divisions based on cost. 
-	For example; if the patient had paid less than $4000, then this patient is classified as bucket 1.
-	If it paid more than $4000, then further investigation is done whether the patient pays less than $40,000 or more and so forth.

###Secondary Factors
-	As the tree grows, then the secondary factor is utilized later in the classification tree involving various chronic illnesses and some of the medical rules I discussed earlier. 
-	For example, where or not patient has asthma and depression. Then this patient is classified as bucket 5. 

### Example Groups for Bucket 5
-	Under 35 years old, between $3300 and $3499 in claims, coronary artery diagnoses but no office visits in the last year.
Classification trees have the major advantage as being interpretable by the physicians who observe them and judge them i.e. _human intuition agreed with the output of the analytics model_. 

## Claims Data in R
This data comes from the DE-SynPUF dataset, published by the United States Centers for Medicare and Medicaid Services (CMS).

I am going to create CART models to predict health care costs; the dataset I will be using is structured to represent a sample of patients in the Medicare program, which provides health insurance to Americans aged 65 and older as well as younger people with certain medical conditions. 

To protect the privacy of patients represented in this available public data; I need to retrain the models I develop on de-anonymized data if I wanted to apply this model in the real world. 

The observations in this dataset represents 1% random sample of Medicare beneficiaries; this is limited to those still alive at the end of 2008. 
-	The independent variables are from 2008, and I will be **_predicting the cost in 2009_**.
-	**Independent variables:** Patient’s age in years at end of 2008, and then several binary variables indicating whether or not patient had diagnosis codes for a particular disease or related disorder in 2008. Each of these variables will take value 1 if patient had diagnosis code for the particular disease. 
    -	**Reimbursement2008** variable is the total amount of Medicare reimbursements for this patient in 2008. 
    -	**Reimbursement2009** variable is the total value of all Medicare reimbursements for the patient in 2009. 
    -	**Bucket2008** is the cost bucket the patient fell into in 2008. 
    -	**Bucket2009** is the cost bucket the patient fell into in 2009.
-	The cost buckets are defined using the threshold as follows:
    -	First cost bucket contains patients with healthcare costs less than $3000
    - Second cost bucket contains patient with costs between $3000 and $8000 and so on.
Using the dataset; I can verify the number of patients in each cost bucket has the same structure as outlined above by computing the percentage of patients in each cost bucket using the table function. 
**The percentage of patients in each of the cost bucket**:

> table(claims$bucket2009)/nrow(claims)*100


-	The vast majority of patients has low cost healthcare. 

#### Goal
The goal will be to predict the cost bucket the patient fell into in 2009 using a CART model.
Before anything, I split the data into a training set and a testing set. 


## Baseline Method and Penalty Matrix
I want to investigate how a smart baseline method would perform. 
The baseline method would predict that the cost bucket for a patient in 2009 will be the same as it was in 2008. Thus, in my code; I created a classification matrix to compute its accuracy for the baseline method on the test set. 
Computing penalty error:
-	To create a penalty matrix; it is structured as **the actual outcomes on the left and the predicted outcomes on the top.**
-	To reiterate, the worst outcomes are when I predict a low cost bucket but the actual outcome is a high cost bucket. 
-	**Penalty Error = Classification Matrix x Penalty Matrix
o	Each entry in the classification matrix is multiplied by the corresponding number in the penalty matrix. 
o	Computing the penalty error is simple as just summing it up and dividing the number of observations in the test set. 
o	Penalty error is 0.74

## Predicting Healthcare Costs in R
**Note:** Even though, I have a multi-class classification problem; I still built my tree model the same way I would build with a binary classification problem. 
Method to test the accuracy of the model:
1.	Create classification tree model. 
2.	Create predictions on the test set using above model. 
3.	Create a classification matrix on test set to compute accuracy (_table()_ function).
4.	Accuracy = sum of the diagonals of the matrix divided by the total observations on the test set. 

### Observations: 
-	Accuracy of model created is 75% and penalty error of 0.75. 
-	Baseline model had an accuracy of 68% and penalty error of 0.74. 
-	While my accuracy increased, why did my penalty error increase as well? 
-	My CART model rarely predicts bucket 3,4 and 5 because there are very few observations in these classes; so I do not expect this model to do better on the penalty error than the baseline method. 
-	I fixed this by researching into the **_rpart()_** function and found it allows us to specify a parameter called **loss**. This is the penalty matrix I want to use when building the model. With this, I probably expect the rebuilt model to have a lower accuracy but with a lower penalty error. 
-	Thus, with this new model; the accuracy is **64.7%** (lower than baseline method) but penalty error is significantly lower with an error of 0.638. 
-	According to this new model’s penalty matrix, some of the worst types of errors are to predict bucket 1 when the actual cost bucket is higher. Therefore, **the model with the penalty matrix predicted bucket 1 less frequently (lower penalty error)**. 

## Results
### Insights
-	**Substantial improvement** over the baseline 
-	**Doubled accuracy** over baseline in some cases
-	Smaller accuracy improvement on **bucket 5**, but **much lower penalty**. 


### Analytics Impact 
-	Substantial improvement in ability to identify patients who need more attention. 
-	Because the CART model is generally more interpretable, physicians and medical experts were able to improve the model by identifying new variables and refining existing variables. 
-	Use of machine learning methods (classification trees) provided an edge over old methods. 
