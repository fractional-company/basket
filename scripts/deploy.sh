#!/usr/bin/env bash

# import the deployment helpers
. $(dirname $0)/common.sh

# Deploy.
FactoryAddr=$(deploy BasketFactory)
log "Basket Factory deployed at:" $FactoryAddr
