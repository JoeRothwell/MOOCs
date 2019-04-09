# From Coursera course---------------------------------------------------------------------------------------
#myopia dataset
myopia <- read.csv("MYOPIA-fixed.csv")

#fit the logistic regression model and store
myopia.model <- glm(MYOPIC ~ SPHEQ, data=myopia, family=binomial)
summary(myopia.model)
plot(myopia.model) #diagnostic plots

#scatter graph of myopic vs SPHEQ
plot(MYOPIC ~ SPHEQ, data=myopia)

#ICU dataset
icu <- read.csv("icu.csv")
summary(icu)
plot(STA ~ AGE, data=icu) 
icu.model <- glm(STA ~ AGE, data=icu, family=binomial)
summary(icu.model)

#likelihood ratio test: compare with naive model
null.icu <- glm(STA ~ NULL, data=icu, family=binomial)
library(lmtest)
lrtest(icu.model, null.icu)
waldtest(icu.model, null.icu)

# From Rbloggers logistic ROC--------------------------------------------------------------

#logistic regression and ROC curve
#read in admissions data (from rbloggers post)
admissions <- read.csv("admissions.csv")
#Create plot
plot(admissions$score.1, admissions$score.2, col=as.factor(admissions$label), 
     xlab="Score-1", ylab="Score-2")

#Predictor variables
X <- as.matrix(admissions[ , c(1,2)])
#Add ones to X
X <- cbind(rep(1, nrow(X)), X)
#Response variable
Y <- as.matrix(admissions$label)
#Sigmoid function
sigmoid <- function(z)
{ g <- 1/(1+exp(-z))
return(g)}
#Cost Function
cost <- function(theta)
{
  m <- nrow(X)
  g <- sigmoid(X%*%theta)
  J <- (1/m)*sum((-Y*log(g)) - ((1-Y)*log(1-g)))
  return(J)
}

#Intial theta
initial_theta <- rep(0, ncol(X))
#Cost at inital theta
cost(initial_theta)
# Derive theta using gradient descent using optim function
theta_optim <- optim(par=initial_theta, fn=cost)
#set theta
theta <- theta_optim$par
#cost at optimal value of the theta
theta_optim$value
# probability of admission for student
prob <- sigmoid(t(c(1,45,85))%*%theta)

##### from R cookbook diabetes data
data(pima, package="faraway")
b <- factor(pima$test)
m <- glm(b ~ diastolic + bmi, family=binomial, data=pima)
summary(m)
#as only BMI is significant, create a reduced model with only this
m.red <- glm(b ~ bmi, family=binomial, data=pima)
summary(m.red)
#use this to preduct the probability that someone with average BMI will get diabetes
newdata <- data.frame(bmi=32.0)
predict(m.red, type="response", newdata=newdata)

#ROC curve from another Rbloggers post. First predict probabilities for all observations
S <- predict(m.red, type="response") 

#to calculate confusion matrix, first define function (s)
#FPR = false pos rate, TPR = true pos rate
roc.curve <- function(s, print=FALSE){
  Ps = (S > s)*1
  FP = sum((Ps==1)*(b==0)) / sum(b==0)
  TP = sum((Ps==1)*(b==1)) / sum(b==1)
  if(print==TRUE){
    print(table(Observed=b, Predicted=Ps))
  }
  vect=c(FP, TP)
  names(vect)=c("FPR", "TPR")
  return(vect)
}
threshold = 0.5
roc.curve(threshold, print=TRUE)

#predicted vs observed graph
ROC.curve <- Vectorize(roc.curve)
I=(((S > threshold) & (b==0)) | ((S <= threshold) & (b==1)))
plot(S, b, col=c("red", "blue")[I+1], pch=19, cex=.7, , xlab="", ylab="")
abline(v=cutoff, col="gray")

#draw ROC curve
M.ROC <- ROC.curve(seq(0, 1, by=.01))
plot(M.ROC[1, ], M.ROC[2, ], col="blue", lwd=2, type="l")

#ROC--------------------------------------------------------------

Ps = (S > 0.3332689)*1
FP=sum((Ps==1)*(b==0)) / sum(b==0)
TP=sum((Ps==1)*(b==1)) / sum(b==1)
if(print==TRUE){
  print(table(Observed=b, Predicted=Ps))
}
vect=c(FP, TP)
names(vect)=c("FPR", "TPR")
return(vect)