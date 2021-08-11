FROM ros:noetic-perception-focal
WORKDIR /

ADD package.list /tmp/package.list
RUN apt update>/dev/null && \
	apt install -y $(cat /tmp/package.list)>/dev/null && \
    rm -rf /var/lib/apt/lists/* && \
    pip install wxpython>/dev/null && \
    rm -rf /root/.cache/pip && \
    rm /tmp/package.list

ADD deps.rosinstall /tmp/deps.rosinstall
RUN \
    mkdir -p /catkin_ws/src && \
    cd /catkin_ws && \
    catkin init && \
	catkin config --extend /opt/ros/noetic && \
    vcs import --recursive --input /tmp/deps.rosinstall src && \
	catkin build && \
    rm /tmp/deps.rosinstall

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/bin/bash", "/entrypoint.sh" ]
CMD ["bash"]
