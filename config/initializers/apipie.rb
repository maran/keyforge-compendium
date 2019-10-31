Apipie.configure do |config|
  config.app_name                = "Keyforge Compendium API"
  config.app_info = "The Keyforge Compendium API uses 'Basic Access Authentication' where the key is the username and the secret is the password. Most libraries come with build in support for this if not you will have to built the header yourself."
  config.api_base_url            = "/api/v1"
  config.doc_base_url            = "/docs"
  config.translate = false
  config.use_cache = Rails.env.production?
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/**/*.rb"
  config.copyright = "© 2018-2019 - keyforge-compendium.com"
  config.validate = false
end
