#!/bin/bash

db_endpoint=$(aws rds describe-db-instances --db-instance-identifier mysql-db --query "DBInstances[*].Endpoint.Address" --output text)
echo "$db_endpoint"
