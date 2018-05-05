#!/bin/bash
mix deps.get --only prod
cd assets
npm i
npm run deploy
cd ..
MIX_ENV=prod mix do compile, phx.digest, release --verbose