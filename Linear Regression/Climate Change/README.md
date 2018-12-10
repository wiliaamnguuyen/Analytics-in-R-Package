# CLIMATE CHANGE

## INTRODUCTION
There have been many studies documenting that the average global temperature has been increasing over the last century. The consequences of a continued rise in global temperature will be dire. Rising sea levels and an increased frequency of extreme weather events will affect billions of people.
In this dataset problem, I studied the relationship between average global temperature and several other factors.
The file climate_change.csv contains climate data from May 1983 to December 2008. The available variables include:
- **Year**: the observation year.
-	**Month**: the observation month.
-	**Temp**: the difference in degrees Celsius between the average global temperature in that period and a reference value. This data comes from the Climatic Research Unit at the University of East Anglia.
-	**CO2, N2O, CH4, CFC.11, CFC.12**: atmospheric concentrations of carbon dioxide (CO2), nitrous oxide (N2O), methane  (CH4), trichlorofluoromethane (CCl3F; commonly referred to as CFC-11) and dichlorodifluoromethane (CCl2F2; commonly referred to as CFC-12), respectively. This data comes from the ESRL/NOAA Global Monitoring Division.
-	**CO2, N2O and CH4 are expressed in ppmv** (parts per million by volume -- i.e., 397 ppmv of CO2 means that CO2 constitutes 397 millionths of the total volume of the atmosphere)
-	**CFC.11 and CFC.12 are expressed in ppbv** (parts per billion by volume). 
-	**Aerosols**: the mean stratospheric aerosol optical depth at 550 nm. This variable is linked to volcanoes, as volcanic eruptions result in new particles being added to the atmosphere, which affect how much of the sun's energy is reflected back into space. This data is from the Godard Institute for Space Studies at NASA.
-	**TSI**: the total solar irradiance (TSI) in W/m2 (the rate at which the sun's energy is deposited per unit area). Due to sunspots and other solar phenomena, the amount of energy that is given off by the sun varies substantially with time. This data is from the SOLARIS-HEPPA project website.
-	**MEI**: multivariate El Nino Southern Oscillation index (MEI), a measure of the strength of the El Nino/La Nina-Southern Oscillation (a weather effect in the Pacific Ocean that affects global temperatures). This data comes from the ESRL/NOAA Physical Sciences Division.

## CREATING OUR FIRST MODEL
I was interested in how changes in the above variables affect future temperature (thus climate change), as well as how well these variables explain (link well) with temperature changes so far. 

### Notes for beginners looking through my code:
- A training set refers to the data that will be used to build the model (the data we given to the lm() function)
    -	Testing set refers to the data I use to test our predictive ability with the above model 
    - When looking at significant variables, I will always look at p-values below 0.05

## UNDERSTANDING THE MODEL USING INTUITION ##

Current specific opinion is that nitrous oxide and CFC-11 are greenhouse gases: 
gases that can trap heat from the sun and contribute to the heating of the Earth. 

However, the regression coefficients of both the N20 and CFC-11 variables are *negative*, 
indicating that increasing atmospheric concentrations of either of these two compounds is associated with lower global temperatures. 

**_My intuition_** 
- The simplest correct explanation for this apparent contradiction is that all the gas concentration variables reflect human development – N20 and CFC.11 are correlated with other variables in the data set. 
    -	The linear correlation of N20 and CFC.11 with other variables in the data set is quite large. 
    - The warming effect of nitrous oxide and CFC-11 are well scientifically documented
    - Our regression analysis is insufficient to disprove it

### Important Information ###
- Computing correlations between all variables in the training set; 
absolute correlation greater than 0.7 shows highly correlated variables. 
    - Correlation coefficients are always values between -1 and 1, where -1 shows a perfect, linear negative correlation, and 1 shows a perfect, linear positive correlation. 
    - A correlation coefficient of zero, or very close to zero, shows no meaningful relationship between variables. 
    - These numbers are rarely seen, as there are very few perfectly linear relationships. 
    - Instead, numbers approaching these values are used to demonstrate strength of a relationship; for example, 0.92 or -0.97 would show, respectively, a very strong positive and negative correlation. 
    - As with all statistics that demonstrate correlation, this does not prove causation.
    -	In order to calculate correlations at once rather individually; use cor() function
 ```
 cor(training_set)
 ```

## SIMPLIFYING THE MODEL ##
Given correlations are so high, I focused on the N20 variable and build a model with only **MEI, TSI, Aerosols and N20** as independent variables using the training set to build the model.

The reason why I don’t like highly correlated variables is due to **_multicollinearity_**, which refers to a situation in which two or more explanatory variables in a multiple regression model are highly linearly related. We have perfect multicollinearity if, for example as in the equation above, the correlation between two independent variables is equal to 1 or −1.
New model observations: 
-	We observe the coefficient sign of N2O has flipped. 
-	The model R2 is 0.7261 compared to 0.7509 previously.
-	This behavior is typical when building a model where many of the independent variables are highly correlated with each other. 
-	In this problem, many variables (CO2, CH4, N2O, CFC.11 and CFC.12) are highly correlated, since they are all driven by human industrial development.

## AUTOMATICALLY BUILDING THE MODEL ##
RStudio provides a function step that will automate the process of trying different combinations of variables to find a good compromise of model simplicity and R2. 
- The **step function** has one argument, the name of the initial model:
    -	Pro: It returns a simplified model. 
    -	Con: The step function does not address the collinearity of the variable, except that adding highly correlated variables will not improve the R2 significantly. Consequently, step function will not necessarily produce a very interpretable model – just a model that has balanced quality and simplicity for a particular weighting of quality and simplicity. 

## TESTING ON UNSEEN DATA ##
I fitted linear regression to the training very well, but it is important to see if the model quality hold when applied to unseen data.

Using the model produced from step function; I used the predict function to calculate temperature predictions for testing data set. Observing it’s R2:
>	R2 = 1 – (SSE/SST)



