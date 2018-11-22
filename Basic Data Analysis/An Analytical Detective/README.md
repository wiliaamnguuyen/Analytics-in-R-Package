# Analytical Detective Data Exploratory Analysis 

## Crime is an international concern, but it is documented and handled in very different ways in different countries. 

In the United States, violent crimes and property crimes are recorded by the Federal Bureau of Investigation (FBI).  

Additionally, each city documents crime, and some cities release data regarding crime rates. 

The city of Chicago, Illinois releases crime data from 2001 onward [online](https://data.cityofchicago.org/Public-Safety/Crimes-2001-to-present/ijzp-q8t2).

Chicago is the third most populous city in the United States, with a population of over 2.7 million people. 

The city of Chicago is shown in the map below, with the state of Illinois highlighted in red. 

In this problem, we'll focus on one specific type of property crime, called "motor vehicle theft" (sometimes referred to as grand theft auto). 

This is the act of stealing, or attempting to steal, a car. 

### In this problem, we'll use some basic data analysis in R to understand the motor vehicle thefts in Chicago.

-	**ID**: a unique identifier for each observation
-	**Date**: the date the crime occurred
-	**LocationDescription**: the location where the crime occurred
-	**Arrest**: whether or not an arrest was made for the crime (TRUE if an arrest was made, and FALSE if an arrest was not made)
-	**Domestic**: whether or not the crime was a domestic crime, meaning that it was committed against a family member (TRUE if it was domestic, and FALSE if it was not domestic)
-	**Beat**: the area, or "beat" in which the crime occurred. This is the smallest regional division defined by the Chicago police department.
-	**District**: the police district in which the crime occured. Each district is composed of many beats, and are defined by the Chicago Police Department.
-	**CommunityArea**: the community area in which the crime occurred. Since the 1920s, Chicago has been divided into what are called "community areas", of which there are now 77. The community areas were devised in an attempt to create socially homogeneous regions.
-	**Year**: the year in which the crime occurred.
-	**Latitude**: the latitude of the location at which the crime occurred.
-	**Longitude**: the longitude of the location at which the crime occurred.


 
