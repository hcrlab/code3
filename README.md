# Code3
Code3 is a robot programming system for mobile manipulators.
It currently runs on ROS Indigo for the PR2 and the Turtlebot.

## Installation
See the [Installation](https://github.com/hcrlab/code3/wiki/Installation) page on the wiki.

## Running
To run the system, start RWS by running `python development_server.py` (inside the RWS src directory).
This should start the robot (or simulated robot) as configured in your RWS secrets.py.

Next, start CustomLandmarks in its own terminal:
```
roslaunch rapid_perception object_search.launch --screen
```

Make sure to pass in `--screen`.
When you create a custom landmark, this process will prompt you to type in a name via standard input.
In the future, we hope to create a better interface for naming landmarks so that CustomLandmarks can be rolled into its own launch file.

Run the PbD frontend, which includes a visualization of CustomLandmarks and PbD, with:
```
roslaunch pr2_pbd_interaction pbd_frontend.launch
```

Finally, click on the **PbD actions** app in the side menu to start CustomActions.
Then, middle-click on the **CodeIt!** app to open CodeIt in a new tab.
