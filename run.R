#!/usr/bin/Rscript

library(renv)
renv::restore()
shiny::runApp(host = "0.0.0.0", port = 5555, launch.browser = FALSE)
