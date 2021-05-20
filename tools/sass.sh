#!/usr/bin/env bash

# Recompile styles
echo "Compiling css now."  
sass --no-source-map ./src/styles/index.scss ./dist/style.css |
# TODO: Add an error check before echo says "success"
echo "CSS compiled successfully."
