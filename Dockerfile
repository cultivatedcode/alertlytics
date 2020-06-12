FROM elixir:1.10

WORKDIR /home/app
COPY . /home/app

RUN apt-get update -y
RUN apt-get install -y npm nodejs

COPY alertlytics-config.json /etc/alertlytics/config.json