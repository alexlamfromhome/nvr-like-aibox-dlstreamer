#!/bin/bash

NUM_PANES=${1:-9}
AI_CHANNELS=${2:-9}
VIDEO_IN=${3:-videos/cars-on-highway.1920x1080.mp4}

source /opt/intel/dlstreamer/setupvars.sh 
source /opt/intel/openvino_2022/setupvars.sh

SSDLITE=/home/aibox/models/public/ssdlite_mobilenet_v2/FP16/ssdlite_mobilenet_v2.xml
SSDLITE_LABEL="labels=/home/aibox/models/public/ssdlite_mobilenet_v2/coco_91cl_bkgr.txt"

RES_WIDTH=1920
RES_HEIGHT=1080
#NUM_PANES=9
PANE_WIDTH=0
PANE_HEIGHT=0

case ${NUM_PANES} in
    1)
	PANE_WIDTH=$((${RES_WIDTH}/2))
	PANE_HEIGHT=$((${RES_HEIGHT}/2))
	;;
    2|3|4)
	PANE_WIDTH=$((${RES_WIDTH}/2))
	PANE_HEIGHT=$((${RES_HEIGHT}/2))
	;;
    5|6|7|8|9)
	PANE_WIDTH=$((${RES_WIDTH}/3))
	PANE_HEIGHT=$((${RES_HEIGHT}/3))
	;;
    10|11|12|13|14|15|16)
	PANE_WIDTH=$((${RES_WIDTH}/4))
	PANE_HEIGHT=$((${RES_HEIGHT}/4))
	;;
    *)
        echo "NUM_PANES must be between 1 to 16 inclusive!"
	exit -1
	;;
esac
	
function compositor(){
    case ${NUM_PANES} in
	1)
	echo " vaapioverlay name=comp0 \
        \
    	sink_0::xpos=0                    sink_0::ypos=0                 sink_0::alpha=1 "
	;;

	2|3|4)
        echo " vaapioverlay name=comp0 \
        \
        sink_0::xpos=0                    sink_0::ypos=0                 sink_0::alpha=1 \
        sink_1::xpos=$((${PANE_WIDTH}*1)) sink_1::ypos=0                 sink_1::alpha=1 \
        sink_2::xpos=0                    sink_2::ypos=$((${PANE_HEIGHT}*1)) sink_2::alpha=1 \
        sink_3::xpos=$((${PANE_WIDTH}*1)) sink_3::ypos=$((${PANE_HEIGHT}*1)) sink_3::alpha=1 "
	;;
	
	5|6|7|8|9)
        echo " vaapioverlay name=comp0 \
        \
        sink_0::xpos=0                    sink_0::ypos=0                 sink_0::alpha=1 \
        sink_1::xpos=$((${PANE_WIDTH}*1)) sink_1::ypos=0                 sink_1::alpha=1 \
        sink_2::xpos=$((${PANE_WIDTH}*2)) sink_2::ypos=0                 sink_2::alpha=1 \
        \
        sink_3::xpos=0                    sink_3::ypos=$((${PANE_HEIGHT}*1)) sink_3::alpha=1 \
        sink_4::xpos=$((${PANE_WIDTH}*1)) sink_4::ypos=$((${PANE_HEIGHT}*1)) sink_4::alpha=1 \
        sink_5::xpos=$((${PANE_WIDTH}*2)) sink_5::ypos=$((${PANE_HEIGHT}*1)) sink_5::alpha=1 \
        \
        sink_6::xpos=0                    sink_6::ypos=$((${PANE_HEIGHT}*2)) sink_6::alpha=1 \
        sink_7::xpos=$((${PANE_WIDTH}*1)) sink_7::ypos=$((${PANE_HEIGHT}*2)) sink_7::alpha=1 \
        sink_8::xpos=$((${PANE_WIDTH}*2)) sink_8::ypos=$((${PANE_HEIGHT}*2)) sink_8::alpha=1 "
	;;

	10|11|12|13|14|15|16)
        echo " vaapioverlay name=comp0 \
        \
        sink_0::xpos=0                    sink_0::ypos=0                 sink_0::alpha=1 \
        sink_1::xpos=$((${PANE_WIDTH}*1)) sink_1::ypos=0                 sink_1::alpha=1 \
        sink_2::xpos=$((${PANE_WIDTH}*2)) sink_2::ypos=0                 sink_2::alpha=1 \
        sink_3::xpos=$((${PANE_WIDTH}*3)) sink_3::ypos=0                 sink_3::alpha=1 \
        \
        sink_4::xpos=0                    sink_4::ypos=$((${PANE_HEIGHT}*1)) sink_4::alpha=1 \
        sink_5::xpos=$((${PANE_WIDTH}*1)) sink_5::ypos=$((${PANE_HEIGHT}*1)) sink_5::alpha=1 \
        sink_6::xpos=$((${PANE_WIDTH}*2)) sink_6::ypos=$((${PANE_HEIGHT}*1)) sink_6::alpha=1 \
        sink_7::xpos=$((${PANE_WIDTH}*3)) sink_7::ypos=$((${PANE_HEIGHT}*1)) sink_7::alpha=1 \
        \
        sink_8::xpos=0                    sink_8::ypos=$((${PANE_HEIGHT}*2)) sink_8::alpha=1 \
        sink_9::xpos=$((${PANE_WIDTH}*1)) sink_9::ypos=$((${PANE_HEIGHT}*2)) sink_9::alpha=1 \
        sink_10::xpos=$((${PANE_WIDTH}*2)) sink_10::ypos=$((${PANE_HEIGHT}*2)) sink_10::alpha=1 \
        sink_11::xpos=$((${PANE_WIDTH}*3)) sink_11::ypos=$((${PANE_HEIGHT}*2)) sink_11::alpha=1 \
                \
        sink_12::xpos=0                    sink_12::ypos=$((${PANE_HEIGHT}*3)) sink_12::alpha=1 \
        sink_13::xpos=$((${PANE_WIDTH}*1)) sink_13::ypos=$((${PANE_HEIGHT}*3)) sink_13::alpha=1 \
        sink_14::xpos=$((${PANE_WIDTH}*2)) sink_14::ypos=$((${PANE_HEIGHT}*3)) sink_14::alpha=1 \
        sink_15::xpos=$((${PANE_WIDTH}*3)) sink_15::ypos=$((${PANE_HEIGHT}*3)) sink_15::alpha=1 "
	;;
