# application/db-seed/Dockerfile
FROM mongo:7

ARG HOST=mongodb
ARG PORT=27017

ENV HOST=${HOST}
ENV PORT=${PORT}

WORKDIR /seed
COPY initialLoad.csv /seed/initialLoad.csv
COPY wait-for-it.sh /seed/wait-for-it.sh

RUN chmod +x /seed/wait-for-it.sh

# Mongo hazır olunca CSV'yi içeri aktar
CMD ["/bin/bash", "-c", "/seed/wait-for-it.sh $HOST $PORT && \
  mongoimport --host $HOST:$PORT --db dobook --collection books \
  --type csv --file /seed/initialLoad.csv --headerline --drop"]
