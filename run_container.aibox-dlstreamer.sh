#!/bin/bash

CONTAINER=aibox-dlstreamer-test:latest
	    
DEVICE=/dev/dri/renderD128
DEVICE_GRP=$(ls -g $DEVICE | awk '{print $3}' | \
		 xargs getent group | awk -F: '{print $3}')

mkdir -p output
chmod 777 output

docker run -ti --rm \
       -e DISPLAY=:0 ${ENTRYPOINT} \
       -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
       -v ${HOME}/.Xauthority:/home/aibox/.Xauthority:ro \
       -v $(pwd)/videos:/home/aibox/videos \
       -v ${HOME}/models:/home/aibox/models:ro \
       -v $(pwd)/entrypoint.sh:/home/aibox/entrypoint.sh:ro \
       -v $(pwd)/output:/home/aibox/output \
       --device /dev/dri \
       --group-add ${DEVICE_GRP} \
       ${CONTAINER} $* 