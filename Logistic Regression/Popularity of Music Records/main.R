songs <-  read.csv("songs.csv")
str(songs)

#Playing around with Data before getting to the serious fun bit of creating a model
#Looking at observations from year 2010
table(songs$year)

#Michael Jackson songs in dataset
#Structure of dataframe has 1032 different values of variable "artistname"
MichaelJackson <- subset(songs, artistname=="Michael Jackson")
str(MichaelJackson)
nrow(MichaelJackson)
#or
table(songs$artistname == "Michael Jackson")
#18 songs Michael Jackson songs

#Songs that made it into top 10 
MichaelJackson[c("songtitle","Top10")]

#Song in the list that has the highest tempo beat
highest_tempo <-  which.max(songs$tempo)
songs$songtitle[highest_tempo]

#Creating Prediction Model 
SongsTrain = subset(songs, year<= 2009)
#Removing factor variables
nonvars <-  c('years','songtitle','artistname','songID','artistID')

SongsTrain = SongsTrain[, !(names(SongsTrain) %in% nonvars)]
SongsTest = subset(songs, year == 2010)
#Removing factor variables
SongsTest = SongsTest[, !(names(SongsTest) %in% nonvars)]
str(SongsTrain)
nrow(SongsTrain)

#Building logistic regression model to predict binary variable "Top10"
SongsLog1 = glm(Top10 ~., data=SongsTrain, family=binomial)
summary(SongsLog1)

#Correlation between variables "loudness" and "energy"
cor(SongsTrain$loudness,SongsTrain$energy)
#Omitting "loudness" variable in my next model
#Subtracting loudness variable; you can't do the same below with non-numeric variables
SongsLog2 = glm(Top10~.-loudness, data =SongsTrain, family=binomial)
str(SongsLog2)
#Coefficient of energy is positive now, leading to high energy songs to be more popular


#Subtracking energy variable (numeric variable)
SongsLog3 = glm(Top10 ~.- energy, data=SongsTrain, family = binomial)
summary(SongsLog3)


#Validating my model 

#Computing the accuracy as a number between 0 and 1; I want to find the accuracy of my model on test set
PredTest = predict(SongsLog3, newdata = SongsTest)
table(SongsTest$Top10,PredTest >=0.45)
accuracy = (314+4)/(314+55+4)

#Baseline model 
table(SongsTest$Top10)
accuracy_baseline = 314/(314+59)

#Finding the amount of songs predicted to be a top10 hit in 2010 using my latest model 
table(SongsTest$Top10,PredTest >=0.40)



















