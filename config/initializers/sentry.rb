if Rails.env == "production"
  Raven.configure do |config|
    config.dsn = 'https://7f538ee2f5f648879ad44cebb4aca644:d5442e7fa0eb4cb78095ea98bea8a099@sentry.io/1330882'
  end
end
