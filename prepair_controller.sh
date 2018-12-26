#!/bin/bash

apt update && apt upgrade -y
apt install -y software-properties-common chrony vim
apt-add-repository cloud-archive:liberty
apt update
