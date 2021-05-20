#!/usr/bin/env bash

# Recompile Elm
echo "Compiling Elm changes now." 
elm make src/elm/Main.elm --output dist/elm.js