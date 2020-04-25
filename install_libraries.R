#!/usr/bin/Rscript

# this script is used to install necessary libraries in a new system (or
# a docker image)

install.packages("renv")
library(renv)
renv::restore()

