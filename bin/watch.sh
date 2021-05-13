#!/usr/bin/env bash

echo "Watching for changes..." 
inotifywait --monitor --recursive \
  --event modify --format "%w %f" \
  ./src/ ./dist/index.html |
while read filename; do
  ./bin/elmy.sh
  ./bin/sassy.sh
done
