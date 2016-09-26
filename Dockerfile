# Builds a simplistic JNLP Jenkins slave that automatically connects when started.
FROM patriknyblad/ubuntu-xenial-jre9:1.0.0
MAINTAINER Patrik Nyblad <patrik.nyblad@gmail.com>

# Require arguments to build
ARG SLAVE_JAR_URL
ARG JNLP_URL
ARG JNLP_SECRET

# Add jenkins user
RUN useradd -m -d /home/jenkins -s /bin/sh jenkins &&\
    echo "jenkins:jenkins" | chpasswd

# Setup folder structure
RUN mkdir /home/jenkins/slave

# Select jenkins user
USER jenkins

# Download slave.jar from Jenkins Server
RUN wget $SLAVE_JAR_URL -O /home/jenkins/slave.jar

# Create entrypoint script with embedded jnlpUrl and secret args
RUN echo "java -jar /home/jenkins/slave.jar -jnlpUrl $JNLP_URL -secret $JNLP_SECRET" > /home/jenkins/entrypoint.sh && \
    chmod +x /home/jenkins/entrypoint.sh

# Expose path to jenkins workspace
VOLUME ["/home/jenkins/slave"]

# Start jenkins slave
ENTRYPOINT ["/bin/bash", "/home/jenkins/entrypoint.sh"]
