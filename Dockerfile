FROM esycat/java

RUN apt-get update
#RUN apt-get install python-software-properties
#RUN add-apt-repository ppa:webupd8team/java
#RUN apt-get update
#RUN sudo apt-get install oracle-java8-installer
RUN apt-get install -y python

COPY spark-1.6.3-bin-hadoop2.6.tgz /
RUN tar -xzvf spark-1.6.3-bin-hadoop2.6.tgz
RUN mv spark-1.6.3-bin-hadoop2.6 spark

WORKDIR /spark

RUN mkdir /spark/app
COPY bigram-count.py /spark/app/bigram-count.py
COPY .input.tmp /spark/app/input.txt
