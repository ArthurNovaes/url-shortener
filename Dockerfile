FROM ruby:2.5.1

RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common \
    apt-transport-https \
    curl

RUN curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    echo "deb https://deb.nodesource.com/node_10.x stretch main" | \
    tee /etc/apt/sources.list.d/nodesource.list

RUN echo "deb-src https://deb.nodesource.com/node_10.x stretch main" | \
    tee -a /etc/apt/sources.list.d/nodesource.list

RUN apt-get update && apt-get install -y --no-install-recommends \
    cron \
    debconf-utils \
    g++ \
    nodejs \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN gem install bundler

RUN mkdir /home/app
WORKDIR /home/app
ADD . /home/app

RUN bundle check || bundle install

USER root

WORKDIR /home/app

RUN chmod 755 script/docker/start.sh

EXPOSE 3000

CMD ["./script/docker/start.sh"]
