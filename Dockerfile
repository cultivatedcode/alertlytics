FROM elixir:1.8

WORKDIR /home/app
COPY . /home/app

COPY sitrep-config.json /etc/sitrep/config.json