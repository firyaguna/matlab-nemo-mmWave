NEMO Indoor mmWave Networks with Ceiling-Mounted Access Points Simulator

(c) CONNECT Centre, 2018
Trinity College Dublin

This work has emanated from the research conducted within the scope of
NEMO (Enabling Cellular Networks to Exploit Millimeter-wave Opportunities)
project financially supported by the Science Foundation Ireland (SFI) under 
Grant No. 14/US/I3110 and with partial support of the 
European Regional Development Fund under Grant No. 13/RC/2077.

   This script simulates a set of mmW-APs placed in a hexagonal grid where
   the user equipment (UE) is placed uniformly over the plane. The APs
   are deployed in the ceiling 'apHeight' meters above the UE, and they
   are transmitting a fixed directional beam pointed to the floor.

Author: 
	Fadhil Firyaguna
	PhD Researcher Student
	CONNECT Centre for Networks of the Future
	Trinity College Dublin

--------------------------------------------------------------------------

HOW TO USE THE SIMULATOR

1) Setting system parameters
	All system parameters can be set in 'sim_Model_Parameters.m'.
	You can have a set of results varying:
		- beam width
		- AP height
		- inter-site distance
		- number of random bodies
		- body attenuation
		- distance from UE to user body
		- cell association strategy
		- fading
	You can add the .values of each parameter in the respective vector
	in this script.
	Set the number of iterations. The higher the number, more accurate
	will be your results.
2) Run 'sim_Main.m' script
	This script loads the system parameters and the model functions needed
	for computing the received power. It outputs a struct with multi-
	dimensional matrices containing the SINR values for each parameter
	combination.
3) Run a 'draw_*.m' script
	This script will plot the desired result after processing the SINR struct
	according to the metric.

---------------------------------------------------------------------------------
SUPPORT

If you have any question, open an issue on GitHub https://github.com/firyaguna/matlab-nemo-mmWave
or send me an email firyaguf@tcd.ie
