#!/bin/bash

lb_dns=$(aws elbv2 describe-load-balancers --names application-tier-lb --query 'LoadBalancers[0].DNSName' --output text)
echo "$lb_dns"
