#!/bin/bash

docker build -t shiny-mmm .
docker run -p 3838:3838 shiny-mmm