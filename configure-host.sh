#!/bin/bash
# configure-host.sh - automated configuration script
# name: Brandon Williams
# ID: 200602763
# course: COMP2137
# This script configures system hostname, IP address, and hosts file entries


# ignore TERM, HUP, and INT signals
trap '' TERM HUP INT

# variables
verbose=false
desiredName=""
desiredIPAddress=""
hostEntryName=""
hostEntryIP=""


# the verbose fuctionscript will tell the user about any changes made
# the logger function will tell the user about any changes made
verboseFunction() {
    if [ "$verbose" = true ]; then
        echo "$1"
    fi
}

# the logger function will tell the user about any changes made
loggerFunction() {
    logger -t configure-host -p user.info "$1"
}


# Function: updateHostEntry
# Purpose: Add or update a single line in /etc/hosts
updateHostEntry() {
    if [ -z "$hostEntryName" ] || [ -z "$hostEntryIP" ]; then
      return 0
    fi
    # Search for entry in /etc/hosts
    currentEntryName=$(grep -E "^[^#]*\s$hostEntryName(\s|$)" /etc/hosts)
     if [ -z "$currentEntryName" ]; then
        echo "$hostEntryIP $hostEntryName" >> /etc/hosts
        loggerFunction "Added: $hostEntryIP $hostEntryName"
        verboseFunction "Added: $hostEntryIP $hostEntryName"
    else
        NewIP=$(echo "$currentEntryName" | awk '{print $1}')
        if [ "$NewIP" = "$hostEntryIP" ]; then
            verboseFunction "Host entry match: $hostEntryName"
        else
            sed -i "/$hostEntryName/d" /etc/hosts
            echo "$hostEntryIP $hostEntryName" >> /etc/hosts
            loggerFunction "Updated host entry: $hostEntryIP $hostEntryName"
            verboseFunction "Updated host entry: $hostEntryIP $hostEntryName"
        fi
    fi

    return 0
 }

updateHostname() {
    if [ -z "$desiredName" ]; then
        return 0
    fi
    # current hostname
    currentHostname=$(hostname)
    # Compare and update hostnames 
    if [ "$currentHostname" = "$desiredName" ]; then
        verboseFunction "Hostname already set to $desiredName"
    else
        hostnamectl set-hostname "$desiredName"
        loggerFunction "Hostname changed from $currentHostname to $desiredName"
        verboseFunction "Hostname changed from $currentHostname to $desiredName"
    fi
    return 0
}

updateIP() {
    # if no IP requested
    if [ -z "$desiredIPAddress" ]; then
        return 0
    fi

    # Get current IP address
    currentIP=$(hostname -I | awk '{print $1}')

    # check if IP matches
    if [ "$currentIP" = "$desiredIPAddress" ]; then
        verboseFunction "IP address matches: $desiredIPAddress"
        return 0
    fi

    # find netplan configuration file
    netplanFile=$(find /etc/netplan -name "*.yaml" -type f | head -1)

    if [ -z "$netplanFile" ]; then
        echo "Error: No netplan file found" >&2
        return 1
    fi

    # backup the netplan file
    cp "$netplanFile" "${netplanFile}.backup"

    # update the IP address in netplan 
    sed -i "s|addresses: \[.*\]|addresses: [${desiredIPAddress}/24]|" "$netplanFile"
    netplan apply

    # update loggger 
    loggerFunction "IP address changed from $currentIP to $desiredIPAddress"
    verboseFunction "IP address changed from $currentIP to $desiredIPAddress"

    return 0
}


# Root Check:
if [[ $EUID -ne 0 ]]; then
	echo "Error: Need to run script using root" >&2
        exit 1
fi

# Command line arguments
while [ $# -gt 0 ]; do
    case "$1" in
        -verbose)
            verbose=true
            shift
            ;;
        -name)
            if [ $# -lt 2 ]; then
                echo "Error: -name input hostname" >&2
                exit 1
            fi
            desiredName="$2"
            shift 2 
            ;;
         -ip)
            if [ $# -lt 2 ]; then
                echo "Error: -ip input an IP address" >&2
                exit 1
            fi
            desiredIPAddress="$2"
            shift 2
            ;;
         -hostentry)
            if [ $# -lt 3 ]; then
                echo "Error: -hostentry needs hostname and IP address" >&2
                exit 1
            fi
            hostEntryName="$2"
            hostEntryIP="$3"
            shift 3 
            ;;
          *)
            echo "Error: $1" >&2
            exit 1
            ;;
    esac
 done

# call functions
if [ -n "$desiredName" ]; then
    updateHostname
fi

if [ -n "$desiredIPAddress" ]; then
    updateIP
fi

if [ -n "$hostEntryName" ] && [ -n "$hostEntryIP" ]; then
    updateHostEntry
fi
