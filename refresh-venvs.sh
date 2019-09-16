set -e
cd ~
rm -f env2 env3

virtualenv --python=python2 --prompt=\($(basename $(pwd))-2\) env2
source ./env2/bin/activate
pip install pip-accel ipython requests
deactivate


virtualenv --python=python3 --prompt=\($(basename $(pwd))-3\) env3
source ./env3/bin/activate
pip3 install pip-accel ipython requests docopt
