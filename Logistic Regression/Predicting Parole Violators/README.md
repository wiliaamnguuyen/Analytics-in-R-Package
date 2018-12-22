# Predicting Loan Repayment
## Motivation

In the lending industry, investors provide loans to borrowers in exchange for the promise of repayment with interest. 

If the borrower repays the loan, then the lender profits from the interest. 

However, if the borrower is unable to repay the loan, then the lender loses money. 

Therefore, lenders face the problem of predicting the risk of a borrower being unable to repay a loan.

To address this problem, I will use publicly available data from LendingClub.com, a website that connects borrowers and investors over the Internet. 

This dataset represents 9,578 3-year loans that were funded through the [LendingClub.com](https://www.lendingclub.com/info/download-data.action) platform between May 2007 and February 2010. 

The binary dependent variable **not.fully.paid** indicates that the loan was not paid back in full (the borrower either defaulted or the loan was "charged off," meaning the borrower was deemed unlikely to ever pay it back).

To predict this dependent variable, I will use the following independent variables available to the investor when deciding whether to fund a loan:
-	**credit.policy**: 1 if the customer meets the credit underwriting criteria of LendingClub.com, and 0 otherwise.
-	**purpose** The purpose of the loan (takes values "credit_card", "debt_consolidation", "educational", "major_purchase", "small_business", and "all_other").
-	**int.rate**: The interest rate of the loan, as a proportion (a rate of 11% would be stored as 0.11). Borrowers judged by LendingClub.com to be more risky are assigned higher interest rates.
-	**installment**: The monthly installments ($) owed by the borrower if the loan is funded.
-	**log.annual.inc**: The natural log of the self-reported annual income of the borrower.
-	**dti**: The debt-to-income ratio of the borrower (amount of debt divided by annual income).
-	**fico**: The FICO credit score of the borrower.
-	**days.with.cr.line**: The number of days the borrower has had a credit line.
-	**revol.bal**: The borrower's revolving balance (amount unpaid at the end of the credit card billing cycle).
-	**revol.util**: The borrower's revolving line utilization rate (the amount of the credit line used relative to total credit available).
-	**inq.last.6mths**: The borrower's number of inquiries by creditors in the last 6 months.
-	**delinq.2yrs**: The number of times the borrower had been 30+ days past due on a payment in the past 2 years.
-	**pub.rec**: The borrower's number of derogatory public records (bankruptcy filings, tax liens, or judgments).

# Analysis

## Preparing the dataset

The reason why I filled in the missing values for these variables instead of removing observations with missing data is because I want to **_predict risk for all borrowers, instead of just the ones with all data reported._**
-	I used the subset() function to build a data frame with the observations missing at least one value 
-	To test whether a variable, for example **pub.rec** is missing a value, I used is.na(pub.rec).

Imputation predicts missing values for a given observation using the variable values that are reported; I called the imputation on a data frame with the dependent variable **not.fully.paid** removed, so I predicted the missing values using only other independent variables:
-	The process of multiple imputation to handle missing values is predicting missing variable values using the available independent variables for each observation. 

## Prediction Methods

Splitting into a training and testing set using the sample.split() function to select 70% of the observations for the training set (the dependent variable for sample.split() is not.fully.paid). 

Created a logistic regression model using the training set; it is important to note that a positive coefficient (meaning that higher values of the variable lead to an increased risk of defaulting) and some have a negative coefficient (meaning that higher values of the variable lead to a decreased risk of defaulting). 

## Case Situation

Consider two loan applications, which are identical other than the fact that the borrower in Application A has FICO credit score 700 while the borrower in Application B has FICO credit score 710. 
-	Let Logit(A) be the log odds of loan A not being paid back in full, according to my logistic regression model; I want to find the value of Logit(A) – Logit(B)
-	As Application A is identical to Application B other than having a FICO score 10 lower, it’s predicted log odds differ by -0.009317*(-10) = 0.09 from the predicted log odds of Application B. 

## Predicting Test Set

I predicted the probability of the test set loans not being paid back in full; and stored these predicted probabilities in a variable to add into my test set. 

I then computed the confusion matrix using a threshold of 0.5.
-	The confusion matrix shows 2406 predictions are correct 
-	While table(test$not.fully.paid) shows 2413 predictions would be correct in the baseline model of guessing every loan be paid back in full (accuracy = 2413/2873 = 0.84); this shows my model did not improve significantly from the baseline model. 

## Effective Smart Baseline
I built a logistic regression model that has an AUC significantly higher than the AUC of 0.5. **Noting that an AUC close to 0.5 (worthless baseline) means model is not very good.**

However, LendingClub.com assigns the interest rate to a loan based on their estimate of that loan’s risk. This variable, int.rate, is an independent variable in the dataset. I investigated using the loan’s interest rate as a “smart baseline” to order the loans according to risk. 

Using the training set, I built a bivariate logistic regression model i.e. _a model with a single independent variable_ that predicts the dependent variable **not.fully.paid** using only the variable **int.rate**. 
-	The variable **int.rate** is highly significant in the bivariate model but isn’t significant at the 0.05 level in the model trained with all the independent variables
-	The reason for this is because **int.rate** is correlated with other risk-related variables, and therefore does not incrementally improve the model when those variables are included. 
    -	Decreased significance between a bivariate and multivariate model is typically due to **correlation**. 
```r
from cor(train$int.rate,train$fico)
```

- I can see the interest rate is moderately well correlated with a borrower’s credit score. 
-	Calculating the AUC of the test set: 
    -	Use the ROCR library package
    -	Use the prediction() function on the test set predictions and the vector of the dependent variable. 
    -	Calculating the performance of these prediction the test set – AUC 

## Simple Investment Strategy
To evaluate the quality of an investment strategy, I want to compute this profit for each loan in the test set. For this variable, I assume a $1 investment (aka c=1); to create the variable, I first assign the profit for a full paid loan, exp(rt)-1, to every observation and I then replace this value with a -1 in the cases where the loan was not paid in full. 
-	The loans in my dataset are 3-year loans, meaning t=3 in my calculations
```r
test$profit = exp(test$int.rate*3)-1
test$profit[test$not.fully.paid ==1] = -1
```
-	The maximum profit of a $10 investment in any loan in testing set is:
    -	88 cents for every dollar invested in any loan. 
    -	Thus, a maximum profit of a $10 investments is 10 times as large or $8.88

## An Investment Strategy Based on Risk

I reckon a simple investment strategy is equally investing in all the loans would yield a profit $20.94 for a $100 investment. 

However, this simple investment strategy does not leverage the prediction model I built. 

From what I understand from reading on Google, **_investors seek loans that balance reward with risk, in that they simultaneously have high interest rates and a low risk of not being paid back._**

To meet this objective, **_I analysed an investment strategy in which the investor only purchases loans with a high interest rate (a rate of at least 15%), but amongst these loans selects the ones with the lowest predicted risk of not being paid back in full._** 

I will model an investor who invests $1 in each of the most promising 100 loans. 
-	Using the subset() function, I built a subset data frame called **_highInterest_** consisting of the test set loans with an interest rate of 15%
-	Upon further analysis, I see that for a $1 investment in one of these high-interest loans; a mean profit of $0.22 is given. _However, would these loans be paid back in full to obtain this profit?_

```r
table(highInterest$not.fully.paid)
110/437 loans were not paid back in full – proportion of 0.25
```

-	What’s important that I would love to know is to determine the **_100th smallest predicted probability of not paying in full_**, I did this by by sorting the predicted risk in increasing order and selecting the 100th element of this sorted list. 

```r
cutoff = sort(highInterest$predicted.risk,decreasing = FALSE)[100]
```

- Using the subset() function to build a data frame consisting of the high-interest loans with **_predicted risk not exceeding the cutoff I just computed_**.

```r
selectedLoans = subset(highInterest,”predicted.risk”<=cutoff)
```

- The important question I want to investigate is how many of these 100 selected loans were not back in full. 

```r
table(selectedLoans$not.fully.paid)
```

## SUMMARY
Although, the logistic regression models I developed did not have large AUC values, I can see they provided the edge to improve the profitability of an investment portfolio. 

I used analytics to select a subset of the high-interest loans that were paid back at a slightly lower rate than average, resulting in a significant increase in the profit from a random investor’s $100 investment. 

**Note**: Through this analysis, I assumed that the loans I invest in will perform in _exactly_ the same way as the loans I used to train my logistic regression model; even though my training set covers a relatively short period of time of 3 years. 

**_If there is an economic shock like financial crisis, default rates might be significantly higher than those observed in the training set of my dataset; and thus, end up losing money instead of profiting. I understand that investors must pay a careful attention to such risk when making investment decisions._**

