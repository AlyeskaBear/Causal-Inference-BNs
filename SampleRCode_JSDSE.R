#install.packages("bnlearn", dependencies=TRUE)
#if (!requireNamespace("BiocManager", quietly = TRUE))
#  install.packages("BiocManager", dependencies=TRUE)
#BiocManager::install(c("graph", "Rgraphviz", "RBGL"), dependencies=TRUE)
#install.packages("gRain", dependencies=TRUE)


# "bnlearn" and "gRain" are the two main R packages used for the five examples.
library(bnlearn)
library(gRain)
library(arules)
library(dplyr)

# Select an example
#---------------------------Example 1: Sex as a Cause of Pregnancy---------------------------------------#
# The Bayes Network model structure
# P(Sex,Pregnancy)=P(Sex)P(Pregnancy|Sex)
Ex1.DAG <- model2network('[Sex][Pregnancy|Sex]')
graphviz.plot(Ex1.DAG)

# Complete conditional probability table for the nodes of Sex and Pregnancy
# specify different states of a node
sex <- c("Male","Female")
pregnancy<-c("Yes","No")

# assign probability values to different states
# the Sex node 

                         # parent node
S <- array(dimnames = list(Sex = sex), dim = 2, c(100/200,100/200))

# the Pregnancy node 
Pregnancy.value<-data.frame(Sex=c("Male", "Female"), Yes=c(0,0.1), No=c(1,0.9))

Pregnancy.value<-t(data.matrix(Pregnancy.value)) 

                               # child node <-- parent node
PR <- array(dimnames = list(Pregnancy=pregnancy, Sex = sex 
                                 ), dim = c(2,2), c(0,100/100,
                                               10/100,90/100))


# Check the created probability tables
S  # the Sex node 
PR # the Pregnancy node 

# feed the probability tables to the causal structure
cpts <- list(Sex = S, Pregnancy = PR)
Ex1.fit = custom.fit(Ex1.DAG, cpts)
graphviz.chart(Ex1.fit,type = "barprob", scale = c(1.25, 2), bar.col = "green", strip.bg = "lightgray")

# Model compiling 
junction<-compile(as.grain(Ex1.fit))

# Node intervention and manipulation Intervene on the nodes 
# 1. fix the Sex node at the state "Male"
jSex.Male<-setEvidence(junction, nodes="Sex", states="Male")
querygrain(jSex.Male, nodes="Pregnancy")$Pregnancy
bn.fit.barchart(as.bn.fit(jSex.Male,including.evidence = TRUE)$Pregnancy, main="Pregnancy", xlab="Posterintervention Distribution")

# 2. fix the Sex node at the state "Female"
jSex.Female<-setEvidence(junction, nodes="Sex", states="Female")
querygrain(jSex.Female, nodes="Pregnancy")$Pregnancy
bn.fit.barchart(as.bn.fit(jSex.Female,including.evidence = TRUE)$Pregnancy, main="Pregnancy", xlab="Posterintervention Distribution")
#----------------------------------------------------------------------------------------------------------#



#---------------------------Example 2: Color Preference by Culture---------------------------------------#
# The Bayes Network model structure
# P(Sex,Culture)=P(Culture)P(Color|Culture)
Ex2.DAG <- model2network('[Culture][Color|Culture]')
graphviz.plot(Ex2.DAG)

# Complete conditional probability table for the nodes of Culture and Color
# specify different states of a node
culture <- c("A","B")
color<-c("Black","Blue", "Red" )

# assign probability values to different states
# the Sex node 
# parent node
S <- array(dimnames = list(Culture = culture), dim = 2, c(50/100,50/100))

# the Color node 
# child node <-- parent node
C <- array(dimnames = list(Color=color, Culture = culture
), dim = c(3,2), c(25/50, 15/50, 10/50,
                   5/50, 10/50, 35/50))
# Check the created probability tables
S  # the Culture node 
C # the Color node 

# feed the probability tables to the causal structure
cpts <- list(Culture = S, Color = C)
Ex2.fit = custom.fit(Ex2.DAG, cpts)
graphviz.chart(Ex2.fit, type = "barprob", scale = c(1.25, 2), bar.col = "green", strip.bg = "lightgray")
Ex2.fit$Sex
Ex2.fit$Color

# Model compiling 
junction<-compile(as.grain(Ex2.fit))

