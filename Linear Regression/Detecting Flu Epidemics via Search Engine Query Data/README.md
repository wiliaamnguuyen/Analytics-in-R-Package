# Detecting Flu Epidemics via Search Engine Query Data #

## INTRODUCTION ##
- Flu epidemics constitute a major public health concern causing respiratory illnesses, 
hospitalizations, and deaths. 
    - According to the **National Vital Statistics Reports** published in October 2012, 
influenza ranked as the eighth leading cause of death in 2011 in the United States. 
    - Each year, 250,000 to 500,000 deaths are attributed to influenza related diseases throughout the world.
    - The U.S. Centres for Disease Control and Prevention (CDC) and the European Influenza Surveillance Scheme (EISS) **_detect 
    influenza activity through virologic and clinical data, including Influenza-like Illness (ILI) physician visits_**. 
    - Reporting national and regional data, however, are published with a **1-2 week lag.**
    
The Google Flu Trends project was initiated to see if faster reporting can be made 
possible by considering flu-related online search queries -- data that is available **almost immediately**.

## UNDERSTANDING THE DATA	##
I estimated **influenza-like illness (ILI) activity** using Google web search logs. 

Fortunately, I can easily access this data online: 
- **ILI Data** - The CDC publishes on its website the official regional and state-level _percentage of patient visits to healthcare providers for ILI purposes on a weekly basis_
- **Google Search Queries** - Google Trends allows public retrieval of _weekly counts for every query searched by users around the world_. 
For each location, the counts are normalized by dividing the count for _each query in a particular week by the total number of online search queries submitted in that location during the week_. 
Then, the values are adjusted to be between 0 and 1.
    - **“Week”** – The range of dates represented by this observation, in year/month/day format. 
    - **“ILI”** – The column lists the **_percentage of ILI-related physician visits for the corresponding week._** 
    - **“Queries”** – This column lists the **_fraction of queries that are ILI-related for the corresponding week_**, adjusted to be between 0 and 1 _(high values correspond to more ILI-related search queries)._

- I wanted to find out which week had the **_highest percentage of ILI-related physician visits_**, the method I used:
    - You can limit the observations of the data-frame to obtain the **maximum ILI value** with a **subset() function**. 
    The arguments for the subset function are to _slice a section of the data-frame_ and the second argument is the condition of _how to slice this data-frame_.
```
ILI == max(ILI)
```

OR

```
x = which.max(FluTrain$ILI)
```
To find the row number corresponding to the observation with the maximum value of ILI. 
Then, output the corresponding week using:
```
FluTrain$Week[303]
```
- I also wanted to find out which week corresponded to the highest percentage of ILI-related query fraction, to do this:
    -	I limited data-frame observations that obtain the maximum ILI value with: 
    
```
subset(FluTrain, Queries == max(Queries))
```

Alternatively, you can use: 
    
```
x = which.max(FluTrain$Queries)
```

To find the row number corresponding to the observation with the maximum values of Queries, which is 303. 
Then find the output corresponding week using:

```
FluTrain$Week[x]
```


## Plotting Histogram of the dependent variable, ILI ##
- Observations shows:
    - Visually, the data is skew right. 
    - Observations shows most of the ILI values are small, with a relatively small numbers of much large values (in statistics, this sort of data is called **“skew right”).**
    - **When handling skewed dependent variable, it is useful to predict the **_logarithm of the dependent variable_** (what you’re trying to predict) instead of just the dependent variable itself.**
    -	Why? This prevents the **small number of large/small observations from having an influence on the sum of squared errors of predictive models (SSE).**
    
-	There is a positive, linear relationship between log(ILI) and Queries. 
    - Thus, a linear regression model could be a good modelling choice. 


## PERFORMANCE ON THE TEST SET ## 
- The test file provides the 2012 weekly data of:
    -	the **ILI-Related Search Queries** and,
    -	the respectively **observed weekly percentage of ILI-related physician visits.**
    
- To calculate the **Root Means Squared Error (RMSE):**
    -	First compute the SSE then divide the number of observations and taking the square root. 

## TRAINING A TIME SERIES MODEL ## 
In this model, I implemented a simple time series model with a single lag term.  

A “time series” data set is defined **_as the observations in this dataset are consecutive weekly measurements of the dependent and independent variables_**. 

- **I like to improve statistical models by predicting the current value of the dependent variable using the value of the dependent variable from earlier weeks.**
- In our models, this means l predicted the **_ILI variable in the current week using values of the ILI variable from previous weeks_**. 
- General outline below:
    -	Decide the amount of time to lag the observations since the ILI variable is reported with a 1/2 week lag, 
    a decision maker cannot rely on the previous week’s ILI value to predict the current week’s value. 
    -	Instead, the decision maker will only have data from **2 or more weeks ago**. 
    - The variable I built ILILag2 that contains ILI value from 2 weeks before the current observation. 
      - I used the **“zoo” package** which provides several helpful methods for time series models.
- The training set contains all observations from 2004-2011 and the testing set contains all observations from 2012. 

