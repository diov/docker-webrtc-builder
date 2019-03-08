#!/bin/bash

mkdir -p /webrtc/webrtc_sourcecode
cd /webrtc/webrtc_sourcecode
fetch --nohooks webrtc_android
gclient sync
