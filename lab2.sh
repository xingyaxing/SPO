#!/bin/bash

mkdir -p lab2 && cd lab2
git clone https://github.com/popcorn-official/popcorn-desktop
cd popcorn-desktop

yarn config set yarn-offline-mirror ./node_modules/
yarn install --ignore-engines
yarn build
yarn start

