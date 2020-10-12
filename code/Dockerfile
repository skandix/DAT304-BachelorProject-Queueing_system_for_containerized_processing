FROM debian:stretch

RUN apt-get update && apt-get install -y \
	python3 \
	&& touch index.html \
	&& echo "Hello World, From inside a docker container" | tee index.html \

CMD ["python3", "-m", "http.server", "80"]

EXPOSE 80