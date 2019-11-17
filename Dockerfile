FROM ruby:2.6.3
ENV LANG C.UTF-8


RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && apt-get install -y nodejs

RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
apt-get update && apt-get install -y yarn

ENV LANG C.UTF-8

# JSTにシステム時刻を変更
RUN rm -f /etc/localtime
RUN ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN mkdir /digital-sign-app
WORKDIR /digital-sign-app
COPY Gemfile /digital-sign-app/Gemfile
COPY Gemfile.lock /digital-sign-app/Gemfile.lock
RUN bundle install
COPY . /digital-sign-app

CMD ["rails", "server", "-b", "0.0.0.0"]
