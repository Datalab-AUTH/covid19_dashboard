FROM datalabauth/covid19-base
COPY . /app
WORKDIR /app
CMD ["./run.sh"]

