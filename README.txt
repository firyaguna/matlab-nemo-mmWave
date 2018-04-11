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
PUBLICATION

System modeling and some results using this code are presented in this paper:

https://ieeexplore.ieee.org/abstract/document/8254623/
Coverage and Spectral Efficiency of Indoor mmWave Networks 
with Ceiling-Mounted Access Points

Abstract:
Provisioning of high throughput millimetre-wave signal to indoor areas that potentially serve a large number of users, such as transportation hubs or convention centres, will require dedicated indoor millimetre-wave access point deployments. In this article, we study dense deployments of millimetre-wave access points mounted on the ceiling, and illuminating selected spots on the ground with the use of fixed directional antennas. In this setup, the main factor limiting signal propagation are blockages by human bodies. We evaluate our system under a number of scenarios that take into account beamwidth of the main-lobe, access point density, and positioning of the mobile device with respect to the user's body. We find that both coverage and area spectral efficiency curves exhibit non-trivial behaviour which can be classified into four regions related to the selection of access point density, beamwidth, and height values. Furthermore, we observe a trade-off in beamwidth design, as the optimal beamwidth maximizes either coverage or area spectral efficiency, but not both. Finally, when we consider different body shadowing scenarios, our network design optimizes coverage or area spectral efficiency performance towards either devices held in hand or worn directly against the body, as each of the scenarios requires mutually exclusive settings of access point density and beamwidth.

---------------------------------------------------------------------------------
SUPPORT

If you have any question, open an issue on GitHub https://github.com/firyaguna/matlab-nemo-mmWave
or send me an email firyaguf@tcd.ie
