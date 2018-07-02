FROM repo.it2.vm/ruby2.4.4-alpine3.7pm:latest

COPY Gemfile Gemfile.lock ./

RUN bundle install --jobs=4 --without test development

COPY . .
