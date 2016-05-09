FROM ubuntu:latest

RUN apt-get -y update
RUN apt-get -y install git
RUN apt-get -y install mongodb
RUN apt-get -y install python3
RUN apt-get -y install build-essential
RUN apt-get -y install nodejs
