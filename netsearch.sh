#!/bin/bash

# Show local IP addresses
echo "=== Local IP Addresses ==="
ifconfig | grep "inet " | awk '{print $2}'

# Define ranges to scan (add more if needed)
ranges=("192.168.0" "192.168.1" "10.0.0" "172.16.0" "169.254")

for range in "${ranges[@]}"; do
  echo -e "\n=== Scanning $range.* ==="
  for i in {1..254}; do
    ip="$range.$i"
    ping -c 1 -W 1 $ip &> /dev/null
    if [ $? -eq 0 ]; then
      echo "$ip is alive"
    fi
  done
done

# Show ARP table for MAC ↔ IP mapping
echo -e "\n=== ARP Table ==="
arp -a