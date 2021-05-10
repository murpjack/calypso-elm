#!/usr/bin/env bash

# Recompile styles
echo "Sass file(s) modified"
echo "Compiling css now."  
sass ./src/styles/index.scss ./dist/styles/index.css |
echo "CSS compiled successfully."
