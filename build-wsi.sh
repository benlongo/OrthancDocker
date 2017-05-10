#!/bin/bash

set -e

# Get the number of available cores to speed up the builds
COUNT_CORES=`grep -c ^processor /proc/cpuinfo`

# Clone the repository and switch to the requested branch
cd /root/
hg clone https://bitbucket.org/sjodogne/orthanc-wsi/
cd orthanc-wsi
hg up -c "$1"

# Build the viewer plugin
cd /root/orthanc-wsi/ViewerPlugin
mkdir Build
cd Build
cmake -DALLOW_DOWNLOADS:BOOL=ON \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DUSE_GTEST_DEBIAN_SOURCE_PACKAGE:BOOL=ON \
    -DUSE_SYSTEM_JSONCPP:BOOL=OFF \
    ..
make -j$COUNT_CORES
cp -L libOrthancWSI.so /usr/share/orthanc/plugins/

# Build the DICOM-ization applications
cd /root/orthanc-wsi/Applications
mkdir Build
cd Build
cmake -DALLOW_DOWNLOADS:BOOL=ON \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DUSE_GTEST_DEBIAN_SOURCE_PACKAGE:BOOL=ON \
    -DUSE_SYSTEM_JSONCPP:BOOL=OFF \
    ..
make -j$COUNT_CORES
make install

# Remove the build directory to recover space
cd /root/
rm -rf /root/orthanc-wsi
