# Letter Recognition

One of the earliest applications of the predictive analytics methods I have studied so far in class was to automatically recognize letters, which post office machines use to sort mail. In this problem, I will build a model that uses statistics of images of four letters in the Roman alphabet -- A, B, P, and R -- to predict which letter an image corresponds to.

Note that this is a multiclass classification problem not a binary classification problem (e.g. predicting whether an individual voted or not). 

The file letters_ABPR.csv contains 3116 observations, each of which corresponds to a certain image of one of the four letters A, B, P and R. The images came from 20 different fonts, which were then randomly distorted to produce the final images; each such distorted image is represented as a collection of pixels, each of which is "on" or "off". For each such distorted image, we have available certain statistics of the image in terms of these pixels, as well as which of the four letters the image is. 

This data comes from the [UCI Machine Learning Repository]( https://archive.ics.uci.edu/ml/support/letter+recognition)

## The Data
This dataset contains the following 17 variables:
-	letter = the letter that the image corresponds to (A, B, P or R)
-	xbox = the horizontal position of where the smallest box covering the letter shape begins.
-	ybox = the vertical position of where the smallest box covering the letter shape begins.
-	width = the width of this smallest box.
-	height = the height of this smallest box.
-	onpix = the total number of "on" pixels in the character image
-	xbar = the mean horizontal position of all of the "on" pixels
-	ybar = the mean vertical position of all of the "on" pixels
-	x2bar = the mean squared horizontal position of all of the "on" pixels in the image
-	y2bar = the mean squared vertical position of all of the "on" pixels in the image
-	xybar = the mean of the product of the horizontal and vertical position of all of the "on" pixels in the image
-	x2ybar = the mean of the product of the squared horizontal position and the vertical position of all of the "on" pixels
-	xy2bar = the mean of the product of the horizontal position and the squared vertical position of all of the "on" pixels
-	xedge = the mean number of edges (the number of times an "off" pixel is followed by an "on" pixel, or the image boundary is hit) as the image is scanned from left to right, along the whole vertical length of the image
-	xedgeycor = the mean of the product of the number of horizontal edges at each vertical position and the vertical position
-	yedge = the mean number of edges as the images is scanned from top to bottom, along the whole horizontal length of the image
-	yedgexcor = the mean of the product of the number of vertical edges at each horizontal position and the horizontal position

## Predicting B or not B
I started this predictive analysis by attempting just whether a letter is B or not B. To do this, I added a variable _isB_ into the dataframe, which takes value “TRUE” if the observation corresponds to the letter B. 

> letters$isB = as.factor(letters$letter == “B”)

Before building my model, I will dive into building a baseline model predicting the most frequent outcome i.e. not ‘B’. 

### Baseline Model 
When dealing with an dependent value that is continuous, I will be predicting the daily amount of rain (for instance). In another case, when dealing with binary outcome, meaning I’m assigning the probabilities to the occurrence of rain on a given day; both of these continuous and binary cases, I will be fitting a baseline model and two machine learning models.
-	**Baseline model:** usually, this means I assume there are no predictors (i.e. independent variables). Thus, I have to make an educated guess (not a random one), based on the value of the dependent value alone. This baseline model is important because it will allow me to determine how good the other models are. 
-	**Decision Tree** -- regression tree for continuous outcome and classification tree for the binary case. These models offer high interpretability and decent accuracy; then, I will build random forests, a very popular method where there is often a gain in accuracy, at the expense of interpretability. 

## Predicting Letters A, B, P, R

I’m moved onto a more interesting problem; to predict whether or not a letter is one of the 4 letters for postage sorting. From experience, building a multiclass classification CART model in R is not that much harder than building the models for binary classification. Fortunately, building a random forest model is just as easy. 
The variable in the data frame which I will be predicting is “letter”.
-	Data preparation: Converting the letter variable into a factor.

> letters$letter = as.factor(letters$letter)

## Results
Random Forest model accuracy on the test set is significantly higher than the value for CART, highlighting the gain in accuracy that is possible from using random forest models. 

Furthermore, while the accuracy of CART decreased significantly as I transitioned from the problem of predicting B/notB (simple problem) to the problem of predicting 4 letters (harder problem), accuracy of the random forest model decreased by a tiny amount. 

