### Dockerfile for AiiDA EXPLORER
# Based on https://github.com/materialscloud-org/tools-barebone/Dockerfile
# See http://phusion.github.io/baseimage-docker/ for info in phusion
# See https://hub.docker.com/r/phusion/passenger-customizable
# for the latest releases
FROM phusion/passenger-customizable:1.0.1

MAINTAINER Leopold Talirz <leopold.talirz@gmail.com>

# If you're using the 'customizable' variant, you need to explicitly opt-in
# for features. Uncomment the features you want:
#
#   Build system and git.
RUN /pd_build/utilities.sh

### Installation
RUN apt-get update \
    && apt-get -y install \
    apache2 \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean all

RUN gem install sass bundler
RUN npm install --global yo bower grunt-cli

# Setup apache
# enable wsgi module, disable default apache site, enable our site
ADD ./.apache/apache-site.conf /etc/apache2/sites-available/app.conf
RUN a2dissite 000-default && a2ensite app && a2enmod rewrite

# Activate apache at startup
RUN mkdir /etc/service/apache
RUN mkdir /var/run/apache2
ADD ./.apache/apache_run.sh /etc/service/apache/run

WORKDIR /home/app

# Add deploy key
COPY keys/deploy-standalone /home/app/.ssh/
COPY keys/config /home/app/.ssh/

# Add wsgi file for app
RUN GIT_SSH_COMMAND='ssh -i /home/app/.ssh/deploy-standalone -o StrictHostKeyChecking=no' git clone git@github.com:materialscloud-org/frontend-explore.git frontend_explore
RUN git clone https://github.com/materialscloud-org/frontend-theme.git frontend_theme
RUN cp frontend_theme/theme/mcloud_theme.css frontend_explore/app/styles/css/mcloud_theme.css
RUN chown -R app:app /home/app

# install app for app user
USER app
WORKDIR /home/app/frontend_explore
RUN bundle install
RUN npm install
RUN bower install

ARG AIIDA_REST_API
# Use # as separator to avoid problems with slashes in URLs
RUN  sed -i "s#<%= yeoman.hostBackend %>/sssplibrary/api/v2#$AIIDA_REST_API#g" /home/app/frontend_explore/Gruntfile.js

RUN grunt build 

# set home for app user
ENV HOME /home/app


# go back to root user for startup
USER root
#RUN chown -R app:app /home/app

# run apache server (via baseimage-docker's init system)
EXPOSE 80
CMD ["/sbin/my_init"]
