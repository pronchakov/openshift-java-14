# openshift-java-14
FROM openjdk:14-jdk-alpine

LABEL maintainer="Artem Pronchakov <artem.pronchakov@calisto.email>"
ENV MAVEN_VERSION="3.6.3" \
    HOME="/home/appuser"
LABEL io.k8s.description="Platform for building Java 14 applications" \
      io.k8s.display-name="Java 14 Application" \
      io.openshift.s2i.scripts-url="image:///usr/local/s2i" \
      io.openshift.tags="builder,java,14,jar,app"

RUN addgroup -S appuser && adduser -S appuser -G appuser

RUN apk add curl && \
    (curl -v https://downloads.apache.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -zx -C /usr/local) && \
    ln -sf /usr/local/apache-maven-$MAVEN_VERSION/bin/mvn /usr/local/bin/mvn && \
    mkdir -p $HOME/.m2 && \
    mkdir -p /opt/app/
ADD ./etc/maven/settings.xml $HOME/.m2/
ADD ./s2i/bin/ /usr/local/s2i/
RUN chown -R appuser:appuser /opt/app && \
    chown -R appuser:appuser $HOME/.m2
USER appuser
# TODO: copy target jar file from target
CMD ["usage"]
