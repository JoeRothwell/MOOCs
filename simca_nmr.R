library(gsheet)
url <- 'https://docs.google.com/spreadsheets/d/12WIc0LRpH7QJJPw4E8wIo9q8BMnMU25Su7J3-TELFds/edit?usp=sharing'
dat <- gsheet2tbl(url)

library(mixOmics)
library(dplyr)
X <- as.matrix(dat[, -1])
Y <- pull(dat[, 1])

# First plot PCA
pca.nmr <- pca(X, ncomp = 10, center = F, scale = F)
plotIndiv(pca.nmr, group = Y, ind.names = F, legend = T, title = 'NMR data')

# PLS-DA with 5 components (arbitrary choice)
plsda.initial <- plsda(X, Y, ncomp = 5) # where ncomp is the number of components wanted

# Compute evaluation criteria
set.seed(2543) # for reproducibility here, only when the `cpus' argument is not used
modeval <- perf(plsda.initial, validation = "Mfold", folds = 5, progressBar = F, auc = T, nrepeat = 10) 
# 3 components seem to be best

# Plot results
plot(modeval, col = color.mixo(1:3), sd = T, legend.position = "horizontal")

plsda.comp <- plsda(X, Y, ncomp = 3) # where ncomp is the number of components wanted
auroc(plsda.res, roc.comp = 3)

plotLoadings(plsda.res, comp = 3, title = 'Loadings on comp 3', 
             contrib = 'max', method = 'mean', ndisplay = 50)

# With caret
# See https://poissonisfish.wordpress.com/2017/06/17/partial-least-squares-in-r/
library(caret)
# Compile cross-validation settings
set.seed(100)
# Outcome needs to be factor
dat$class <- as.factor(dat$class)
myfolds <- createMultiFolds(dat$class, k = 5, times = 10)
control <- trainControl("repeatedcv", index = myfolds, selectionFunction = "oneSE")
        
# Train PLS model. Performs models from 1-20 components and selects best model
mod1 <- train(class ~ ., data = dat,
              method = "pls",
              metric = "Accuracy", # because is classification
              tuneLength = 20,
              trControl = control)  
        
mod1
# get summary
plot(mod1) 
plot(varImp(mod1), 10, main = "PLS-DA")  

# Extract and plot scores LV1 vs LV2
pls.scores <- as.matrix(mod1$finalModel[[2]])
plot(pls.scores[, 1], pls.scores[, 2], col = dat$class, pch  = 19,
     xlab = "LV1", ylab = "LV2")
