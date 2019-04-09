
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

