# NodeJS Jenkins JNPL slave

FROM jenkinsci/jnlp-slave




USER root

# update the repository sources list
# and install dependencies
RUN apt-get update \
    && apt-get install -y curl \
    && apt-get -y autoclean

# Setup for E2E Testing (https://github.com/auth0/docker-xvfb/blob/master/Dockerfile)

#==============
# VNC and Xvfb
#==============
RUN apt-get update -y \
  && apt-get -y install \
    xvfb \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

#========================
# Miscellaneous packages
# Includes minimal runtime used for executing non GUI Java programs
#========================
RUN apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install \
    bzip2 \
    ca-certificates \
    default-jre \
    sudo \
    unzip \
    wget \
    libgconf-2-4

# Install latest Chrome (for e2e)

ARG CHROME_VERSION="google-chrome-stable"
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qqy \
  && apt-get -qqy install \
    ${CHROME_VERSION:-google-chrome-stable} \
  && rm /etc/apt/sources.list.d/google-chrome.list \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*


# Chrome webdriver

RUN CHROMEDRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    mkdir -p /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    curl -sS -o /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    rm /tmp/chromedriver_linux64.zip && \
    chmod +x /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver && \
    ln -fs /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver /usr/bin/chromedriver

# nvm environment variables
ENV NVM_DIR /usr/local/nvm

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN apt-get install nodejs

RUN npm install -g @angular/cli@^8.2.0
RUN npm install -g typescript@3.5.3
RUN npm install -g protractor
RUN webdriver-manager update


RUN chown -R jenkins:jenkins /home/jenkins/.npm
RUN chown -R jenkins:jenkins /home/jenkins/.config

USER jenkins
