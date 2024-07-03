# Strimzi setup

## Table of Contents

1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Usage](#usage)
4. [Examples](#examples)
5. [Contributing](#contributing)
6. [License](#license)

## Introduction

Strimzi kafka. Deployed using make, docker & docker-compose.

## Installation

Pre-requisites are `docker`, `docker-compose` and `make` which are readily available on any OS. 

## Usage

Your Docker engine must be running. Run `make help` for a list of target commands. 

`make setup`    Run this first to `build` a devops container and a python client container. That will take a few minutes. Once done, the `scripts\strimzi-install.sh` installs our Custom Resource Definitions for each of the technologies we want to use. Expect no output until the kafka operator pod is running; approximately two minutes. 
`make demo`     Provided everything worked, run this which installs our workloads themselves: a Kafka cluster (with Zookeeper), Kafka exporter metrics, a networking solution and a client pod, written in Python. 

Now in a new terminal, run `kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443`. This will stay open. 

Next obtain a token to access the dashboard on `https://localhost:8443/#/login` with: `kubectl get secret admin-user -n kubernetes-dashboard -o jsonpath={".data.token"} | base64 -d`. Copy that output and paste it into your browsers prompt. 

From here you can exec into the python client pod and develop an application as a producer and consumeer to/from the Kafka cluster.