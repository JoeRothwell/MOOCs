

# Install haven (only once)
install.packages("haven")

# load package
library(haven)

# read data (data must be in project folder)
data <- read_dta("clrt_caco.dta")


# to find out where your project folder is
getwd()