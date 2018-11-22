CPS = read.csv("CPSData.csv")
summary(CPS)
str(CPS)

#Among the interviewees with a value in Industry variable, what is the common industry of employment? 
table(CPS$Industry)

#Finding state that has fewest interviewees
sort(table(CPS$State), decreasing = FALSE)

#Finding proportion of interviewees in United States
table(CPS$Citizenship)
123712 /131302


#Find which race that has at least 250 interviewees in CPS dataset of Hispanic ethnicity
table(CPS$Race,CPS$Hispanic)


#Which variable of CPS is missing based on reported value of the Region variable 
table(CPS$Region,is.na(CPS$Married))
table(CPS$Sex, is.na(CPS$Married))
table(CPS$Age, is.na(CPS$Married))
table(CPS$Citizenship,is.na(CPS$Married))
table(CPS$State, is.na(CPS$MetroAreaCode))


#Evaluate number of interviewees not living in Meto area, broken down by region 
table(CPS$Region,is.na(CPS$MetroArea))

#Find which metropolitan areas has highest proportion of hispanic ethnicity
sort(tapply(CPS$Hispanic,CPS$MetroArea,mean))






