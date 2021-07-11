# Programming and S3 classes (from the Art of R programming)

print
# a call to UseMethod only
print.lm
# is the method despatched

# Fit and print an lm
x <- c(1,2,3)
y <- c(1,3,8)
lmout <- lm(y ~ x)
class(lmout)
lmout

# Remove the class attribute of lmout
unclass(lmout)
# you get all the details because print.lm is concise

# See all implementations of a generic method
methods(print)


# S3 classes
lm
# Class attributes are a list called z with variables


# Writing an S3 class
j <- list(name="Joe", salary=55000, union=T)
class(j) <- "employee"
attributes(j) # let's check


# print j without a method
j
# Treated as a list for printing purposes. Now write a print method for j

print.employee <- function(wrkr) {
  cat(wrkr$name, "\n")
  cat("salary", wrkr$salary, "\n")
  cat("union member", wrkr$union, "\n")
}

# Our employee is now printed neatly
j

# Inheritance: a more specialised class that inherits properties
# Hourly paid employee class
k <- list(name="Kate", salary= 68000, union=F, hrsthismonth= 2)
class(k) <- c("hrlyemployee","employee")
k

# UseMethod doesn't find hrlyemployee but finds employee.
# S4: more complex classes that favour safety

# Object management

ls()
ls(pattern="out")

# Remove specific objects
rm(list = ls(pattern = "out"))

# Find if an object exists
exists("mat")



