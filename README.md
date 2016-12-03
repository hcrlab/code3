# Code3
Code3 is a robot programming system for mobile manipulators.

## Installation
Code3 consists of three components: CustomLandmarks, CustomActions, and CodeIt.
It evolved as a synthesis of multiple codebases, so installing it is currently an involved process.
In the future, we hope to streamline the process.

Code3 runs on web browsers using the Robot Web Server (RWS) framework.
RWS is a server and a frontend that allows you to create and upload "apps" to your robot.
Each of the components of Code3 is a separate app on RWS.

### Preliminaries
Code3 runs on ROS Indigo.
These instructions assume you already have ROS installed and have a catkin workspace in `~/catkin_ws_indigo`.

We recommend using [wstool](http://wiki.ros.org/wstool) and [catkin_tools](https://catkin-tools.readthedocs.io/en/latest/) with ROS.
```
sudo apt-get install python-wstool
sudo apt-get install python-catkin-tools
cd catkin_ws_indigo
wstool init src
catkin init
```

Next, install Node.js.
We recommend using [nvm](https://github.com/creationix/nvm), because running CodeIt requires juggling two versions of Node.
```
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash
nvm install node
nvm install 0.10.40 # Used for the CodeIt backend.
nvm use node
```

### Install the software
Copy the `pr2.rosinstall` into the `src` directory of your catkin workspace, then run `wstool up -j8`.
This downloads all of the code for Code3, plus some other stuff that is not strictly necessary (again, we hope to streamline this in the future).

Next, run `rosdep` to install the needed dependencies:
```
cd catkin_ws_indigo
rosdep update
rosdep install --from-paths src --ignore-src --rosdistro=indigo -y
```

Finally, we can compile the code.
This should take a few minutes:
```
catkin build
```

### Configure Robot Web Server (RWS)
The [RWS Wiki](https://github.com/hcrlab/rws/wiki) has instructions on how to configure RWS.
Make sure to build the frontend using `gulp`.
As part of the .rosinstall file, you already downloaded some RWS apps.
In this case, just configure the "RWS workspace" to be the same as your normal catkin workspace (`~/catkin_ws_indigo`).

### Build the web frontends
All of our web frontends are built with Polymer.
They all manage their dependencies using bower.
Some of these apps were built using the Polymer Starter Kit, while some of them were built with the newer Polymer CLI.
To make sure you have all the tools available, run:
```
nvm use node
npm install -g yo bower gulp grunt-cli polymer-cli generator-polymer
```

The procedure to build each web application is the same:
```
cd frontend
bower install && npm install
gulp
```

If this fails because there is no gulpfile, then the app was built with the newer Polymer CLI, so the procedure is slightly different:
```
cd frontend
bower install && npm install
polymer build
```

Here are all the web applications you need to run this process for:
- blinky
- code_it
- rws (if you haven't already)
- rws_landmarks
- rws_pr2_pbd

### CodeIt
CodeIt has a backend written with Meteor (a Node.js framework) that needs to be build separately.
[See the CodeIt README for installation instructions.](https://github.com/hcrlab/code_it)
Note that building the CodeIt *backend* requires Node v0.10.40, while building the CodeIt *frontend* requires any recent version of Node (e.g., 5+).
This is why we recommended using `nvm` to easily swap between versions of Node.

You should have already installed an implementation of the CodeIt API for the PR2 (`code_it_pr2`).
Support for the Fetch robot is forthcoming.
You can also use CodeIt with the Turtlebot 2, see [code_it_turtlebot](https://github.com/hcrlab/code_it_turtlebot).
