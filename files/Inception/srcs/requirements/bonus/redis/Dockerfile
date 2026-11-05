FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && \
	apt-get install redis -y

COPY tools/redisConf.sh redisConf.sh

RUN chmod +x redisConf.sh


ENTRYPOINT ["./redisConf.sh"]

