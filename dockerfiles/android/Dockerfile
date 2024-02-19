FROM jenkins/ssh-agent:5.25.0 as ssh-agent

# ca-certificates because curl will need it later on for the Maven installation
RUN apt-get update && apt-get install -y --no-install-recommends adb build-essential ca-certificates curl file git python3 python3-pip unzip

# Now time to install Maven
ARG MAVEN_VERSION=3.9.5
# Add a checksum for the maven binary
RUN curl -sS -L -O --output-dir /tmp/ --create-dirs  https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && echo "$(sha512sum /tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz)" | sha512sum -c - \
    && curl -sS -L -O --output-dir /tmp/ --create-dirs  https://downloads.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz.sha512 \
    && echo "$(cat /tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz.sha512) /tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz" | sha512sum --check --status \
    && tar xzf "/tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz" -C /opt/ \
    && rm "/tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz" \
    && ln -s /opt/apache-maven-${MAVEN_VERSION} /opt/maven \
    && mkdir -p /etc/profile.d \
    && echo "export JAVA_HOME=$JAVA_HOME \n \
             export M2_HOME=/opt/maven \n \
             export PATH=${M2_HOME}/bin:${PATH}" > /etc/profile.d/maven.sh
ENV M2_HOME="/opt/maven"
ENV PATH="${M2_HOME}/bin/:${PATH}"

# Install Android SDK
# See https://stackoverflow.com/questions/60440509/android-command-line-tools-sdkmanager-always-shows-warning-could-not-create-se
ENV ANDROID_HOME /usr/local/android-sdk-linux
# > SDK location not found. Define location with an ANDROID_SDK_ROOT environment variable or by setting the sdk.dir path in your project's local properties file at '/home/jenkins/workspace/First Android Job/local.properties'.
ENV ANDROID_SDK_ROOT /usr/local/android-sdk-linux
ENV CMDLINE_TOOLS_HOME $ANDROID_HOME/cmdline-tools/latest
ENV PATH /usr/local/bin:$PATH:$CMDLINE_TOOLS_HOME/bin:$ANDROID_HOME/:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
ARG ANDROID_BUILD_TOOLS_VERSION=30.0.3

RUN mkdir -p /usr/local/android-sdk-linux/cmdline-tools/latest && cd /usr/local/android-sdk-linux && \
  curl -L -O  https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip && \
  unzip -qq commandlinetools-linux-8512546_latest.zip -d tmp && mv tmp/cmdline-tools/* cmdline-tools/latest && \
  rm -rf /usr/local/android-sdk-linux/commandlinetools-linux-8512546_latest.zip && \
  yes|/usr/local/android-sdk-linux/cmdline-tools/latest/bin/sdkmanager --licenses && \
  /usr/local/android-sdk-linux/cmdline-tools/latest/bin/sdkmanager --update && \
  /usr/local/android-sdk-linux/cmdline-tools/latest/bin/sdkmanager --list && \
  /usr/local/android-sdk-linux/cmdline-tools/latest/bin/sdkmanager "platform-tools" \
                                                      "ndk;25.0.8775105" \
                                                      "extras;google;m2repository" \
                                                      "extras;android;m2repository" \
                                                      "platforms;android-33" \
                                                      "emulator" \
                                                      "build-tools;$ANDROID_BUILD_TOOLS_VERSION" \
                                                      "add-ons;addon-google_apis-google-24" \
                                                      "add-ons;addon-google_apis-google-23" 2>&1 >/dev/null && \
  chown -R jenkins:jenkins $ANDROID_HOME && ls -artl /usr/local/android-sdk-linux
ENV PATH /usr/local/android-sdk-linux/build-tools/$ANDROID_BUILD_TOOLS_VERSION/:$PATH

# Install GitHub command line tool
ENV GITHUB_TOKEN $GITHUB_TOKEN
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt update && apt install -y --no-install-recommends gh

# Install docker \
# RUN curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
# RUN adduser jenkins docker

# Install ADB keys for DeviceFarmer STF
RUN mkdir -p /home/jenkins/.android && touch /home/jenkins/.android/adbkey.pub && touch /home/jenkins/.android/adbkey
COPY adbkey.txt /home/jenkins/.android/adbkey
# monter dans docker compose à l     place de jenkins
COPY adbkey.pub /home/jenkins/adbkey.pub

# Install DeviceFarmer STF script
ENV DEVICEFARMER_STF_HOME /usr/local/stf
RUN mkdir -p "${DEVICEFARMER_STF_HOME}" && chown -R jenkins:jenkins /home/jenkins/.android && \
    chmod 644 /home/jenkins/.android/adbkey* && chmod -R 777 /home/jenkins/.android
COPY android-stf-api.py "${DEVICEFARMER_STF_HOME}"
RUN chmod 755 "${DEVICEFARMER_STF_HOME}"/android-stf-api.py && chown -R jenkins:jenkins /home/jenkins/.android && \
    # Install Python dependencies for the script
    apt install -y python3-requests

ENV PATH $PATH:$DEVICEFARMER_STF_HOME

# mkdir ${JENKINS_AGENT_HOME}/.jenkins && mkdir -p ${JENKINS_AGENT_HOME}/ &&
RUN mkdir -p "${JENKINS_AGENT_HOME}/gradle/wrapper" "${JENKINS_AGENT_HOME}/.gradle/wrapper/dists"

# Let's try to download the gradle wrapper binary
COPY . .
COPY gradlew "${JENKINS_AGENT_HOME}"/

ENV GRADLE_HOME="${JENKINS_AGENT_HOME}"/.gradle

RUN chown -R jenkins:jenkins "${JENKINS_AGENT_HOME}" && chmod +x "${JENKINS_AGENT_HOME}"/gradlew && \
    su - jenkins -c "./gradlew -d --version"

RUN echo "PATH=${PATH}" >> /etc/environment

# COPY entrypoint.sh /entrypoint.sh
# ENTRYPOINT [ "bash", "-c"]
