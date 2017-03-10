#!/usr/bin/env bash

curl \
  -F "file=@/home/ryuk/lfreneda/work/open-source/poc-node-upload/bin/.data/file.jpg" \
  localhost:3000/upload