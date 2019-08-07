# NodeJS Jenkins JNPL slave

FROM jenkinsci/jnlp-slave

USER root

# update the repository sources list
# and install dependencies
RUN apt-get update \
    && apt-get install -y curl \
    && apt-get -y autoclean

# nvm environment variables
ENV NVM_DIR /usr/local/nvm

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN apt-get install nodejs

RUN npm install -g @angular/cli@^8.2.0
RUN npm install -g typescript@3.5.3

USER jenkins
