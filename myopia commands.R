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
