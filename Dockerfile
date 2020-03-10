# ------------------------------------------------------
#                       Dockerfile
# ------------------------------------------------------
# image: flutter
# name: futuriot/flutter
# repo: https://github.com/villematti/ubuntu-flutter
# Requires: ubuntu:18.04
# authors: ville-matti.hakanpaa@futuriot.com
# ------------------------------------------------------
FROM ubuntu:18.04

LABEL maintainer="ville-matti.hakanpaa@futuriot.com"

RUN apt-get update
RUN apt-get install -y lcov git-core curl unzip libglu1 lib32stdc++6 gradle openjdk-8-jdk wget

ENV SDK_TOOLS "4333796"
ENV BUILD_TOOLS "28.0.3"
ENV TARGET_SDK "28"
ENV ANDROID_HOME "/opt/sdk"

ENV FLUTTER_PATH=/flutter/bin

# ANDROID
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64 ANDROID_HOME=$ANDROID_HOME/tools

# Download and extract Android Tools
RUN curl -L http://dl.google.com/android/repository/sdk-tools-linux-${SDK_TOOLS}.zip -o /tmp/tools.zip --progress-bar
RUN mkdir -p ${ANDROID_HOME}
RUN unzip /tmp/tools.zip -d ${ANDROID_HOME}
RUN rm -v /tmp/tools.zip

# Install SDK Packages
RUN mkdir -p /root/.android/ && touch /root/.android/repositories.cfg && \
    yes | ${ANDROID_HOME}/tools/bin/sdkmanager "--licenses" && \
    ${ANDROID_HOME}/tools/bin/sdkmanager "--update" && \
    ${ANDROID_HOME}/tools/bin/sdkmanager "build-tools;${BUILD_TOOLS}" "platform-tools" "platforms;android-${TARGET_SDK}"

# FLUTTER
RUN git clone https://github.com/flutter/flutter.git -b stable
RUN ${FLUTTER_PATH}/flutter doctor

ENV PATH $PATH:${FLUTTER_PATH}/cache/dart-sdk/bin:${FLUTTER_PATH}
