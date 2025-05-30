FROM docker.io/fedora:42

# Build arguments (default értékek)
ARG JAVA_VERSION=11.0.2+9
ARG MAVEN_VERSION=3.6.3

ENV JAVA_HOME=/opt/java/openjdk-${JAVA_VERSION}
ENV PATH=$JAVA_HOME/bin:$PATH

# Install buildah and curl (for downloads)
RUN dnf install -y buildah curl tar && dnf clean all

# Install OpenJDK manuálisan
RUN mkdir -p /opt/java && \
    curl -fsSL https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-${JAVA_VERSION//+/%%2B}/OpenJDK11U-jdk_x64_linux_hotspot_${JAVA_VERSION//+/%%2B}.tar.gz \
    | tar -xz -C /opt/java && \
    mv /opt/java/jdk-${JAVA_VERSION} $JAVA_HOME

# Maven environment
ENV MAVEN_HOME=/opt/maven
ENV PATH=$MAVEN_HOME/bin:$PATH

# Install Maven manuálisan
RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    | tar -xz -C /opt && \
    mv /opt/apache-maven-${MAVEN_VERSION} $MAVEN_HOME && \
    ln -s $MAVEN_HOME/bin/mvn /usr/bin/mvn

WORKDIR /app

ENTRYPOINT ["/bin/bash"]
