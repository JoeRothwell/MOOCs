# Functions 1 -----------------------------------

describe <- function(object, ...) {
    UseMethod("describe")
}

describe.default <- function(object, var.name, na.rm=TRUE) {
    if (!is.numeric(object)) {
        stop(deparse(substitute(object)), " must be numeric")
    }
    if (missing(var.name)) {
        var.name <- deparse(substitute(object))
    }

    par(mfrow=c(2, 3), pty="s")

    plot(density(object, na.rm=na.rm), main="Density")
    hist(object, main="Histogram", xlab=var.name)
    qqnorm(object, pch=20, main="Normal Q-Q plot")
    qqline(object)

    plot(density(log(object), na.rm=na.rm), main="Density")
    hist(log(object), main="Histogram", xlab=sprintf("log(%s)", var.name))
    qqnorm(log(object), pch=20, main="Normal Q-Q plot")
    qqline(log(object))
}

describe.data.frame <- function(object, na.rm=TRUE) {
    devAskNewPage(ask=TRUE)
    invisible(lapply(object, function(x) {
        var.name <- names(eval(sys.call(1)[[2]]))[substitute(x)[[3]]]
        describe(x, var.name, na.rm)
    }))
}

describe.matrix <- function(object, na.rm=TRUE) {
    describe(as.data.frame(object), na.rm)
}

# Functions 2 --------------------------------------------

library(lme4)
library(pheatmap)

pqq <- function(pvals, alpha=0.05, add=FALSE, ...) {
  pvals <- na.omit(pvals)
  n <- length(pvals)
  exp <- -log10(1:n / n)
  obs <- -log10(sort(pvals))
  if (!add) {
    ci <- -log10(cbind(
      qbeta(alpha/2, 1:n, n - 1:n + 1),
      qbeta(1 - alpha/2, 1:n, n - 1:n + 1)
    ))
    xlim <- c(0, exp[1])
    ylim <- c(0, max(obs[1], ci[1,]))
    par(pty="s")
    matplot(exp, ci, type="l", lty=2, col="gray50",
            xlim=xlim, ylim=ylim,
            xlab=expression(Expected~~-log[10]~italic(p)),
            ylab=expression(Observed~~-log[10]~italic(p)), ...)
    abline(0, 1, col="gray25")
  }
  points(exp, obs, pch=20, ...)
  invisible(NULL)
}

response.name <- function(formula) {
  tt <- terms(formula)
  vars <- as.character(attr(tt, "variables"))[-1]
  vars[attr(tt, "response")]
}

mlm <- function(formula, data=NULL, vars) {
  Y <- get(response.name(formula))
  
  formula <- update(formula, "NULL ~ .")
  mf <- model.frame(formula, data, drop.unused.levels=TRUE)
  mm <- model.matrix(formula, mf)
  
  labs <- labels(terms(formula))
  if (missing(vars)) {
    vars <- labs
  }
  
  colnames(mm) <- sprintf("V%d", 1:ncol(mm))
  new.vars <- colnames(mm)[attr(mm, "assign") %in% match(vars, labs)]
  mm <- as.data.frame(mm)
  formula <- as.formula(sprintf("y ~ %s - 1",
                                paste0(colnames(mm), collapse=" + ")
  ))
  
  coefs <- array(NA, c(ncol(Y), length(vars), 3),
                 dimnames=list(colnames(Y), vars,
                               c("coef", "coef.se", "pval")))
  
  options(warn=2)
  
  for (i in 1:ncol(Y)) {
    mm$y <- Y[,i]
    
    model <- try(lm(formula, data=mm), silent=TRUE)
    if (inherits(model, "try-error")) {
      next
    }
    
    tmp <- try(coef(summary(model)), silent=TRUE)
    if (inherits(tmp, "try-error")) {
      next
    }
    
    for (j in 1:length(vars)) if (new.vars[j] %in% rownames(tmp)) {
      coefs[i,vars[j],"coef"] <- tmp[new.vars[j],"Estimate"]
      coefs[i,vars[j],"coef.se"] <- tmp[new.vars[j],"Std. Error"]
      coefs[i,vars[j],"pval"] <- tmp[new.vars[j],"Pr(>|t|)"]
    }
  }
  
  if (length(vars) == 1) {
    coefs <- as.data.frame(coefs[,1,])
  }
  
  coefs
}

setGeneric("VarComp", function(object) {
  standardGeneric("VarComp")
})

