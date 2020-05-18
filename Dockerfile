FROM datalabauth/covid19-base
COPY . /app
WORKDIR /app
RUN apt-get update && \
	apt-get install --yes \
		git && \
	sed -i "s|url = git@github.com:|url = https://github.com/|" \
		.git/config && \
	echo "gitdir: ../../.git/modules/data/JHU_data" > \
		data/JHU_data/.git && \
	echo "gitdir: ../../.git/modules/data/oxford_data" > \
		data/oxford_data/.git && \
	apt-get clean
CMD ["./run.sh"]

