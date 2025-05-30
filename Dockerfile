FROM docker.io/fedora:42

# Build arguments
ARG JAVA_VERSION
ARG JAVA_VERSION_ENCODED
ARG MAVEN_VERSION

# Install buildah, curl, tar
RUN dnf install -y buildah curl tar && dnf clean all

# Set up Java
ENV JAVA_HOME=/opt/java/openjdk-$JAVA_VERSION
ENV PATH=$JAVA_HOME/bin:$PATH

RUN mkdir -p /opt/java && \
    curl -fsSL https://github.com/adoptium/temurin11-binaries/releases/download/jdk-${JAVA_VERSION//+/%2B}/OpenJDK11U-jdk_x64_linux_hotspot_${JAVA_VERSION//+/_}.tar.gz \
    | tar -xz -C /opt/java && \
    mv /opt/java/jdk-${JAVA_VERSION} $JAVA_HOME

# Set up Maven
ENV MAVEN_HOME=/opt/maven
ENV PATH=$MAVEN_HOME/bin:$PATH

RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    | tar -xz -C /opt && \
    mv /opt/apache-maven-${MAVEN_VERSION} $MAVEN_HOME && \
    ln -s $MAVEN_HOME/bin/mvn /usr/bin/mvn

WORKDIR /app

ENTRYPOINT ["/bin/bash"]
