FROM ruby:2.7.6-bullseye

RUN apt-get update -qq && apt-get install -y nodejs

RUN mkdir /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/Gemfile
COPY Gemfile.lock /usr/src/app/Gemfile.lock

RUN gem install bundler -v 1.17.2
RUN bundle update --bundler
RUN bundle install

COPY . .

EXPOSE 3000
