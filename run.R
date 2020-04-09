#!/usr/bin/Rscript

library(renv)
renv::restore()
shiny::runApp(port = 5555, launch.browser = FALSE)
