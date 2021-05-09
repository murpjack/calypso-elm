#!/usr/bin/env bash
# TODO: Run Parallel

echo "Watching for Elm file changes..." ; 
elm-live src/Main.elm --hot

# echo "Watching for sass file changes..." ; 
# inotifywait -q --recursive -m \
#   --event modify --format '%w %f' \
#   "./src/styles/" |
# while read filename event; 
# do
#   echo "Sass file(s) modified";
#   # Compile sass to dist folder.  
#   sass ./src/styles/index.scss ./dist/styles/index.css
#   # elm reactor
# done