#!/bin/bash

set -e

# Get the number of available cores to speed up the builds
COUNT_CORES=`grep -c ^processor /proc/cpuinfo`

# Clone the repository and switch to the requested branch
cd /root/
hg clone https://bitbucket.org/sjodogne/orthanc-webviewer/
cd orthanc-webviewer
hg up -c "$1"

# Build the plugin
mkdir Build
cd Build
cmake -DALLOW_DOWNLOADS:BOOL=ON \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DUSE_GTEST_DEBIAN_SOURCE_PACKAGE:BOOL=ON \
    -DUSE_SYSTEM_JSONCPP:BOOL=OFF \
    ..
make -j$COUNT_CORES
# Run the unit tests
./UnitTests
cp -L libOrthancWebViewer.so /usr/share/orthanc/plugins/

# Remove the build directory to recover space
cd /root/
rm -rf /root/orthanc-webviewer
