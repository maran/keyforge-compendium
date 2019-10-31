web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
worker: bundle exec sidekiq -t 20 -c 20 -q mailers -q default -q lazy
release: rake db:migrate
