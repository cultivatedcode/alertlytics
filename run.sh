#!/bin/sh
cd assets && npm install && node node_modules/webpack/bin/webpack.js --mode development
cd ..
mix deps.get
mix format
# mix run --no-halt
iex -S mix phx.server
