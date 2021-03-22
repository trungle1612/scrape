namespace :alram do
  desc "alarm heroku"
  task :heroku => :environment do
    `curl -X GET https://rails-scrape.herokuapp.com/ -H 'cache-control: no-cache'`
  end
end
