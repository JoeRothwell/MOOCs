#Linear models and matrix algebra course EdX
#Week 1------------------------------------------------------------------------------
library(UsingR)
data("father.son",package="UsingR")
mean(father.son$sheight)
ind <- round(father.son$fheight) == 71
mean(father.son$sheight[ind])

X = matrix(1:1000,100,10)
X[25,3]

x <- 1:10
mat <- cbind(x, 2*x, 3*x, 4*x, 5*x)
sum(mat[7,])

#The identity matrix, I, is the matrix with a diagonal of 1s which when multiplied by a matrix, gives 
#the same matrix. eg
matrix(1:9, 3) %*% diag(3)

#The inverse of a matrix is the matrix which when multiplied by the original matrix gives I. Use solve()
#to get the inverse (the identity matrix is used by default)
#To solve a system of equations, multiply inverse of model matrix by other side of equations
X <- cbind(c(3,2,1,5), c(4,2,-1,0), c(-5,2,5,0), c(1,-1,-5,1))
solve(X) %*% c(10,5,7,4)

#Product of matrices
a <- matrix(1:12, nrow=4)
b <- matrix(1:15, nrow=3)
(a %*% b) [3,2]

sum(a[3, ] * b[, 2])

#cross product function for a vector gives t(X) * X (to find RSS)

#example estimating the parameters for an object dropped from the top of the leaning tower of pisa
g <- 9.8 #acceleration due to gravity
n <- 25 #25 time points
tt <- seq(0, 3.4, len = n) #make the vector of timepoints
f <- 56.67 + 0*tt - 0.5*g*tt^2 #vector describing the displacement
y <- f + rnorm(n, sd=1) #add some random noise to f

#displacement given as a function of time, velocity, acceleration
#formula s = ut + 1/2.at^2 displacement = initial velocity x time + 1/2 acceleration x time ^2

plot(tt, y, xlab="Time in s", ylab="Distance in m") #plot noise model
lines(tt, f, col=2) #plot line without noise

#model with lm to find coefficients for intercept (height), initial vel and g
tt2 <- tt^2
fit <- lm(y ~ tt + tt2)
summary(fit)

#with matrix algebra. first make the model matrix
X <- cbind(1, tt, tt2)
#Put the approximate known coefficients in a 1x3 matrix
Beta <- matrix(c(55,0,5),3,1)
#Get the residuals
r <- y - X %*% Beta
RSS <- t(r) %*% r #or
RSS <- crossprod(r)
#Get the LSE
betahat <- solve( t(X) %*% X) %*% t(X) %*% y #or
betahat <- solve(crossprod(X)) %*% crossprod(X,y)

#Example exercises: have a model matrix as follows, representing four samples
X <- matrix(c(1,1,1,1,0,0,1,1), nrow=4)
rownames(X) <- c("a","a","b","b")
#Parameters of fitted model are:
beta <- c(5, 2)
X %*% beta #gives estimated y values

#With two more samples
X <- matrix(c(1,1,1,1,1,1,0,0,1,1,0,0,0,0,0,0,1,1),nrow=6)
rownames(X) <- c("a","a","b","b","c","c")
beta <- c(10,3,-3)
X %*% beta 

#Inference review exercises. Find SE of g from 100000 estimates using code above
set.seed(1)
y <- f + rnorm(n, sd=1)
mc <- replicate(100000, solve(crossprod(X)) %*% crossprod(X, (f + rnorm(n, sd=1))) )
sd(mc[3,1,]*-2)

#2. SE of slope estimate for father-son heights
x = father.son$fheight
y = father.son$sheight
n = length(y) #total no obs

N <- 50 #sample size
set.seed(1)
index <- sample(n, N)
sampledat = father.son[index,]
x = sampledat$fheight
y = sampledat$sheight
betahat =  lm(y~x)$coef

#Monte Carlo simulation 10000 samples
set.seed(1)
samples <- replicate(10000, sample(n, N))
betahats <- apply(samples, 2, function(x) lm(father.son[x, ]$sheight ~ father.son[x, ]$fheight) $coef)
cov(father.son$fheight, father.son$sheight)

#Standard error exercises
fit <- lm(y ~ x)
ri <- fit$fitted.values
sum((y - ri)^2) # sum of squared residuals
SSR <- sum((y - ri)^2) 
sigma2 <- SSR/48

#form a design matrix with fathers' heights
X <- cbind(1, x)
#find the inverse of X multplied by t(X) and take index 1,1
solve(t(X) %*% (X))[1,1]
#to find the SE of intercept and slope, multply by sigma2 and take square root
sqrt(sigma2 * diag(solve(t(X) %*% (X))))

#Week 3------------------------------------------------------------------------------
#formula and model matrix
x <- c(1,1,2,2)
f <- formula(~ x)
model.matrix(f)

