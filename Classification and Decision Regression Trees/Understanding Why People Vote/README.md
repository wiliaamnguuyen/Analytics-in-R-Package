# Understanding Why People Vote
In August 2006 three researchers (Alan Gerber and Donald Green of Yale University, and Christopher Larimer of the University of Northern Iowa) carried out a large scale field experiment in Michigan, USA to test the hypothesis that one of the reasons people vote is social, or extrinsic, pressure. To quote the first paragraph of their [2008 research paper]( https://isps.yale.edu/sites/default/files/publication/2012/12/ISPS08-001.pdf)

> Among the most striking features of a democratic political system is the participation of millions of voters in elections. Why do large numbers of people vote, despite the fact that ... "the casting of a single vote is of no significance where there is a multitude of electors"? One hypothesis is adherence to social norms. Voting is widely regarded as a citizen duty, and citizens worry that others will think less of them if they fail to participate in elections. Voters' sense of civic duty has long been a leading explanation of vote turnout...

I will be demonstrating both logistic regression and classification trees to analyse the data these researchers collected. 

## The Data
The researchers grouped about 344,000 voters into different groups randomly - about 191,000 voters were a "control" group, and the rest were categorized into one of four "treatment" groups. These five groups correspond to five binary variables in the dataset.

1.	"Civic Duty" (variable **civicduty**) group members were sent a letter that simply said "DO YOUR CIVIC DUTY - VOTE!"
2.	"Hawthorne Effect" (variable **hawthorne**) group members were sent a letter that had the "Civic Duty" message plus the additional message "YOU ARE BEING STUDIED" and they were informed that their voting behavior would be examined by means of public records.
3.	"Self" (variable **self) ** group members received the "Civic Duty" message as well as the recent voting record of everyone in that household and a message stating that another message would be sent after the election with updated records.
4.	"Neighbors" (variable **neighbors**) group members were given the same message as that for the "Self" group, except the message not only had the household voting records but also that of neighbors - maximizing social pressure.
5.	"Control" (variable **control**) group members were not sent anything, and represented the typical voting situation.

Additional variables include **sex** (0 for male, 1 for female), **yob** (year of birth), and the dependent variable **voting** (1 if they voted, 0 otherwise).


## Logistic Regression vs Trees
After building my logistic regression model, I’ve summed up:
-	It has a 54%-68% accuracy from adjusting the threshold on my predictions from 0.3-0.5. 
-	I calculated the AUC of a baseline model to discover its accuracy on data of people who didn’t vote using the library package _ROCR_. 
    -	I made predictions on my logistic regression predictions in comparison to the actual values of people who voted or not in the dataset. 
    -	Using the performance function, I was able to calculate the above to get a 54% accuracy for baseline model.
-	Even though, my variables in my logistic regression model were highly statistically significant… my model does not improve over the baseline model of just predicting someone not voting. 
-	Also the AUC is very low – this is a weak predictive model. 

When building my CART tree for voting using all data and the same 4 treatment variables; I will not use the option _method=’class’_ since I’m creating a regression tree here. 
-	I am interested in building a tree to explore the fraction of people who vote, or the probability of voting. 
-	If I used the method=’class’, CART would only split if one of the groups had a probability of voting above 50% and the other had a probability of voting less than 50% (since predicted outcomes would be different). 
-	In contrast, with regression trees, CART will split even if both groups have probability less than 50%
CART Tree model observations:
-	I see that once plotting my CART tree model; I observed that no variables are used (the tree is only a root node) – none of the variables make a big enough effect to be split on. 
-	There is only 1 leaf and thus no splits in the tree since variables have no effect for any split. 
-	By rebuilding my model with a cp value of 0.0; I forced the tree to be built. I noticed that neighbour variable is the first split. 
    -	This is great since from the beginning of my analysis, I noticed that the highest fraction of voters was in the **Neighbors** group and thus I see the tree detects this trend. 

## Summary
This dataset has shown that trees can capture nonlinear relationships that logistic regression can not; but I can get around this sometimes by using variables that are the combination of two variables as shown through my code. 
**Note**: On my code, I used a combination of two variables to get around with this. I want to stress to not always use all possible interaction terms in a logistic regression model due to overfitting. I did it for this simple problems; in smaller datasets, this could quickly lead to overfitting. 

