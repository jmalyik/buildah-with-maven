FROM docker.io/fedora:42

ARG JAVA_VERSION=11
ARG MAVEN_VERSION=3.6.3

# Install OpenJDK from Fedora repos
RUN case "$JAVA_VERSION" in \
    11) JDK_PKG="java-11-openjdk-devel" ;; \
    17) JDK_PKG="java-17-openjdk-devel" ;; \
    21) JDK_PKG="java-21-openjdk-devel" ;; \
    *) echo "Unsupported JAVA_VERSION: $JAVA_VERSION" && exit 1 ;; \
    esac && \
    dnf install -y buildah curl tar $JDK_PKG && \
    dnf clean all

ENV JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}-openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

# Install Apache Maven
ENV MAVEN_HOME=/opt/maven
ENV PATH=$MAVEN_HOME/bin:$PATH

RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION%.*}/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
    | tar -xz -C /opt && \
    mv /opt/apache-maven-$MAVEN_VERSION $MAVEN_HOME && \
    ln -s $MAVEN_HOME/bin/mvn /usr/bin/mvn

WORKDIR /app

ENTRYPOINT ["/bin/bash"]
