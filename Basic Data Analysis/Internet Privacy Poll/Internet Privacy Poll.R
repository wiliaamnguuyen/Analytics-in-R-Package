poll = read.csv("AnonymityPoll.csv")

#Find how many people participated in poll 
nrow(poll)
str(poll)

#How many had a smartphone? How many didn't? How many didn't respond at all?
table(poll$Smartphone)
summary(poll$Smartphone)


#Use Table() function on two variables to see how they're related
# Don't forget to add poll$ before each variable name 

#Which states are in Midwest census region?
table(poll$State,poll$Region)
MidwestInterviewees = subset(poll, Region == "Midwest")
table(MidwestInterviewees)

#Number of interviewees from South region
SouthInterviewees = subset(poll,Region == "South")
table(SouthInterviewees)


#Find data frame called "limited"
limited = subset(poll, Internet.Use ==1 | Smartphone ==1)
nrow(limited)

#Find the variables that have missing values 
summary(limited)

#Average number of pieces of personal information on internet
mean(limited$Info.On.Internet)

#Find the reported value for 0 for Info.On.Internet
table(limited$Info.On.Internet)
























