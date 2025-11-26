#!/bin/bash
# configure-host.sh - automated configuration script
# name: Brandon Williams
# ID: 200602763
# course: COMP2137
# This script will print a summary of hosts and IP addresses when it runs

# ignore TERM, HUP, and INT signals
trap '' TERM HUP INT

# variables
verbose=false

