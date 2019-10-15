#! /bin/bash
# Configuration env
sudo apt-get install python3-pip
pip install --user future
sudo apt-get install python-tk
# install mavlink
git clone https://github.com/mavlink/mavlink.git
git submodule update --init --recursive
PYTHONPATH=your_path_to_mavlink_clone
