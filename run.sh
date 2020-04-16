#!/bin/bash

cd data/JHU_data
git pull
cd ../..

(
 cd data/JHU_data
 while true; do
	git pull
	sleep 3600
 done
) &

Rscript ./run.R

