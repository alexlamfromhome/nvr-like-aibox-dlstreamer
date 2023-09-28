FROM aibox-dlstreamer:3.0

USER root
RUN apt update
RUN apt upgrade -y
RUN apt install -y intel-oneapi-compiler-dpcpp-cpp-runtime

USER aibox

COPY --chown=aibox:aibox --chmod=755 entrypoint.sh /home/aibox/entrypoint.sh

ENTRYPOINT [ "/home/aibox/entrypoint.sh" ]
