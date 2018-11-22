IBM = read.csv("IBMStock.csv")
GE = read.csv("GEStock.csv")
ProcterGamble = read.csv("ProcterGambleStock.csv")
CocaCola = read.csv("CocaColaStock.csv")
Boeing = read.csv("BoeingStock.csv")

#Summary Statistics
#Convert Dates into a format R can understand
#Date variable is stored as a TYPE FACTOR. Convert to "Date" object
#First argument is variable we want to convert
#Second argument is format of Date Variable 
#Thus we overwrite the original date variable values with the output of this function
IBM$Date = as.Date(IBM$Date, "%m/%d/%y")
GE$Date = as.Date(GE$Date, "%m/%d/%y")
ProcterGamble$Date = as.Date(ProcterGamble$Date, "%m/%d/%y")
CocaCola$Date = as.Date(CocaCola$Date, "%m/%d/%y")
Boeing$Date = as.Date(Boeing$Date, "%m/%d/%y")

#Number of observations, earliest year in dataset, mean stock price
#Min stock price of GE, standard deviation of stock price in PG
str(IBM)
summary(IBM)
summary(GE)
sd(ProcterGamble$StockPrice)


#VISUALISING STOCK DYNAMICS
#Plot a line graph by adding argument, type = "l" for letter l for line. 
plot(CocaCola$Date, CocaCola$StockPrice, type="l")
#Adding colour to plot CocaCola 
plot(CocaCola$Date, CocaCola$StockPrice, type="l", col = "red")
#Adding line for ProcterGamble to visualise stock price on same graph
lines(ProcterGamble$Date,ProcterGamble$StockPrice, type = 'l', col = "blue")
#Which company stock dropped more in March 2000? Draw a line at certain date
abline(v=as.Date(c("2000-03-01")), lwd =2)


#VISUALISING STOCK DYNAMICS 1995-2005
#Plot CocaCola from 1995-2005, observations from 301 to 432
#ylim =c(0,210) makes yaxis range from 0-210
plot(CocaCola$Date[301:432],CocaCola$StockPrice[301:432], type = "l", col="red",ylim=c(0,210))
lines(ProcterGamble$Date[301:432], ProcterGamble$StockPrice[301:432], type = "l", col="blue", lty=2)
lines(IBM$Date[301:432],IBM$StockPrice[301:432], type="l", col="green",lty=3)
lines(GE$Date[301:432],GE$StockPrice[301:432],type='l',col="purple",lty=4)
lines(Boeing$Date[301:432],Boeing$StockPrice[301:432],type='l',col='black', lty = 5)


#Global Stock Market Crash in October 1997. Compare Sep 1997 to Nov 1997
#Which companies saw a decreasing trend in stock price?
abline(v=as.Date(c("1997-07-01")),lwd=2)
abline(v=as.Date(c("1997-11-01")),lwd=2)

#Which stock price seems to perform best in 2004-2005
abline(v=as.Date(c("2004-01-01")),lwd=2)
abline(v=as.Date(c("2005-12-01")),lwd=2)


#MONTHLY TRENDS
#See if stock tends to be high or lower during certain months
#Use tapply command to calculate mean stock price of IBM sorted by months
#Compare monthly averages to overall stock price
#Which months has IBM historically had higher stock price on average?
IBM$Months = months(IBM$Date)
tapply(IBM$StockPrice,IBM$Months, mean)
AvgIBM = mean(IBM$StockPrice)

#Monthly Stock Average Price for GE and CocaCola
GE$Months = months(IBM$Date)
tapply(GE$StockPrice,GE$Months, mean)
CocaCola$Months = months(CocaCola$Date)
tapply(CocaCola$StockPrice,CocaCola$Months,mean)

#Which months stock prices are lower? December
#Common trend between 5 companies
#With this, you can buy stock in certain months and sell it in others
#But be careful since a bad year could skew the average to show a trend that is not there












