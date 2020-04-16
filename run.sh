#!/bin/bash

export OXFORD_DATA_URL="https://www.bsg.ox.ac.uk/sites/default/files/OxCGRT_Download_latest_data.xlsx"

pull_JHU_data() {
	echo "Updating JHU data"
	git pull
}

download_oxford_data() {
	echo "Downloading oxford data..."
	wget -qq $OXFORD_DATA_URL -O data/oxford_data_new.xlsx
	if [[ $? -eq 0 ]]; then
		diff data/oxford_data_new.xlsx data/oxford_data.xlsx > /dev/null
		if [[ $? -eq 0 ]]; then
			echo "Oxford data not updated."
		else
			echo "Oxford data has been updated. Replacing."
			mv data/oxford_data_new.xlsx data/oxford_data.xlsx
		fi
	else
		echo "Error downloading Oxford data." >&2
	fi
}

cd data/JHU_data
pull_JHU_data
cd ../..
download_oxford_data

(
 cd data/JHU_data
 while true; do
	sleep 3600 # 1 hour
	pull_JHU_data
 done
) &

(
 while true; do
	sleep 14400 # 4 hours
	download_oxford_data
 done
) &

Rscript ./run.R

