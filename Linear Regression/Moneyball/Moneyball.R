baseball = read.csv("baseball.csv")
str(baseball)

#Including data from years until 2002, create new dataframe
moneyball = subset(baseball, Year < 2002)
str(moneyball)

#Precicting wins using difference between RS and RA
#Create new variable
moneyball$RD = moneyball$RS - moneyball$RA
str(moneyball)
#Observe new variable at end of dataframe structure

#Visually check if there is linear relationship between RD and Wins
plot(moneyball$RD, moneyball$W)

#Creating linear regression model 
WinsReg = lm(W ~ RD, data = moneyball)
summary(WinsReg)

#Baseball team scores 713 runs, and allows 614 runs
#How many games do we expect them to win using above model 
W = 80.88 + 0.1058*(RD)
#Run difference = 99
W = 80.88 + 0.1058*99 = 91


#Predicting Runs 
#Use linear regression to verify which baseball stats are more important to predict runs?
str(moneyball)
#Create linear regression equation to predict runs scored
RunsReg = lm(RS ~ OBP + SLG + BA, data = moneyball)
summary(RunsReg)

#Remove BA (least significant variable)
RunsReg = lm(RS ~ OBP +SLG, data = moneyball)
summary(RunsReg)
#Using above model, calculate runs team will score based on 
#baseball team's OBP = 0.311 and SLG = 0.405
#Runs = -804.63 + 2737.77*(0.311) + 1584.91*(0.405)
#Runs = 689

#Create a rank vector of 10 teams in World Series)
teamRank = c(1,2,3,3,4,4,4,4,5,5)
#Create a vector that has wins of each team in order of rank
wins2012 = c(94,88,95,88,93,94,98,97,93,94)
wins2013 = c(97,97,92,93,92,96,94,96,92,90)
#Find correlation between teamRank and wins2012 & wins2013
cor(teamRank,wins2012)
cor(teamRank,wins2013)
#Correlation is positive and negative
#This means there does not seem to be a pattern between regular season wins
#and winning the playoffs.










































