#! /bin/bash
#
# Install the system dependencies required to build TerrainRL
#
# sudo add-apt-repository ppa:oibaf/graphics-drivers
sudo apt-get install libleveldb-dev libsnappy-dev -y
sudo apt-get install --no-install-recommends libboost-all-dev -y
sudo apt-get install libgflags-dev libgoogle-glog-dev -y
sudo apt-get install libatlas-base-dev -y
# sudo apt-get install gcc-4.9-multilib g++-4.9-multilib -y
sudo apt-get install libf2c2-dev -y
sudo apt-get install libglew-dev freeglut3 freeglut3-dev -y
sudo apt-get install libglfw3-dev libgles2-mesa-dev -y
sudo apt-get install premake4 -y
sudo apt-get install swig3.0 python3-dev python3-pip -y
