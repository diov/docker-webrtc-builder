FROM ubuntu:xenial
LABEL maintainer="Dio_V (diov87@outlook.com)"

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /root

# Update apt cache
RUN dpkg --add-architecture i386 \
    && apt-get update -y \
    && apt-get install -y apt-utils lsb-release sudo wget git 

# Install Chromium build deps
RUN wget -q -O - 'https://chromium.googlesource.com/chromium/src/+/master/build/install-build-deps.sh?format=TEXT' | base64 -d > install-build-deps.sh
RUN wget -q -O - 'https://chromium.googlesource.com/chromium/src/+/master/build/install-build-deps-android.sh?format=TEXT' | base64 -d > install-build-deps-android.sh
RUN chmod u+x ./install-build-deps.sh ./install-build-deps-android.sh
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
RUN ./install-build-deps-android.sh

# Clear cache 
RUN apt-get autoclean -y \
    && apt-get autoremove -y \
    && apt-get clean -y

# Install Chromium depot tools
RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git /opt/depot_tools
ENV PATH /opt/depot_tools:$PATH

# Copy fetch/build scripts
COPY ./fetch-webrtc.sh /usr/local/bin/fetch-webrtc
COPY ./build-webrtc.sh /usr/local/bin/build-webrtc
RUN chmod +x /usr/local/bin/fetch-webrtc /usr/local/bin/build-webrtc
