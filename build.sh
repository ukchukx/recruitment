#!/bin/bash
mix deps.get --only prod
cd assets
npm i
./node_modules/brunch/bin/brunch build --production
cd ..
MIX_ENV=prod mix do phx.digest, release --verbose
docker build -t recruitment .