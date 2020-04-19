#!/bin/bash

pull_JHU_data() {
	echo "Updating JHU data"
	git pull
}

pull_oxford_data() {
	echo "Updating Oxford data"
	git pull
}

cd data/JHU_data
pull_JHU_data
cd data_oxford_data
pull_oxford_data

(
 cd data/JHU_data
 while true; do
	sleep 3600 # 1 hour
	pull_JHU_data
 done
) &

(
 cd data/oxford_data
 while true; do
	sleep 14400 # 4 hours
	pull_oxford_data
 done
) &

Rscript ./run.R

