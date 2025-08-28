#!/bin/bash

# Set library path for Steam libraries
export LD_LIBRARY_PATH=/hlds:$LD_LIBRARY_PATH

# Change to HLDS directory
cd /hlds

# Start Natural Selection server
./hlds_run -game ns +map ns_eclipse +maxplayers 12 -console -port 27015 +sv_lan 0