setMethod("VarComp", signature(object="merMod"),
          function(object) {
            vc <- VarCorr(object)
            sds <- lapply(vc, attr, which="stddev")
            data.frame(
              group=c(rep(names(sds), unlist(lapply(sds, length))), "Residual"),
              var.name=c(c(lapply(sds, names), recursive=TRUE), NA),
              var=c(c(sds, recursive=TRUE), attr(vc, "sc"))**2,
              row.names=NULL,
              stringsAsFactors=FALSE
            )
          })

setGeneric("re.rank", function(object, whichel) {
  standardGeneric("re.rank")
})

setMethod("re.rank", signature(object="merMod", whichel="missing"),
          function(object, whichel) {
            re.rank(object, names(getME(object, "flist")))
          })

setMethod("re.rank", signature(object="merMod", whichel="character"),
          function(object, whichel) {
            vc <- subset(VarComp(object),
                         group %in% whichel & var.name == "(Intercept)")
            groups <- vc$group[which(vc$var > .Machine$double.eps)]
            lapply(ranef(object)[groups], function(x) {
              structure(rank(x[,"(Intercept)"]), names=rownames(x))
            })
          })

mlmer <- function(formula, data=NULL, vars, lrt=TRUE) {
  Y <- get(response.name(formula))
  
  lf <- lFormula(update(formula, "NULL ~ ."), data, REML=FALSE,
                 control=lmerControl(check.formula.LHS="ignore"))
  
  labs <- as.character(attr(terms(lf$fr), "predvars.fixed")[-1])
  if (missing(vars)) {
    vars <- labs
  }
  
  mm <- lf$X
  colnames(mm) <- sprintf("V%d", 1:ncol(mm))
  new.vars <- colnames(mm)[which(attr(lf$X, "assign") %in% match(vars, labs))]
  formula <- as.formula(sprintf("y ~ %s - 1",
                                paste0(c(
                                  sprintf("(%s)", findbars(formula)), colnames(mm)
                                ), collapse=" + ")
  ))
  model.data <- cbind(mm, lf$reTrms$flist)
  
  coefs <- array(NA, c(ncol(Y), length(vars), 3),
                 dimnames=list(colnames(Y), vars, c("coef", "coef.se", "pval")))
  
  re.ranks <- lapply(lf$reTrms$flist, function(x) {
    tmp <- matrix(0, nlevels(x), nlevels(x),
                  dimnames=list(levels(x), 1:nlevels(x)))
    attr(tmp, "count") <- 0
    tmp
  })
  
  options(warn=2)
  
  for (i in 1:ncol(Y)) {
    model.data$y <- Y[,i]
    data.subset <- subset(model.data, !is.na(y))
    
    model <- try(lmer(formula, data=data.subset, REML=FALSE), silent=TRUE)
    if (inherits(model, "try-error")) {
      next
    }
    
    tmp <- try(coef(summary(model)), silent=TRUE)
    if (inherits(tmp, "try-error")) {
      next
    }
    
    for (j in 1:length(vars)) if (new.vars[j] %in% rownames(tmp)) {
      coefs[i,vars[j],"coef"] <- tmp[new.vars[j],"Estimate"]
      coefs[i,vars[j],"coef.se"] <- tmp[new.vars[j],"Std. Error"]
      
      if (!lrt) {
        coefs[i,vars[j],"pval"] <-
          2 * pt(abs(tmp[new.vars[j],"t value"]),
                 df=df.residual(model), lower.tail=FALSE)
      } else {
        lrt.formula <- as.formula(sprintf(". ~ . - %s", new.vars[j]))
        model0 <- try(update(model, lrt.formula), silent=TRUE)
        if (inherits(model0, "try-error")) {
          next
        }
        coefs[i,vars[j],"pval"] <-
          anova(model0, model)["model","Pr(>Chisq)"]
      }
    }
    
    ranks <- lapply(re.rank(model), function(x) {
      diag(length(x))[x,]
    })
    for (g in names(ranks)) {
      re.ranks[[g]] <- re.ranks[[g]] + ranks[[g]]
      attr(re.ranks[[g]], "count") <- attr(re.ranks[[g]], "count") + 1
    }
  }
  
  if (length(vars) == 1) {
    coefs <- as.data.frame(coefs[,1,])
  }
  
  list(coefs=coefs, re.ranks=re.ranks)
}

plot.ranks <- function(x, col="red") {
  x <- x / attr(x, "count")
  breaks <- seq(0, max(x), length.out=101)
  cols <- c(
    rep("white", sum(breaks <= 1 / ncol(x)) - 1),
    colorRampPalette(c("white", col))(sum(breaks > 1 / ncol(x)))
  )
  pheatmap(x, color=cols, breaks=breaks,
           cluster_rows=FALSE, cluster_cols=FALSE)
  invisible(NULL)
}

# Functions 3----------------------------------------------------------------


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


