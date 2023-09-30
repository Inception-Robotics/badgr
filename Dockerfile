FROM nvidia/cuda:11.2.2-cudnn8-devel-ubuntu16.04
RUN apt-get update && \
    apt-get install -y git && \
    apt-get install -y vim && \
    apt-get install -y wget && \
    apt-get install -y lsb-release

# Installing ROS Kinetic
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    apt install -y curl && \
    curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - && \
    apt-get update && \
    apt-get install -y ros-kinetic-desktop-full && \
    echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc && \
    apt install -y python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential && \
    apt install -y python-rosdep && \
    rosdep init && \
    rosdep update

# Install mini conda 
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
WORKDIR /
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN chmod +x Miniconda3*
RUN bash Miniconda3* -b
RUN conda init

RUN echo "Hello"
# Create badgr package and build it
RUN mkdir -p /opt/badgr_ws/src
WORKDIR /opt/badgr_ws/src/
RUN git clone https://github.com/Inception-Robotics/badgr.git
WORKDIR /opt/badgr_ws/
RUN . /opt/ros/kinetic/setup.sh && catkin_make
WORKDIR /opt/badgr_ws/src/badgr/conda/
RUN conda env create -f badgr.yml
WORKDIR /opt/badgr_ws/


