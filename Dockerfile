FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalacja zależności
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    unzip \
    zip \
    openjdk-8-jdk \
    git \
    make \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libxcb-xinerama0-dev \
    libxcb-xfixes0-dev \
    libxcb-icccm4-dev \
    libxcb-image0-dev \
    libxcb-keysyms1-dev \
    libxcb-randr0-dev \
    libxcb-shape0-dev \
    libxcb-sync-dev \
    libxcb-xkb-dev \
    libxkbcommon-x11-dev \
    libpulse-dev \
    libudev-dev \
    libasound2-dev \
    libxtst-dev \
    && rm -rf /var/lib/apt/lists/*

# Instalacja Android SDK
ENV ANDROID_HOME=/root/Android/Latest/Sdk
ENV ANDROID_SDK_ROOT=$ANDROID_HOME
RUN mkdir -p $ANDROID_HOME/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O /tmp/cmdline-tools.zip && \
    unzip -q /tmp/cmdline-tools.zip -d $ANDROID_HOME/cmdline-tools && \
    mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest && \
    rm /tmp/cmdline-tools.zip

ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin

# Instalacja NDK
RUN yes | sdkmanager --licenses > /dev/null 2>&1 || true && \
    sdkmanager "platforms;android-33" "ndk;23.2.8568313" "build-tools;33.0.0"

# Instalacja Qt 5.15.2 dla Androida
RUN wget -q https://download.qt.io/archive/qt/5.15/5.15.2/qt-opensource-linux-x64-android-5.15.2.run -O /tmp/qt-installer.run && \
    chmod +x /tmp/qt-installer.run && \
    /tmp/qt-installer.run --script /dev/null --platform minimal --accept-licenses --confirm-command --no-force-installations --verbose && \
    rm /tmp/qt-installer.run

ENV PATH=/opt/Qt/5.15.2/android/bin:$PATH
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV ANDROID_NDK_ROOT=$ANDROID_HOME/ndk/23.2.8568313

WORKDIR /app