# Node intervention and manipulation Intervene on the nodes 
# 1. fix the Culture node at the state "A"
jCulture.A<-setEvidence(junction, nodes="Culture", states="A")
querygrain(jCulture.A, nodes="Color")$Color
bn.fit.barchart(as.bn.fit(jCulture.A,including.evidence = TRUE)$Color, main="Color", xlab="Posterintervention Distribution")

# 2. fix the Culture node at the state "B"
jCulture.B<-setEvidence(junction, nodes="Culture", states="B")
querygrain(jCulture.B, nodes="Color")$Color
bn.fit.barchart(as.bn.fit(jCulture.B,including.evidence = TRUE)$Color, main="Color", xlab="Posterintervention Distribution")
#-------------------------------------------------------------------------------------------------------------#



#---------------------------Example 3: Efficacy of Medication Treatment---------------------------------------#
# The Bayes Network model structure
# P(Treatment, Sex, Recovery)=P(Recovery|Sex,Treatment)P(Treatment)P(Sex)
Ex3.DAG <- model2network('[Hospital][Treatment][Recovery|Hospital:Treatment]')
graphviz.plot(Ex3.DAG)

# Complete conditional probability table for the nodes of Recovery, Treatment and Sex
# specify different states of a node
recovery<- c("Yes","No")
treatment<-c("Medication","Placebo")
hospital<-c("A","B")

# assign probability values to different states
# the Sex node
                            # parent node
S <- array(dimnames = list(Hospital = hospital # A=18+12+7+3=40; B=2+8+9+21=40
), dim = 2, c(40/80,40/80))

# the Treatment node
                             # parent node
T <- array(dimnames = list(Treatment=treatment
                             # Medication =18+12+2+8=40
                             # Placebo =7+3+9+21=40
                             
), dim = 2, c(40/80,40/80))

# the Recovery node
                              # child node <-- parent node, parent node
R <- array(dimnames = list(Recovery=recovery, Treatment=treatment, Hospital = hospital
                              # Yes Medication A=18
                              # No Medication A=12
                              # Yes Placebo A=7
                              # No Placebo A=3
                              
                              # Yes Medication B=2
                              # No Medication B=8 
                              # Yes Placebo B=9
                              # No Placebo B=21 
                              
), dim = c(2,2,2), c(18/30, 12/30,
                     7/10, 3/10,
                     2/10, 8/10,
                     9/30, 21/30))

# Check the created probability tables
S   # the Hospital node
T  # the Treatment node
R # the Recovery node

# feed the probability tables to the causal structure
cpts <- list(Recovery = R, Treatment = T, Hospital=S)
Ex3.fit = custom.fit(Ex3.DAG, cpts)
graphviz.chart(Ex3.fit,type = "barprob", scale = c(1.25, 2), bar.col = "green", strip.bg = "lightgray")
Ex3.fit$Recovery

# Model compiling 
junction<-compile(as.grain(Ex3.fit))

# Node intervention and manipulation Intervene on the nodes 
# 1. fix the Treatment node at the state "Medication"
jtreatment.Medication<-setEvidence(junction, nodes="Treatment", states="Medication")
querygrain(jtreatment.Medication, nodes="Recovery")$Recovery
bn.fit.barchart(as.bn.fit(jtreatment.Medication,including.evidence = TRUE)$Recovery, main="Recovery", xlab="Posterintervention Distribution")

# 2. fix the Treatment node at the state "Placebo"
jtreatment.Placebo<-setEvidence(junction, nodes="Treatment", states="Placebo")
querygrain(jtreatment.Placebo, nodes="Recovery")$Recovery
bn.fit.barchart(as.bn.fit(jtreatment.Placebo,including.evidence = TRUE)$Recovery, main="Recovery", xlab="Posterintervention Distribution")
#---------------------------------------------------------------------------------------------#



#---------------------------Example 4: Should I switch?---------------------------------------#
# The Bayes Network model structure
# P(Host, Jen, Car)=P(Jen)P(Car)P(Jen)P(Host|Jen,Car)
Ex4.DAG <- model2network('[Jen][Car][Host|Jen:Car]')
graphviz.plot(Ex4.DAG)

# Complete conditional probability table for the nodes of Sex and Color
# specify different states of a node
jen <- c("Door1","Door2", "Door3")
car<-c("Door1","Door2", "Door3")
host<-c("Door1","Door2", "Door3")