esac
}

#pipeline="vaapioverlay name=comp0 \
#         sink_0::xpos=0                    sink_0::ypos=0                 sink_0::alpha=1 \
#         sink_1::xpos=$((${PANE_WIDTH}*1)) sink_1::ypos=0                 sink_1::alpha=1 \
#         sink_2::xpos=0                    sink_2::ypos=$((${PANE_HEIGHT}*1)) sink_2::alpha=1 \
#         sink_3::xpos=$((${PANE_WIDTH}*1)) sink_3::ypos=$((${PANE_HEIGHT}*1)) sink_3::alpha=1 ! "

pipeline="$(compositor) ! "
pipeline+=" gvafpscounter ! "
pipeline+=" fpsdisplaysink video-sink=xvimagesink sync=false "
#pipeline+="vaapih264enc ! h264parse ! splitmuxsink async-finalize=true location=output/compose_%02d.mp4 "


function add_channel() {
    channel_number=${1}
    num_ai_channels=${2:-0}
    channel="filesrc location=${VIDEO_IN} ! "
    channel+="decodebin ! video/x-raw(memory:VASurface) ! "

    channel+="tee name=t_${channel_number} ! "
    channel+="queue name=queue_record_${channel_number} ! vaapih264enc ! h264parse ! "
    channel+="splitmuxsink async-finalize=true location=output/ch${channel_number}_%02d.mp4 max-size-time=10000000000 "

    channel+="t_${channel_number}. ! queue name=queue_detect_${channel_number} ! "
    if [[ ${channel_number} -lt ${num_ai_channels} ]]; then
        channel+="gvadetect model=${SSDLITE} ${SSDLITE_LABEL} "
        #channel+="model-instance-id=od1 " Causing hang with multiple gvadetect
        channel+="ie-config=CACHE_DIR=/tmp/cl_cache " #No cl_cache output?!
        channel+="nireq=2 batch-size=4 "
        channel+="pre-process-backend=vaapi-surface-sharing device=GPU ! "
        channel+="gvawatermark ! "
    fi
    channel+="vaapipostproc ! video/x-raw,width=${PANE_WIDTH},height=${PANE_HEIGHT} "
    echo ${channel}
}


for i in `seq 0 $((${NUM_PANES}-1))`; do
    pipeline+="$(add_channel ${i} ${AI_CHANNELS} ) ! "
    pipeline+="queue ! "
    pipeline+="comp0.sink_${i} "
done

echo ${pipeline}

gst-launch-1.0 ${pipeline}

exit

#gst-launch-1.0 filesrc location=videos/cars-on-highway.1920x1080.mp4 ! \
#	       decodebin ! video/x-raw\(memory:VASurface\) ! \
#	       gvadetect model=${SSDLITE} ${SSDLITE_LABEL} \
#	       pre-process-backend=vaapi-surface-sharing device=GPU ! \
#	       gvawatermark ! \
#	       gvafpscounter ! \
#	       fpsdisplaysink video-sink=xvimagesink


#
#gst-launch-1.0 filesrc location=videos/cars-on-highway.1920x1080.mp4 ! \
#	       tee name=t ! queue ! qtdemux ! \
#	       splitmuxsink location=output/output%02d.mp4 max-size-time=10000000000 \
#	       t. ! decodebin ! video/x-raw\(memory:VASurface\) ! \
#	       gvadetect model=${SSDLITE} ${SSDLITE_LABEL} model-instance-id=od1 \
#	       pre-process-backend=vaapi-surface-sharing device=GPU ! \
#	       gvawatermark ! \
#	       gvafpscounter ! \
#	       fpsdisplaysink video-sink=xvimagesink
