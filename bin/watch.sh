#!/usr/bin/env bash

echo "Watching for changes..." 
inotifywait --monitor --recursive \
  --event modify --format "%w %f" \
  ./src/ ./src/index.html |
while read filename; do
  ./bin/elmy.sh
  ./bin/sassy.sh
  ./bin/getAppFromDist.sh
done
