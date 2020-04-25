#!/bin/bash

# this script pulls the latest data from JHU and Oxford sources, runs
# the process_data.R script to create the RDS files and launches the
# run.R script (which in turn launches the Shiny app). It also pulls the
# latest data every hour or so. It is supposed to be used from inside
# the Docker container as the default command.

pull_latest_data() {
	(
	 echo "Updating JHU data"
	 cd data/JHU_data
	 git pull origin master
	 echo "Updating Oxford data"
	 cd ../../data/oxford_data
	 git pull origin master
	 cd ../..
	 echo "Updating RDS files"
	 Rscript ./process_data.R
	)
}

pull_latest_data
(
 while true; do
	sleep 3600 # 1 hour
	pull_latest_data
 done
) &

Rscript ./run.R

