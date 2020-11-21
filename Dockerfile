FROM elixir:1.10-alpine

WORKDIR /home/app
COPY . /home/app

RUN apk add --update nodejs nodejs-npm

COPY alertlytics-config.json /etc/alertlytics/config.json