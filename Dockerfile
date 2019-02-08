FROM elixir:1.8

WORKDIR /home/app
COPY . /home/app

COPY alertlytics-config.json /etc/alertlytics/config.json