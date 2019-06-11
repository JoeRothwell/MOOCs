g <- read.csv("simulated HF mort data for GMPH (1K) final.csv")

library(survival)
library(ggplot2)
library(tidyverse)

# Week 1 - survival function
gender <- as.factor(g[, "gender"]) # R calls categorical variables factors
fu_time <- g[, "fu_time"] # continuous variable (numeric) 
death <- g[, "death"] # binary variable (numeric)

# Make survival object, follow up time for right-censored data, fit Kaplan-Meier
km_fit <- survfit(Surv(fu_time, death) ~ 1)
plot(km_fit)
# Get probabilities at time t
summary(km_fit, times = c(1:7,30,60,90*(1:10))) 

# Stratify gender
km_gender_fit <- survfit(Surv(fu_time, death) ~ gender) 
plot(km_gender_fit)
# Log rank (Mantel-Haenszel) for difference
survdiff(Surv(fu_time, death) ~ gender, rho=0) 

# Stratify age group
age_cat <- ifelse(g$age < 65, 0, 1)
km_age_fit <- survfit(Surv(fu_time, death) ~ age_cat)
plot(km_age_fit)
survdiff(Surv(fu_time, death) ~ age_cat, rho=0) 

# Week 2 - the Cox model
library(survminer)
cox <- coxph(Surv(fu_time, death) ~ ethnicgroup, data = g) # take variables straight from g
summary(cox)
# Ethnic group needs to be a factor, otherwise will be treated as a continuous variable

ethnicgroup <- factor(g[,"ethnicgroup"]) # can also use “as.factor” rather than “factor”
ethnicgroup <- fct_explicit_na(ethnicgroup, na_level = "8")
fu_time <- g[,"fu_time"]
death <- g[,"death"]

cox <- coxph(Surv(fu_time, death) ~ ethnicgroup)
summary(cox)

# Week 3 - the multiple Cox model

summary(g$age)
t <- table(g$gender)
addmargins(t)

table(g$prior_dnas)
table(g$ethnicgroup)
table(g$copd)

gender <- factor(g$gender)
age <- g$age
copd <- factor(g$copd)
prior_dnas <- g$prior_dnas

cox <- coxph(Surv(fu_time, death) ~ age + gender + copd + prior_dnas + ethnicgroup)

summary(cox)
