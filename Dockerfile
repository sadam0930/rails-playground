# syntax=docker/dockerfile:1
FROM ruby:2.7.3-alpine3.13

# Document who is responsible for this image
MAINTAINER Steven Adam "steven.adam@nyu.edu"

# Install rails runtime
RUN apk add --update \
	git \
	build-base \
	yarn \
	nodejs \
	npm \
	sqlite-dev \
	tzdata\
&& rm -rf /var/cache/apk/*

RUN gem install rails

# Expose any ports the app is expecting in the environment
ENV PORT 3000
EXPOSE $PORT

# Set up a working folder and install the pre-reqs
WORKDIR /rails-playground
COPY Gemfile /rails-playground/Gemfile
COPY Gemfile.lock /rails-playground/Gemfile.lock
RUN bundle check || bundle install

# COPY ../compose /rails-playground
COPY . .

# Add a script to be executed every time the container starts.
# COPY entrypoint.sh /usr/bin/
# RUN chmod +x /usr/bin/entrypoint.sh
# ENTRYPOINT ["./usr/bin/entrypoint.sh"]


# Configure the main process to run when running the image
ENTRYPOINT ["rails", "server", "-b", "0.0.0.0"]