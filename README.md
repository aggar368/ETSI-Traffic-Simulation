# ETSI-Traffic-Simulation
![image](https://user-images.githubusercontent.com/57944323/222902049-af3386b0-ea77-42a6-9de0-e3132cb8e1bf.png)

## ETSI Traffic: models the burstyness of traffic
consists of packet service sessions

## Packet service session: 
1. consists of packet calls (number of packet calls is geometric)
2. inter-session time is exponential

## Packet call:
1. consists of packets (number of packets is geometric)
2. inter-call time (reading time) is exponential

## Packet:
1. packet inter-arrival time is exponential
2. packet size is truncated Pareto distribution

## ETSITrafficSimulator.m:
Traffic simulator.

## GetPacketSize.m:
Function to generate packet size (truncated Pareto)
