#!/usr/bin/env bash

echo "Watching files..." 
inotifywait --monitor --recursive \
  --event modify --format "%w %f" \
  ./src/ |
while read filename; do
  
  rm -rf dist
  mkdir dist

  ./tools/make.sh
  
  ./tools/sass.sh
  
  ./tools/pages.sh
done
