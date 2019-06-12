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
