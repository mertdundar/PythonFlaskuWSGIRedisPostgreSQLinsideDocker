#!/bin/sh
# run in dev mode

winpty docker run -it --rm --name restpie-dev -p 8100:80 -v `pwd`/:/app/ restpie-dev-image

