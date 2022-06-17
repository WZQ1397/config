#!/bin/bash
# Author: Zach.Wang
cd ~
bash .bashrc 
bash .bash_profile
cd zach-ansible-py39
source bin/activate
python -V
pushd auto-patching/inventories/
python inventory_builder.py --env prod
python generate_hostlist.py
popd