#!/usr/bin/env bash

# Recompile styles
echo "Sass file(s) modified"
echo "Compiling css now."  
sass --sourcemap=none ./src/Styles/index.scss ./dist/style.css |
echo "CSS compiled successfully."