#Questions
X = cbind(rep(1, 12),rep(c(0,1),c(5, 7)))
t(X) %*% X

#Week 4------------------------------------------------------------------------------
#Get contrast vector for conditions
species <- factor(c("A","A","B","B"))
condition <- factor(c("control","treated","control","treated"))
model.matrix( ~ species + condition)
#intercept: 1-1=0, species 1-0=1, condition 0-1=-1, vector = 0 1 -1

url <- "https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/spider_wolff_gorb_2013.csv"
filename <- "spider_wolff_gorb_2013.csv"
library(downloader)
if (!file.exists(filename)) download(url, filename)
spider <- read.csv(filename, skip=1)
#fit model
fit <- lm(friction ~ type + leg, data = spider)
#get contrast for L2 v L4 (specifying either push or pull give the same result)
contrast(fit, list(leg = "L2", type="push"), list(leg = "L4", type="push"))

#The standard errors of the coefficients are the square roots of the diagonal of the covariance matrix
#of betahat.
#Using Sigma (covariance matrix of betahat), find Cov(betahatL4, betahatL2)
X <- model.matrix(~ type + leg, data=spider)
#Sigma = sum of squared residuals/df * inverse of X
Sigma <- sum(fit$residuals^2)/(nrow(X) - ncol(X)) * solve(t(X) %*% X)

#Interactions exercise
spider$log2friction <- log2(spider$friction)
fit2 <- lm(log2friction ~ type*leg, data = spider)
anova(fit2)
#difference between L2 and L1 pull samples is 0.34681 (from model summary)
#difference between L2 and L1 push samples is 0.34681 + 0.09967 (adding interaction estimate for push)

#Distribution of F-values
N <- 40
p <- 4
group <- factor(rep(1:p,each=N/p))
X <- model.matrix(~ group)

Y <- rnorm(N,mean=42,7)
mu0 <- mean(Y)
initial.ss <- sum((Y - mu0)^2)
s <- split(Y, group)
after.group.ss <- sum(sapply(s, function(x) sum((x - mean(x))^2)))
group.ss <- initial.ss - after.group.ss
group.ms <- group.ss / (p - 1)
after.group.ms <- after.group.ss / (N - p)
f.value <- group.ms / after.group.ms

#Monte Carlo simulation with loop
output <- numeric(1000)
set.seed(1)
for (i in 1:1000) {
  Y <- rnorm(40, mean=42,7)
  mu0 <- mean(Y)
  initial.ss <- sum((Y - mu0)^2)
  s <- split(Y, factor(rep(1:4, each = 10)))
  after.group.ss <- sum(sapply(s, function(x) sum((x - mean(x))^2)))
  group.ss <- initial.ss - after.group.ss
  group.ms <- group.ss / 3
  after.group.ms <- after.group.ss / 36
  f.value <- group.ms / after.group.ms
  output[i] <- f.value
}

#Plot output
hist(output, col="grey", border="white", breaks=50, freq=FALSE)
xs <- seq(from=0,to=6,length=100)
#overlay theoretical F-distribution
lines(xs, df(xs, df1 = p - 1, df2 = N - p), col="red")

#Colinearity exercises
sex <- factor(rep(c("female","male"),each=4))
trt <- factor(c("A","A","B","B","C","C","D","D"))
X <- model.matrix( ~ sex + trt)
qr(X)$rank
Y <- 1:8
makeYstar <- function(a,b) Y - X[,2] * a - X[,5] * b
fitTheRest <- function(a,b) {
  Ystar <- makeYstar(a,b)
  Xrest <- X[,-c(2,5)]
  betarest <- solve(t(Xrest) %*% Xrest) %*% t(Xrest) %*% Ystar
  residuals <- Ystar - Xrest %*% betarest
  sum(residuals^2)
}

fitTheRest(1,2)
expand.grid(1:3,1:3)
betas = expand.grid(-2:8,-2:8)

rss = apply(betas,1,function(x) fitTheRest(x[1],x[2]))
library(rafalib)
themin=min(rss)

plot(betas[which(rss==themin),])

#QR decomposition
#Load spider dataset from above
fit <- lm(friction ~ type + leg, data=spider)
Y <- matrix(spider$friction, ncol=1)
X <- model.matrix(~ type + leg, data=spider)
#Decomposition is done using qr function then Q and R can be extracted
QR <- qr(X)
Q <- qr.Q(QR)
R <- qr.R(QR)
#Q^T * Y is therefore the following
crossprod(Q, Y)

#High dimensional data analysis Week 1--------------------------------------------------

#High throughput experiments-------------------------------------------------------------------- 

#Download and install data
library(devtools)
install_github("genomicsclass/GSE5859Subset")
library(GSE5859Subset)
data(GSE5859Subset) ##this loads the three tables

