FROM quay.io/centos/centos:stream9

ARG JAVA_VERSION=11
ARG MAVEN_VERSION=3.6.3

LABEL org.opencontainers.image.title="Maven + Buildah"
LABEL org.opencontainers.image.description="A container image that bundles Buildah, Maven, and OpenJDK ${JAVA_VERSION}."
LABEL org.opencontainers.image.version="${MAVEN_VERSION}"
LABEL org.opencontainers.image.source="https://github.com/jmalyik/buildah-with-maven"
LABEL org.opencontainers.image.licenses="MIT"

# Install required packages
RUN dnf install -y --allowerasing \
        curl \
        tar \
        buildah \
        java-${JAVA_VERSION}-openjdk \
    && dnf clean all

# Resolve JAVA_HOME dynamically
RUN export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which javac)))) && \
    echo "export JAVA_HOME=${JAVA_HOME}" >> /etc/profile.d/java.sh && \
    echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile.d/java.sh && \
    ln -s ${JAVA_HOME} /usr/lib/jvm/default-java

ENV JAVA_HOME=/usr/lib/jvm/default-java
ENV PATH=$JAVA_HOME/bin:/opt/maven/bin:$PATH

# Install Maven
RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    | tar -xz -C /opt && \
    mv /opt/apache-maven-${MAVEN_VERSION} /opt/maven && \
    ln -s /opt/maven/bin/mvn /usr/bin/mvn

WORKDIR /app
