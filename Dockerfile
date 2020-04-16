FROM r-base
COPY . /app
WORKDIR /app
RUN apt-get update && \
	apt-get install --yes \
		libcurl4-openssl-dev \
		libssl-dev libxml2-dev \
		git && \
	Rscript install_libraries.R && \
	apt-get clean
CMD ["Rscript", "run.R"]

