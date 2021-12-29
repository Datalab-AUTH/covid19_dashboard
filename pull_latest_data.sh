#!/bin/bash

# this script pulls the latest data from JHU and Oxford sources

get_data() {
	URL=$1
	FILENAME=`basename $URL`
	rm -f new_data
	wget -nv $URL -O new_data && \
		mv new_data $FILENAME
}


cd data
echo "Updating JHU data"
JHU_DATA_DIR=https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series
get_data $JHU_DATA_DIR/time_series_covid19_confirmed_global.csv
get_data $JHU_DATA_DIR/time_series_covid19_deaths_global.csv
get_data $JHU_DATA_DIR/time_series_covid19_recovered_global.csv
get_data $JHU_DATA_DIR/time_series_covid19_confirmed_US.csv
get_data $JHU_DATA_DIR/time_series_covid19_deaths_US.csv
echo "Updating Oxford data"
get_data https://raw.githubusercontent.com/OxCGRT/covid-policy-tracker/master/data/OxCGRT_latest.csv
cd ..
