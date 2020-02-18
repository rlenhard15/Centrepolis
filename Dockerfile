FROM ruby:2.6.3

RUN apt-get update -qq && apt-get install -y nodejs

RUN mkdir /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/Gemfile
COPY Gemfile.lock /usr/src/app/Gemfile.lock

RUN gem install bundler -v 2.0.2
RUN bundle update --bundler
RUN bundle install

COPY . .

EXPOSE 3000
