#!/bin/bash

# this script pulls the latest data from JHU and Oxford sources, runs
# the process_data.R script to create the RDS files and launches the
# run.R script (which in turn launches the Shiny app). It also pulls the
# latest data every hour or so. It is supposed to be used from inside
# the Docker container as the default command.


pull_data() {
	./pull_latest_data.sh
	Rscript ./process_data.R
)

pull_data
(
 while true; do
	sleep 3600 # 1 hour
	pull_data
 done
) &

Rscript ./run.R

