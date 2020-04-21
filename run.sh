#!/bin/bash

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

