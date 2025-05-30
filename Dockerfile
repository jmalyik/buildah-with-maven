FROM docker.io/fedora:42

# Install buildah, curl, tar, és engedélyezzük a java-11 modult, majd telepítjük a java-11-openjdk-devel csomagot
RUN dnf install -y dnf-plugins-core && \
    dnf module enable -y java-11 && \
    dnf install -y buildah curl tar java-11-openjdk-devel && \
    dnf clean all

# Környezeti változók
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

# Maven telepítés (például verziószám változóval, ha kell)
ENV MAVEN_VERSION=3.6.3
ENV MAVEN_HOME=/opt/maven
ENV PATH=$MAVEN_HOME/bin:$PATH

RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
    | tar -xz -C /opt && \
    mv /opt/apache-maven-$MAVEN_VERSION $MAVEN_HOME && \
    ln -s $MAVEN_HOME/bin/mvn /usr/bin/mvn

WORKDIR /app

ENTRYPOINT ["/bin/bash"]
