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
plsda.res <- plsda(X, Y, ncomp = 5) # where ncomp is the number of components wanted

# Compute evaluation criteria
set.seed(2543) # for reproducibility here, only when the `cpus' argument is not used
perf.plsda <- perf(plsda.res, validation = "Mfold", folds = 5, 
                   progressBar = FALSE, auc = TRUE, nrepeat = 10) 

# Plot results
plot(perf.plsda, col = color.mixo(1:3), sd = TRUE, legend.position = "horizontal")

plsda.res <- plsda(X, Y, ncomp = 3) # where ncomp is the number of components wanted
auroc(plsda.res, roc.comp = 3)

plotLoadings(plsda.res, comp = 3, title = 'Loadings on comp 3', 
             contrib = 'max', method = 'mean', ndisplay = 50)

# With caret
library(caret)
# Compile cross-validation settings
set.seed(100)
# Outcome needs to be factor
dat$class <- as.factor(dat$class)
myfolds <- createMultiFolds(dat$class, k = 5, times = 10)
control <- trainControl("repeatedcv", index = myfolds, selectionFunction = "oneSE")
        
# Train PLS model
mod1 <- train(class ~ ., data = dat,
              method = "pls",
              metric = "Accuracy",
              tuneLength = 20,
              trControl = control)  
        
plot(mod1) 
plot(varImp(mod1), 10, main = "PLS-DA")  
