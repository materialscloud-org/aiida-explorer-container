#!/bin/bash
TMPVAR=${AIIDA_REST_API:-"http://127.0.0.1:5000/api/v2"}
docker build --build-arg AIIDA_REST_API=${TMPVAR} -t aiida-explorer:latest . 
