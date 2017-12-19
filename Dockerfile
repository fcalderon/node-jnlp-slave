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

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

RUN apt-get install nodejs

USER jenkins