# assign probability values to different states
# the Jen node 
                          # parent node
J <- array(dimnames = list(Jen = jen), dim = 3, c(1/3,1/3,1/3))

# the Car node 
                        # parent node
C <- array(dimnames = list(Car=car), dim = 3, c(1/3,1/3,1/3))

# the Host node
                        # child node <-- parent node, parent node
H <- array(dimnames = list(Host=host, Jen=jen,  Car=car 
                               # Door1	Door1: Door1	0
                               # Door2	Door1: Door1	1/2
                               # Door3	Door1: Door1	1/2
                               # Door1	Door2: Door1	0
                               # Door2	Door2: Door1	0
                               # Door3	Door2: Door1	1
                               # Door1	Door3: Door1	0
                               # Door2	Door3: Door1	1
                               # Door3	Door3: Door1	0
                           
                               # Door1	Door1: Door2	0
                               # Door2	Door1: Door2	0
                               # Door3	Door1: Door2	1
                               # Door1	Door2: Door2	1/2
                               # Door2	Door2: Door2	0
                               # Door3	Door2: Door2	1/2
                               # Door1	Door3: Door2	1
                               # Door2	Door3: Door2	0
                               # Door3	Door3: Door2	0
                           
                               # Door1	Door1: Door3  0
                               # Door2	Door1: Door3	1
                               # Door3	Door1: Door3	0
                               # Door1	Door2: Door3	1
                               # Door2	Door2: Door3	0
                               # Door2	Door2: Door3	0
                               # Door1	Door3: Door3	1/2
                               # Door2	Door3: Door3	1/2
                               # Door3	Door3: Door3	0   
                           
                              
), dim = c(3,3,3), c(0, 1/2, 1/2, 0, 0, 1, 0, 1, 0,
                     0, 0, 1, 1/2, 0, 1/2, 1, 0, 0,
                     0, 1, 0, 1, 0, 0, 1/2, 1/2, 0))

H

# Check the created probability tables
J  # the Jen node 
C # the Car node 
H # the Host node

# feed the probability tables to the causal structure
cpts <- list(Jen = J, Car = C, Host=H)
Ex4.fit = custom.fit(Ex4.DAG, cpts)
graphviz.chart(Ex4.fit, type = "barprob", scale = c(1.25, 2), bar.col = "green", strip.bg = "lightgray")
Ex4.fit$Host


# Model compiling 
junction<-compile(as.grain(Ex4.fit))

# Node intervention and manipulation Intervene on the nodes 
# 1. fix the Jen and Car nodes at the states "Door1" and "Door1" respectively
jJenCar.Door1.Door1<-setEvidence(junction, nodes=c("Jen", "Car"), states=c("Door1", "Door1"))
querygrain(jJenCar.Door1.Door1, nodes="Host")$Host
bn.fit.barchart(as.bn.fit(jJenCar.Door1.Door1,including.evidence = TRUE)$Host, main="Host", xlab="Posterintervention Distribution")

# 2. fix the Jen and Car nodes at the states "Door1" and "Door2" respectively
jJenCar.Door1.Door2<-setEvidence(junction, nodes=c("Jen", "Car"), states=c("Door1", "Door2"))
querygrain(jJenCar.Door1.Door2, nodes="Host")$Host
bn.fit.barchart(as.bn.fit(jJenCar.Door1.Door2,including.evidence = TRUE)$Host, main="Host", xlab="Posterintervention Distribution")
#-----------------------------------------------------------------------------------------------------------#



#---------------------------Example 5: : Effect of Smoking on Forced Expiratory Volume---------------------------------------#
# Download the example data file from JSDSE website
FEV.data<-read.table("http://jse.amstat.org/datasets/fev.dat.txt", col.names = c("Age", "FEV", "Height", "Sex",	"Smoke"))

