
library(glmnet)

best.coefs <- function(model) {
    stopifnot(inherits(model, "cv.glmnet"))
    best.model <- which.min(model$cvm)
    if (!is.list(model$glmnet.fit$beta)) {
        model$glmnet.fit$beta <- list(model$glmnet.fit$beta)
    }
    tmp <- lapply(model$glmnet.fit$beta, function(x) {
        x <- x[,best.model]
        x[abs(x) > sqrt(.Machine$double.eps)]
    })
    with(model$glmnet.fit, cbind(
        `(Intercept)`=a0[best.model],
        do.call(rbind, tmp)
    ))
}

