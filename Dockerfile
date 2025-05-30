ARG JAVA_VERSION=11

FROM fedora:42

RUN dnf install -y curl tar buildah && dnf clean all

# Try installing java runtime only, no -devel
RUN dnf install -y java-${JAVA_VERSION}-openjdk || true

ENV JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}-openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
    | tar -xz -C /opt && \
    mv /opt/apache-maven-$MAVEN_VERSION $MAVEN_HOME && \
    ln -s $MAVEN_HOME/bin/mvn /usr/bin/mvn

WORKDIR /app

ENTRYPOINT ["/bin/bash"]
