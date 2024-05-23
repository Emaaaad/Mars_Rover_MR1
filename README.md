# Mars Rover Domain and Problem Definition

This repository contains the PDDL (Planning Domain Definition Language) files for a Mars Rover domain, which simulates the activities of a rover on Mars. The rover is tasked with navigating between various locations, collecting data using different instruments, processing the data, and transmitting it back to the Mars station. The domain and problem files are compatible with the BFWS--FF--parser version available at [Planning Domains](https://editor.planning.domains/#).

## Author:

### [Emad Razavi](https://github.com/Emaaaad)

## Running the Code

To run the domain and problem files, use the [Planning Domains Editor](https://editor.planning.domains/#) with the BFWS--FF--parser Solver. Follow these steps:

1. Open the Planning Domains Editor.
2. Copy and paste the content of `domain.pddl` into the Domain tab that you made it already.
3. Copy and paste the content of `problem.pddl` into the Problem tab that you made it already.
4. Select the BFWS--FF--parser from the available options.
5. Run the planner to generate a plan.


## Domain Description

The `mars_rover` domain defines a variety of actions and predicates required to model the operations of a Mars rover. The rover is equipped with instruments and sensors, such as a spectrometer, camera, radar, IMU, and stereoscopic camera. The rover can perform actions such as navigating, collecting data, processing data, and transmitting data. The domain also includes actions for managing the rover's stability, manipulator arm, and instruments.

### Types

- `location`: Represents different locations on Mars.
- `rover`: Represents the Mars rover.
- `instrument`: Represents the scientific instruments on the rover.
- `sensor`: Represents the sensors used by the rover.

### Predicates

- `at(rover, location)`: Rover is at a specific location.
- `stable(rover)`: Rover is stable.
- `manipulator_extended(rover)`: Rover's manipulator arm is extended.
- `end_effector_positioned(rover)`: End effector of the rover is positioned.
- `deployed(rover, instrument)`: Instrument is deployed.
- `collected(rover, instrument, location)`: Data is collected.
- `processed(rover, instrument, location)`: Data is processed.
- `transmitted(rover, instrument, location)`: Data is transmitted.
- `instrument_needed(instrument, location)`: Instrument is needed at a location.
- `visited(rover, location)`: Rover has visited a location.
- `activated(rover, instrument)`: Instrument is activated.
- `using_imu(rover)`: Rover is using the IMU.
- `using_stereoscopic_camera(rover)`: Rover is using the stereoscopic camera.
- `mission_complete(rover)`: Mission is complete.
- `connection_established()`: Connection is established.

### Functions

- `number_reads(rover, instrument, location)`: Number of reads taken by the rover with a specific instrument at a location.
- `max_reads(location, instrument)`: Maximum reads allowed for an instrument at a location.

## Problem Description

The `mars_mission` problem file specifies an instance of the `mars_rover` domain. It includes the initial state of the rover and the goal state to be achieved. The rover starts at the Mars station and needs to collect and transmit data from various locations using different instruments.

### Objects

- `MR_1`: The Mars rover.
- `mars_station`, `loc1`, `loc2`, `loc3`: Different locations on Mars.
- `spectrometer`, `camera`, `radar`, `multispectral_camera`: Instruments on the rover.
- `imu`, `stereoscopic_camera`: Sensors on the rover.

### Initial State

The initial state includes the starting location of the rover, the instruments needed at various locations, and the maximum reads allowed for each instrument at each location.

### Goal

The goal is to transmit the collected data from all required locations, ensure the rover returns to the Mars station, and deactivate all sensors and terminate the connection.

### Metric

The objective is to minimize the total time taken to complete the mission.

## Summary

This repository provides a comprehensive model of a Mars rover mission using PDDL. It defines the actions, predicates, and functions necessary to simulate the rover's operations on Mars. The problem file specifies an instance of this domain, detailing the initial conditions and goals for the rover. By using the Planning Domains Editor, users can generate plans to achieve the mission's objectives efficiently.

Feel free to explore, modify, and extend the domain and problem definitions to suit different scenarios and challenges!

