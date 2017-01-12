#! /bin/bash

echo "---------- Code3 installer ----------------------------------------------"
git config --global url."https://".insteadOf git://

echo "---------- Installing prereqs -------------------------------------------"
. ~/.bashrc
sudo apt-get install -y python-wstool python-catkin-tools
sudo apt-get install -y libgif-dev curl
sudo apt-get install -y ros-indigo-moveit-*

echo "---------- Installing gmock ---------------------------------------------"
mkdir ~/local
cd ~/local
git clone https://github.com/google/googletest.git
cd googletest
mkdir mybuild
cd mybuild
cmake ..
make
sudo make install

echo "---------- Creating catkin workspace ------------------------------------"
mkdir -p ~/catkin_ws_indigo/src
cd ~/catkin_ws_indigo
wstool init src
catkin init

echo "---------- Installing NVM and Node --------------------------------------"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
nvm install node
nvm install 0.10.40 # Used for the CodeIt backend.
nvm use node

echo "---------- Installing MongoDB and Meteor --------------------------------"
sudo apt-get -y install mongodb
sudo pip install pymongo --upgrade
curl https://install.meteor.com/ | sh

echo "---------- Downloading Code3 --------------------------------------------"
cd ~/catkin_ws_indigo/src
wget https://raw.githubusercontent.com/hcrlab/code3/master/pr2.rosinstall
wstool merge pr2.rosinstall
wstool up -j8
rm -rf code_it
git clone git@github.com:hcrlab/code_it.git --recursive

echo "---------- Building Code3 -----------------------------------------------"
cd ~/catkin_ws_indigo
rosdep update
rosdep install --from-paths src --ignore-src --rosdistro=indigo -y
catkin build
. ~/catkin_ws_indigo/devel/setup.bash --extend

echo "---------- Installing frontend prereqs ----------------------------------"
nvm use node
npm install -g yo bower gulp grunt-cli polymer-cli generator-polymer

 Build frontends
echo "---------- Building blinky frontend -------------------------------------"
cd ~/catkin_ws_indigo/src/blinky/frontend/
bower install && npm install
gulp

echo "---------- Building CodeIt frontend -------------------------------------"
cd ~/catkin_ws_indigo/src/code_it/frontend/app/blockly
python build.py
cd ~/catkin_ws_indigo/src/code_it/frontend/
bower install && npm install
gulp

echo "---------- Building RWS frontend ----------------------------------------"
cd ~/catkin_ws_indigo/src/rws/frontend/
bower install && npm install
gulp

echo "---------- Building custom landmarks frontend ---------------------------"
cd ~/catkin_ws_indigo/src/rws_landmarks/frontend/
bower install && npm install
polymer build

echo "---------- Building PbD actions frontend --------------------------------"
cd ~/catkin_ws_indigo/src/rws_pr2_pbd/frontend/
bower install && npm install
gulp

echo "---------- Building CodeIt backend --------------------------------------"
cd ~/catkin_ws_indigo/src/code_it/backend
nvm use 0.10.40
meteor update --release 1.2
./build.sh

git config --global --remove-section url."https://"
echo "---------- Finished! ----------------------------------------------------"
