#!/usr/bin/env bash

echo "Watching files..." 
inotifywait --monitor --recursive \
  --event modify --format "%w %f" \
  ./src/ |
while read filename; do
  ./bin/elmy.sh
  ./bin/sassy.sh
  ./bin/copyAppToDist.sh
done
