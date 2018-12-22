# Popularity of Music Records

## Motivation

The music industry has a well-developed market with a global annual revenue around $15 billion. 

The recording industry is highly competitive and is dominated by three big production companies which make up nearly 82% of the total annual album sales. 

Artists are at the core of the music industry and record labels provide them with the necessary resources to sell their music on a large scale. 

A record label incurs numerous costs (studio recording, marketing, distribution, and touring) in exchange for a percentage of the profits from album sales, singles and concert tickets.

Unfortunately, the success of an artist's release is highly uncertain: a single may be extremely popular, resulting in widespread radio play and digital downloads, while another single may turn out quite unpopular, and therefore unprofitable. 

Knowing the competitive nature of the recording industry, record labels face the fundamental decision problem of which musical releases to support to maximize their financial success. 

**_How can I use analytics to predict the popularity of a song?_** 

I am motivated to challenge myself to predict whether a song will reach a spot in the Top 10 of the Billboard Hot 100 Chart.

## Objectives

Taking an analytics approach, I aim to use information about a song's properties to predict its popularity. 

The dataset songs.csv consists of all songs which made it to the Top 10 of the **Billboard Hot 100 Chart** from 1990-2010 plus a sample of additional songs that didn't make the Top 10. 

This data comes from three sources: [Wikipedia](https://en.wikipedia.org/wiki/Billboard_Hot_100), [Billboard.com](https://www.billboard.com/), and [EchoNest](http://the.echonest.com/).

## Variables 

The variables included in the dataset either describe the artist or the song, or they are associated with the following song attributes: time signature, loudness, key, pitch, tempo, and timbre.

Here's a detailed description of the variables:
-	**year** = the year the song was released
-	**songtitle** = the title of the song
-	**artistname** = the name of the artist of the song
-	**songID and artistID** = identifying variables for the song and artist
-	**timesignature and timesignature_confidence** = a variable estimating the time signature of the song, and the confidence in the estimate
-	**loudness** = a continuous variable indicating the average amplitude of the audio in decibels
-	**tempo and tempo_confidence** = a variable indicating the estimated beats per minute of the song, and the confidence in the estimate
-	**key and key_confidence** = a variable with twelve levels indicating the estimated key of the song (C, C#, . . ., B), and the confidence in the estimate
-	**energy** = a variable that represents the overall acoustic energy of the song, using a mix of features such as loudness
-	**pitch** = a continuous variable that indicates the pitch of the song
-	**timbre_0_min**, timbre_0_max, timbre_1_min, timbre_1_max, . . . , timbre_11_min, and timbre_11_max = variables that indicate the minimum/maximum values over all segments for each of the twelve values in the timbre vector (resulting in 24 continuous variables)
-	**Top10** = a binary variable indicating whether or not the song made it to the Top 10 of the Billboard Hot 100 Chart (1 if it was in the top 10, and 0 if it was not)

# Approach and Analysis
 I wish to predict whether a song will make it to the Top 10:
-	Using the subset function to split the data into a training set “SongsTrain” consisting of all the observations up to and including 2009 song releases 
-	Testing set “SongsTest” consists of the 2010 song releases

In this problem, my outcome is **“Top10”** – I’m trying to predict whether or a song will make it to the Top 10 of the Billboard Hot 100 Chart. 
Since the outcome variable is **_binary_**, I will build a logistic regression model. 
I start by using all song attributes as my independent variables, naming the model, **Model1**. 
-	Using only the variables in my dataset that describe the numerical attributes of the song in my logistic regression model so I won’t use the variables “year”, “songtitle”, “artistname”, “songID” or “artistID”.
-	In order to build a model excluding these factor variables without writing all of the rest independent variables since this is inefficient:
    -	Defining a vector of variable, where this vector contains the variables, I won’t use in my model 
```r 
nonvars = c(“years”,”songtitle”,”artistname”,”songID”,”artistID”)
```
-	To remove above variables from my training and testing set, I used the following commands:
```r
> SongsTrain = SongsTrain[,!(names(SongsTrain) %in% nonvars)]
> SongsTest = SongsTest[,!(names(SongsTest) %in% nonvars)]
```

-	Observation of model shows confidence variables **_(timesignature_confidence, key_confidence, and tempo_confidence) has positive coefficient estimates; meaning higher confidence leads to a higher predictability of a Top 10 hit. 
    -	Furthermore, if confidence is low for these variables, then the song is more likely to be more complex. 
    -	Since the coefficient values for these confidence variables are positive, lower confidence leads to a lower predictability of a song being a hit; thus mainstream listeners to prefer less complex songs. 
        
-	Looking at the correlation between the variables “loudness” and “energy”, they are highly correlated and thus my logistic regression model suffers from multicollinearity.
    -	To avoid this issue, I will omit one of these variables and rerun the logistic regression.
    -	In my second logistic regression model, I will omit **”loudness’**
    -	In this model, the coefficient of “energy” is positive; this model suggests that songs with high energy tend to be more popular.
    -	In my third logistic regression model, I will instead omit **”energy”**
        -	I can see the loudness has a positive coefficient estimate, meaning that our model predicts that songs with heavier instrumentation tend to be more popular

## Validating Our Model 
Computing the accuracy of my logistic regression model by:
-	Finding the predictions on the test set using the model 
-	Create a confusion matrix with a threshold of 0.45 by using the table() command. 
-	Then calculating the accuracy using the confusion matrix table by calculating what the sum of what I predicted and turned out right and divide it by the total observations. 

Computing the baseline model so I can see the accuracy of this model be on the test set:
-	Given the difficulty of guessing which song is going to be a hit, an easier model would be to pick the most frequent outcome for all songs (a song is not a Top 10 hit)
    -	The accuracy of the baseline model is done through tabling the outcome variable in the test set. 
    -	The baseline model would get 314 observations correct, and 59 wrong; an accuracy rate of 84%. 
    -	Therefore, **_my third model gives me small improvement over the baseline model; I want to investigate the impact of this improvement._**

## Company Goals
A production company is interested in investing in songs that are highly likely to make it to the Top10. 

The company’s objective is **_to minimize its risk of financial losses attributed to investing in songs that end up unpopular._**:

### Approach

A competitive edge can therefore be achieved if I can provide the production company a list of songs that are highly likely to end up in the Top 10. I note that the baseline model doesn’t prove useful, as it simply doesn’t label any song as a hit; I want to approach this by finding out how many songs does my third model predict as Top 10 hits in 2010 (test set), using a threshold of 0.45. 
-	I have 19 true positives (Top 10 hits that I predicted correctly) and 5 false positives (songs that I predict will be in Top 10 hits, but end not being so).
