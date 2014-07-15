# ------------------------------------------------------------
#
# VERSION 0.1
#
# AUTHOR:      Ole Weidner <ole.weidner@codewerft.net>
# DESCRIPTION: Container for continuous deployment of git-hosted Jekyll blogs.
# TO_BUILD:    docker build --rm -t jekyllinstance .
# TO_RUN:      docker run 127.0.0.1:6001:80 --name=myblog -d jekyllinstance -e WI_REPOSITORY==https://github.com/user/myblog.git -e WI_BRANCH=deploy -e WI_OAUTH=secret

FROM ubuntu:14.04
MAINTAINER Ole Weidner <ole.weidner@codewerft.com>

# ------------------------------------------------------------
# update base distribution
#
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y git wget curl make

# ------------------------------------------------------------
# install nginx webserver
#
RUN apt-get install -y nginx-full
ADD nginx.conf /etc/nginx/nginx.conf 
RUN mkdir -p /var/www/content/

# ------------------------------------------------------------
# install rvm, jehyll, ruby, etc.
RUN apt-get install -y nodejs python-pygments ruby ruby-dev
RUN gem install jekyll --no-rdoc --no-ri
RUN gem install rdiscount --no-rdoc --no-ri
RUN jekyll -v

#RUN curl -L get.rvm.io | bash -s stable
#RUN . /usr/local/rvm/scripts/rvm
#RUN /usr/local/rvm/bin/rvm install ruby
#RUN ruby -v

# ------------------------------------------------------------
# install git puller script
#
RUN wget https://gist.githubusercontent.com/oweidner/6f173a9347f3b298dd0d/raw/50789620672f1822b374a6becadd206bc4502a16/gitpoller.sh

# ------------------------------------------------------------
# Install supervisor
#
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
RUN rm -r /etc/supervisor/conf.d/
ADD supervisord.conf /etc/supervisor/supervisord.conf

# ------------------------------------------------------------
# Exposed ports and startup 
#  * Port 80: nginx 
# 
EXPOSE 80
CMD ["/usr/bin/supervisord"]