# Discretize Age, FEV, and Height.
FEV.data.discrete<-data.frame(Age=arules::discretize(FEV.data$Age, method = "fixed", breaks = c(3, 5, 12, 15, 19), include.lowest=TRUE, right=FALSE, labels = c("3 to 5", 
                                                                                                                                                        "5 to 12", 
                                                                                                                                                        "12 to 15", 
                                                                                                                                                        "15 to 19")),
                              FEV=arules::discretize(FEV.data$FEV, method = "fixed", breaks = c(0, 1, 2, 3, 4, 5, 6), include.lowest=TRUE, right=FALSE, labels = c("0 to 1", 
                                                                                                                                                           "1 to 2", 
                                                                                                                                                           "2 to 3", 
                                                                                                                                                           "3 to 4",
                                                                                                                                                           "4 to 5",
                                                                                                                                                           "5 to 6")),
                              Height=arules::discretize(FEV.data$Height, method = "fixed", breaks = c(45, 50, 55, 60, 65, 70, 75), include.lowest=TRUE, right=FALSE, labels = c("45 to 50", 
                                                                                                                                                                        "50 to 55", 
                                                                                                                                                                        "55 to 60", 
                                                                                                                                                                        "60 to 65",
                                                                                                                                                                        "65 to 70",
                                                                                                                                                                        "70 to 75")),
                              Sex=as.factor(FEV.data$Sex),
                              Smoke=as.factor(FEV.data$Smoke))

# convert all data to be of factor format.
FEV.data.discrete<- FEV.data.discrete %>% mutate_if((~is.factor(.)==FALSE), as.factor)

# The Bayes Network model structure
# P(FEV,Smoke,Age,Sex) = P(FEV|Smoke,Age,Sex)P(Height|Smoke,Age,Sex)P(Smoke|Age, Sex)P(Age)P(Sex)
Ex5.DAG <- model2network("[Sex][Age][Smoke|Sex:Age][Height|Sex:Age:Smoke][FEV|Sex:Age:Smoke:Height]")
graphviz.plot(Ex5.DAG)

# feed the probability tables to the causal structure
Ex5.fit<-bn.fit(Ex5.DAG, FEV.data.discrete, method = 'bayes', iss=290) 
#---------------------------------------------------------------------------------------------------#
# When building a BN model from an empirical data file, Netica follows a specific way to avoid the 
# zero-probability problem. Suppose a data file contains three records for the variable X 
# with possible values x1 and x2, as below
#                                     X
#                                     x1
#                                     x1
#                                     x1
#
# The frequency table for X based on this data file is 
#                               x1    x2
#                           X   3      0
#
# To avoid the zero probability for X=x2, Netica adds one to both frequencies of x1 and x2,
#                               x1    x2
#                           X   4      1
#
# Then the proability table is calculated to be 
#                               x1    x2
#                           X   0.8   0.2
#
# In the bn.fit() function, setting method = 'bayes' and iss(imaginary sample size) = 290 approximates 
# the Netica's way of aoviding the zero-probability problem for this example.
#---------------------------------------------------------------------------------------------------#
graphviz.chart(Ex5.fit,type = "barprob", scale = c(1.25, 2), bar.col = "green", strip.bg = "lightgray")

# Model compiling 
junction<-compile(as.grain(Ex5.fit))

# Node intervention and manipulation Intervene on the nodes 
# 1. fix the Smoke node at the state "0"
jSmoke.0<-setEvidence(junction, nodes=c("Smoke"), states=c("0"))
querygrain(jSmoke.0, nodes="FEV")$FEV

# 2. fix the Smoke node at the state "1"
jSmoke.1<-setEvidence(junction, nodes=c("Smoke"), states=c("1"))
querygrain(jSmoke.1, nodes="FEV")$FEV

# 3. fix the Smoke, Age, and Sex nodes at the states "0", "15 to 19", and "1" respectively

text<-"Smoke, Age, Sex"
text2<-strsplit(text, ',')[[1]]
state<-"0, 5 to 12, 1"
state2<-strsplit(state, ',')[[1]]
jSmoke0.AgeSex15191<-setEvidence(junction, nodes=text2, states=state2)
querygrain(jSmoke0.AgeSex15191, nodes="FEV")$FEV
bn.fit.barchart(as.bn.fit(jSmoke0.AgeSex15191,including.evidence = TRUE)$FEV, main="FEV", xlab="Posterintervention Distribution")

# 4. fix the Smoke, Age, and Sex nodes at the states "1", "15 to 19", and "1" respectively
jSmoke1.AgeSex15191<-setEvidence(junction, nodes=c("Smoke", "Age", "Sex"), states=c("1", "5 to 12", "1"))
querygrain(jSmoke1.AgeSex15191, nodes="FEV")$FEV
bn.fit.barchart(as.bn.fit(jSmoke1.AgeSex15191,including.evidence = TRUE)$FEV, main="FEV", xlab="Posterintervention Distribution")

