# Question 1: VPC & Networking Setup

## Overview

Created a multi-tier VPC architecture with public and private subnets across 2 Availability Zones for high availability.

## Architecture Details

### CIDR Design

- _VPC CIDR:_ 10.0.0.0/16 (65,536 IP addresses)
- _Public Subnet 1:_ 10.0.1.0/24 (ap-south-1a) - 256 IPs
- _Public Subnet 2:_ 10.0.2.0/24 (ap-south-1b) - 256 IPs
- _Private Subnet 1:_ 10.0.10.0/24 (ap-south-1a) - 256 IPs
- _Private Subnet 2:_ 10.0.11.0/24 (ap-south-1b) - 256 IPs

### Components Created

1. _VPC_ - Virtual Private Cloud
2. _Internet Gateway_ - For public internet access
3. _2 Public Subnets_ - For load balancers and public-facing resources
4. _2 Private Subnets_ - For backend instances and databases
5. _NAT Gateway_ - For private subnet outbound internet access
6. _Route Tables_ - Separate routing for public and private subnets

## Deployment Steps
