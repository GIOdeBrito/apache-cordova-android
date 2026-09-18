FROM eclipse-temurin:17-jdk-jammy

ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools

RUN apt-get update && apt-get install -y curl unzip git && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g cordova

# Download Android SDK command-line tools
RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools && \
    curl -sS https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -o tools.zip && \
    unzip -q tools.zip -d $ANDROID_SDK_ROOT/cmdline-tools && \
    mv $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools/latest && \
    rm tools.zip
	
RUN curl -fsSL https://services.gradle.org/distributions/gradle-8.7-bin.zip -o gradle.zip && \
    unzip -q gradle.zip -d /opt/gradle && \
    ln -s /opt/gradle/gradle-8.7/bin/gradle /usr/bin/gradle && \
    rm gradle.zip

# Accept licenses and install platform tools
RUN yes | sdkmanager --licenses && \
    sdkmanager "platforms;android-36" "build-tools;36.0.0"

WORKDIR /app

RUN cd /app && cordova create . && cordova platform add browser && cordova platform add android


