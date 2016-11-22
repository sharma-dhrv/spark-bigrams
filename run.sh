#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Computes bigram count statistics for a given text file."
    echo "Usage: $0 <Input File>"
    exit 1
fi

input_file="$1"

cp $input_file .input.tmp

if [ ! -e "spark-1.6.3-bin-hadoop2.6.tgz" ]; then
    printf "Fetching Apache Spark...\n"
    wget http://www-us.apache.org/dist/spark/spark-1.6.3/spark-1.6.3-bin-hadoop2.6.tgz
fi

printf "Creating Image...\n"
docker build -t spark .

printf "Starting Spark node...\n"
docker run -itd --name spark-node spark
printf "Container started with name 'spark-node'\n"

printf "\nRunning Bigram Count...\n"
docker exec -it spark-node ./bin/spark-submit --master local[2] app/bigram-count.py > /dev/null 2>&1

printf "\n\nOutput:\n"
docker exec -it spark-node cat ./app/output.txt

printf "\n\nStopping and cleaning up...\n"

docker stop spark-node
docker rm -f spark-node
docker rmi spark

rm .input.tmp

printf "\nDone. Bye!\n"

exit 0
