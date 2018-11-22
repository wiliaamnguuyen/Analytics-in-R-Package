#Loading the Data
MVT = read.csv("mvtWeek1.csv")

#Rows of Observations
str(MVT)
nrow(MVT)

#Number of variables, str shows no.variables in first row
str(MVT)

#Maximum value of Variable ID
max(MVT$ID)
#Method 2
max = which.max(MVT$ID)
MVT$ID[max]

#Minimum Value of Variable "Beat"
min(MVT$Beat)
#Method 2
summary(MVT$Beat)

#Amount of observations valued TRUE in Arrest
summary(MVT$Arrest)

#Amount of observations have value ALLEY in LocationDescription
table(MVT$LocationDescription)

#Converting variable "Date" into Date object in R
#Find the median date in our dataset
DateConvert = as.Date(strptime(MVT$Date, "%m/%d/%y %H:%M"))
summary(DateConvert)

#Extracting Month and Day of Week and adding variables to frame MVT
MVT$Month = months(DateConvert)
MVT$Weekday = weekdays(DateConvert)
#Replacing old Date variable with DateConvert
MVT$Date = DateConvert
#Which month did fewest motor vehicle thefts?
table(MVT$Month)
#Which weekday have the most thefts?
table(MVT$Weekday)
#Which month has largest thefts for which an arrest was made?
table(MVT$Arrest,MVT$Month)



#VISUALISING CRIME TRENDS

#Histogram of variable Date
#Indicate the number of bars/breaks you want in histogram
hist(MVT$Date, breaks=100)


#Boxplot of variable Date sorted by Arrest
#Date sorted by Arrest, use formula argument
#Boxplot shows ARREST=TRUE skewed towards bottom of plot
#Meaning there were more crimes arrest made in first half time period
boxplot(MVT$Date ~ MVT$Arrest)

#Proportion of motor vehicles thefts in 2001 was an arrest made
table(MVT$Arrest, MVT$Year)



#Popular Crime Locations for Police to Allocate Resources
#To increase arrests for car theft, where should they focus efforts?
sort(table(MVT$LocationDescription))


#Create subset of data, taking observations of theft happened in one of these
#five locations
Top5 = subset(MVT,LocationDescription == "STREET" |
                LocationDescription == "PARKING LOT/GARAGE(NON.RESID.)" |
                LocationDescription == "ALLEY" | LocationDescription == "GAS STATION" |
                LocationDescription == "DRIVEWAY - RESIDENTIAL")
str(Top5)
#Method 2
TopLocations = c("STREET","PARKING LOT/GARAGE(NON.RESID.)","ALLEY","GAS STATION","DRIVEWAY - RESIDENTIAL")
Top5 = subset(MVT,LocationDescription %in%TopLocations)

#What day of most thefts happen at Gas Station? 
table(Top5$LocationDescription, Top5$Weekday)





































