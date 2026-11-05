#!/bin/bash

set -e

redis-server --maxmemory 300mb 	--maxmemory-policy allkeys-lru --protected-mode no