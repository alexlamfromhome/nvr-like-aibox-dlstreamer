#!/bin/bash

CONTAINER=aibox-dlstreamer-test:latest

docker build \
       -t ${CONTAINER} \
       -f Dockerfile .
