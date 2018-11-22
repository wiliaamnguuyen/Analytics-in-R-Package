#Malnutrition has been rising at an alarming rate
#Obesity increases
#The trend continues
#More than 35$ of American Adults are obese
#Worldwide trend 
#Increase people's risk to health problems 
#Good nutrition is good for lifestyle 
#Read USDA Foot Database in R

USDA = read.csv("USDA.csv")

#Learn about our dataset, look into structure
str(USDA)
summary(USDA)

#maximum sodium levels is 38000mg, but daily limit is 2300mg
#find which food has max level of sodium 
which.max(USDA$Sodium)
#Above gives index of food of highest sodium
names(USDA)
#Above gives variable names storeed in USDA


#Getting name of index 265, use description vector 
USDA$Description[265]
#Table Salt results. Who would eat table salt?
#Find out which foods contain more 10000mg Sodium


#Create new dataframe
HighSodium = subset(USDA, Sodium>10000)
#Find how many foods exist in new data frame/observations frame has
#Use nrow function to compute number of rows in frame High Sodium
nrow(HighSodium)
#Output names by looking at description vector
HighSodium$Description 

#Find index of caviar in dataset and feed it into vector sodium
#Find index by tracking down word caviar in text description
#Use Match Function
match("CAVIAR",USDA$Description)
USDA$Sodium[4154]
#Finding sodium level of caviar above quicker 
USDA$Sodium[match("CAVIAR", USDA$Description)]

#Is sodium levels of CAVIAR big? Compare its level to 
# mean and the standard deviation, use summary function
summary(USDA$Sodium)
#Summary function doesn't show standard deviation value
sd(USDA$Sodium)
#Obtained unavailable, we forgot to remove non available entries
# for our statistical measure
#Tell R to remove it 
sd(USDA$Sodium, na.rm=TRUE)

#Standard Deviation + Mean < Sodium Levels of Caviar
# Conclusion Caviar has high levels of sodium compared to
#most foods in our dataset



#CREATING PLOTS IN R

#Visualisation for initial data exploration shows
# us discern relationships, outliers, and patterns

#ScatterPlot
#Foods lower in fat, have high protein
#Labelling by adding more arguments to plot function
plot(USDA$Protein, USDA$TotalFat, xlab = "Protein", ylab = "Fat", main = "Protein vs Fat", col= "red")


#Histogram. Function takes one variable as an input, y axis shows the frequencies 
hist(USDA$VitaminC, xlab="Vitamin C (mg)", main = "Histogram of Vitamin C Levels")
#Maximum food with Vitamin C levels is 200mg, most of 6000 of foods has less than 200mg of Vitamin C

#Looking at Vitamin C levels 0-100mg. 
hist(USDA$VitaminC, xlab="Vitamin C (mg)", main = "Histogram of Vitamin C Levels", xlim = c(0,100))

#This doesn't give any information. Break up into smaller interval 
hist(USDA$VitaminC, xlab="Vitamin C (mg)", main = "Histogram of Vitamin C Levels", xlim = c(0,100), breaks = 100)

#To obtain 1mg cells, divide into 2000 sections
hist(USDA$VitaminC, xlab="Vitamin C (mg)", main = "Histogram of Vitamin C Levels", xlim = c(0,100), breaks = 2000)
#More than 5000 foods contain less than 1mg of Vitamin C




#BoxPlots to visualise data as well
#Takes one input as single vector
boxplot(USDA$Sugar, main = "Boxplot of Sugar Levels", ylab = "Sugar (g)")
#Tip, if you're not sure which axes to plot, plot it first then add in arguments to label
#Shows average(sugar) across dataset is low around 5grams
#Shows a lot of outliers that lots of sugar




#ADDING VARIABLES
#Add new variables to data frame 


#Check if first food has higher amount of sodium compared to mean
# Don't forget to remove unavailable entries
USDA$Sodium[1] > mean(USDA$Sodium, na.rm = TRUE)
USDA$Sodium[50] > mean(USDA$Sodium, na.rm = TRUE)
#You don't want to display 7000 values, save it to a variable 
# and look at its structure of HighSodium Vector
HighSodium = USDA$Sodium > mean(USDA$Sodium, na.rm = TRUE)
str(HighSodium)

#We want values 1 and 0. True = 1, and False = 0 
#Change data type of HighSodium to numeric rather than logi (True,FALSE)
HighSodium = as.numeric(USDA$Sodium > mean(USDA$Sodium, na.rm = TRUE))
str(HighSodium)
#Turned HighSodium into numerical vector with 1 and 0 


#Vector variable HighSodium needs to be added into dataframe
#Use dollar notation to associate it to USDA dataframe
USDA$HighSodium = as.numeric(USDA$Sodium > mean(USDA$Sodium, na.rm = TRUE))
str(USDA)

#Adding more variables for fun 
USDA$HighProtein = as.numeric(USDA$Protein > mean(USDA$Protein, na.rm = TRUE))
USDA$TotalFat = as.numeric(USDA$TotalFat > mean(USDA$TotalFat, na.rm=TRUE))
USDA$HighCarbs = as.numeric(USDA$Carbohydrate > mean(USDA$Carbohydrate, na.rm=TRUE))


#SUMMARY TABLES
#Understanding data and relationship between variables
#Using table and tapply functions
#Figure how many foods has high sodium levels > mean
#Look at HighSodium variable and count foods that have values 1
#Use Table Function and input HighSodium vector

table(USDA$HighSodium)
#4884 foods have lower sodium than average


#How many foods have both high sodium and fat? 
table(USDA$HighSodium, USDA$TotalFat)
# First row belongs to first input, which is HIGH SODIUM
# 3529 foods has low sodium and low fat


#Tapply function takes 3 arguments, groups 1st argument by 2nd argument, then applies 3
#Compute average amount of iron, sorted by high and low protein 
#First input is to analyse vector Iron
tapply(USDA$Iron, USDA$HighProtein, mean, na.rm = TRUE)
#Foods with low protein has average 2.555 mg of Iron in them 

#Maximum levels of Vitamin C in foods with high and low carbs?
#First input is vector Vitamin C to analyse VitaminC vector
tapply(USDA$VitaminC, USDA$Carbohydrate, max, na.rm=TRUE)
#Maximum Vitamin C levels which is 2400mg is present in high carbs


#Foods that have high carbs have generally high vitaminC?
tapply(USDA$VitaminC, USDA$Carbohydrate, summary, na.rm=TRUE)
#Shows mean value of Vitamin C (mg) in high carbs> mean vitamin(C) in low carbs

















































































































