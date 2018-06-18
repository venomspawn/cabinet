run:
	bundle exec bin/app

debug:
	bundle exec bin/irb_debug

test:
	bundle exec rspec --fail-fast

migrate:
	bundle exec rake cab:migrate

.PHONY: doc
doc:
	bundle exec yard doc --quiet

.PHONY: doc_stats
doc_stats:
	bundle exec yard stats --list-undoc
