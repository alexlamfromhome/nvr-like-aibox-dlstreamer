# NVR-like Multi Channel Object Detection based on aibox-dlstreamer 

![](./Screenshot%20from%202023-09-28%2015-26-02.png)

## Prerequisite
AI Box 3.0 installed with:
* aibox-dlstreamer:3.0
* aibox-base-devel:3.0

## Setup
Download ssdlite_mobilenet_v2 from OMZ using ```aibox-base-devel:3.0```

```
mkdir $HOME/models
docker run -ti --rm -v $HOME/models:/home/aibox/models aibox-base-devel:3.0
omz_download -o /home/aibox/models --name ssdlite_mobilenet_v2
omz_convert -o /home/aibox/models -d /home/aibox/models --name ssdlite_mobilenet_v2
```

Download video from pexels

```
mkdir videos
curl -L -o videos/cars-on-highway.1920x1080.mp4 https://www.pexels.com/download/video/854671/?h=1080&w=1920
``````

Build a container with
```
./build_container.sh
``` 

## Run
```
./run_container.aibox-dlstreamer.sh
```
NOTE: It takes ~2mins to build model for GPU on ADL-N

## Todo
* Incorporate model download logic into ```Dockerfile```
* Fix ```compose.yml```