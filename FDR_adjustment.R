# Understanding false discovery rate
# From Cross Validated question: help-in-understanding-how-to-apply-correctly-false-discovery-rate-adjustement
set.seed(620)

# Do 10000 random t-tests
x <- matrix(rnorm(10000*5),nrow=10000)
y <- matrix(rnorm(10000*5),nrow=10000)
p <- sapply(1:10000, function(i) t.test(x[i,],y[i,])$p.val)

sum(p < 0.05) # 453 / 10000 = 4.53% false positives

q = p.adjust(p, method = "fdr")
sum(q < 0.05) 


y[9901:10000,] = rnorm(500, mean=3) 
p = sapply(1:10000, function(i) t.test(x[i,],y[i,])$p.val)
sum(p < 0.05) # 548 / 10000
q = p.adjust(p, method = "fdr")

# Only 9 values lower than threshold. Why?
# Because BH controls the FDR to be less than or equal to the specified level
# Example biased because null hypothesis always true


# From Excel sheet benjaminhochberg. Reproduce result in R.
# Get sorted p-values
p <- read.delim("clipboard", header = F)
p$fdr <- p.adjust(p$V1, method = "fdr")

# Default FDR for p.adjust is 10%

# FDR adjusted confidence intervals
# Breast cancer example. Instead of using 1-alpha = 1-0.05 use 1-(5*0.1)/43
# Marco's example: 
# 1 - R * FDR / m
alpha = (100*0.05)/10000
1 - alpha

# BC study
alpha1 <- (5*0.1)/43 
confint(fits0[[1]], level = 0.95)
confint(t1$estimate, level = 0.95)




