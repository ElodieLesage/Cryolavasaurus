# Overview

CRYOLAVASAURUS is a scientific modeling toolkit designed to simulate cryovolcanic activity at Europa and its observable signatures, with potential applications to other Ocean Worlds. The project includes a series of MATLAB scripts that model different physical, geological, thermal, and compositional components of this process, as well as data inputs and visual outputs.


# Project Structure

The project files are organized as follows:

## Main Scripts: 
The core MATLAB files for running the model are found in this directory. The key scripts include:

• resInput.m: The main entry point for running the model. Used to set the relevant model parameters and call main.m for each single model case.

• main.m: This script orchestrates the entire simulation for each model case by initializing the model, running the thermal solver, managing reservoir emplacement, and calling other necessary functions.

• plotComp.m, plotComp_paperFormat.m: Scripts for generating plots of the simulation results. These scripts are useful for visualizing the compositional evolution and comparing different model scenarios.

## Input: 
Folder containing input files used by the model, such as resInput_CM.m, which define the parameters for different simulations (e.g., reservoir thickness, depth, temperature conditions). The repository on GitHub contains all the input files used to obtain the results presented in Lesage et al. (2025). If one disires, they can modify the input parameters and generate their own input files. The following scripts allow batch generation of input files:

• GenerateInputs.m: Generates a set of input files to allow running resInput for a range of reservoir properties, such as reservoir thickness and depth. This script allows users to easily create a wide range of scenarios for exploration. It is intended to provide the input files to BathModelRuns.m.

• BatchModelRuns.m: Used for executing multiple model runs in batch mode. It iterates over different input conditions by reading subdirectories in the Input directory, enabling automated exploration of multiple scenarios.

## Input Data File:
•CompData.xlsx: Contains compositional data used by the model. This file is accessed by scripts such as getCompData.m to initialize and configure material properties. Compositional data is extracted from Naseem et al. (2023), who themselves used compositions from Melwani Daswani et al. (2021).

## Initialization and Setup:
• initialize.m: A high-level script used to initialize the model, calling various sub-functions to set up grids, materials, and initial conditions.

• initializeGrid.m: Initializes the spatial grid used in simulations, defining nodes and mesh resolution.

• initializeMaterials.m, initializeThermal.m: Set up material and thermal properties for the simulation, preparing the environment for model execution.

• initializeOutputs.m: Used for the initialization of tracked output variables stored by outputManager.m. 

• reservoirEmplacement.m: Handles the emplacement of a cryovolcanic reservoir. It determines when a reservoir is emplaced and updates relevant properties, such as temperature and melt fraction, accordingly.


## Thermal and Physical evolution:
• thermalSolver.m: Solves the spherical heat diffusion equation using an explicit finite difference approach. This function also considers effects like tidal heating and manages the phase change processes.

• meltingFreezing.m: Manages the melting and freezing processes within the simulation, ensuring accurate thermal evolution based on energy changes.

• tidalHeating.m: Calculates the tidal heating contributions based on the body's properties and tidal forces.

• getThermalProperties.m: Retrieves thermal properties required by the model, such as specific heat and conductivity. It is called by the thermal solver.

• Eruption.m: Tracks the freezing induced overpressure in the reservoir and returns whether an eruption takes place or not. 

• convection.m: Computes thermal convection effects, which are crucial for understanding the heat transfer in cryovolcanic systems.

## Utility Functions:
• getBodyParameters.m: Provides parameters for different celestial bodies, such as density and gravitational acceleration.

• getTimestep.m: Determines the appropriate time step for stable numerical simulations based on the Courant condition.

• outputManager.m: Manages the output of simulation data, ensuring results are saved correctly at different stages of the model run.


## Output: 
Folder containing output files generated by the simulations, storing key results and graphical outputs for analysis. Total run time varies strongly with input parameters. Shallow reservoirs freeze faster and the simulations might only take a few minutes to run. Deep, large reservoirs have longer evolution time scales and simulations can take a few hours to run on a regular machine.

## Output Data File:
• CompData.xlsx: Provides compositional data for various materials involved in the simulation. This file is accessed by different scripts to initialize material properties.


# Installation and Requirements

## Simply clone the repository:
	git clone https://github.com/ElodieLesage/Cryolavasaurus.git
No further installation or procedure is required.

## MATLAB
The scripts and functions have been developed and tested in MATLAB 2024a and may require specific toolboxes for numerical analysis and plotting. The software was successfully tested on both Mac OSX and Windows machines.

## Running the Model
1- Set Up Inputs: Optionally use GenerateInputs.m to generate batch input files, or modify existing input files in the Input directory.
2- Run the Simulation: Execute resInput.m for a singular model, or BatchModelRuns.m for a batch of models, from within MATLAB. The main.m script will execute all the model functions in the right order.
3- Visualize Results: Use plotComp.m to visualize the results. These scripts generate plots to compare compositional evolution and analyze the outcomes of the simulations.


# License

This project is licensed under the terms specified in the LICENSE file.


# Contact Information
• Authors: Elodie Lesage, Samuel Howell, Julia Miller

• elodie.lesage@jpl.nasa.gov
