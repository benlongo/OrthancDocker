#!/bin/bash

set -e

# Get the number of available cores to speed up the build
COUNT_CORES=`grep -c ^processor /proc/cpuinfo`
echo "Using $COUNT_CORES jobs to build Orthanc..."

# Create the various directories as in the official Debian package
mkdir /etc/orthanc
mkdir -p /var/lib/orthanc/db
mkdir -p /usr/share/orthanc/plugins

# Clone the Orthanc repository and switch to the requested branch
cd /root/
hg clone https://bitbucket.org/sjodogne/orthanc/ orthanc
cd orthanc
echo "Switching Orthanc to branch: $1"
hg up -c "$1"

# Install the Orthanc core
# https://bitbucket.org/sjodogne/orthanc/src/default/LinuxCompilation.txt
mkdir Build && cd Build
cmake -DALLOW_DOWNLOADS=ON \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DUSE_GTEST_DEBIAN_SOURCE_PACKAGE=ON \
    -DUSE_SYSTEM_MONGOOSE=OFF \
    -DDCMTK_LIBRARIES=dcmjpls \
    ..
make -j$COUNT_CORES
# Run the unit tests
./UnitTests
make install

# Remove the build directory to recover space
cd /root/
rm -rf /root/orthanc

# Auto-generate, then patch the configuration file
# http://book.orthanc-server.com/users/configuration.html
Orthanc --config=$2
