FROM r-base
COPY . /app
WORKDIR /app
RUN apt-get update && \
	apt-get install --yes \
		libcurl4-openssl-dev \
		libssl-dev libxml2-dev \
		git && \
	sed -i "s|url = git@github.com:|url = https://github.com/|" \
		.git/config && \
	echo "gitdir: ../../.git/modules/data/JHU_data" > \
		data/JHU_data/.git && \
	echo "gitdir: ../../.git/modules/data/oxford_data" > \
		data/oxford_data/.git && \
	Rscript ./install_libraries.R && \
	apt-get clean
CMD ["./run.sh"]

