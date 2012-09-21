skip_trello_config  = ENV['TRAVIS']
unless skip_trello_config
  trello_config = File.exists?('./config/trello.yml') ? YAML.load_file('./config/trello.yml')[Rails.env] : {}
  ENV['TRELLO_USER_NAME'] ||= trello_config["user_name"]
  ENV['TRELLO_USER_KEY'] ||= trello_config["user_key"]
  ENV['TRELLO_USER_SECRET'] ||= trello_config["user_secret"]
  ENV['TRELLO_APP_TOKEN'] ||= trello_config["app_token"]

  trello_configured = ENV['TRELLO_USER_KEY'] && ENV['TRELLO_USER_SECRET']

  if !(trello_configured)
    raise <<-WARNING

  Set up your trello key information. You can get this information at https://trello.com/1/appKey/generate

  export TRELLO_USER_NAME=your_trello_user_name
  export TRELLO_USER_KEY=your_public_trello_key
  export TRELLO_USER_SECRET=your_trello_secret

  Then visit https://trello.com/1/connect?key=your_public_trello_key&name=afterburn&response_type=token&scope=read,write,account&expiration=never

  export TRELLO_APP_TOKEN=your_app_token

    WARNING
  end
end

puts "TRELLO CONFIGURED: #{!!ENV['TRELLO_USER_NAME']}"

Afterburn.authorize ENV['TRELLO_USER_NAME'] do |auth|
  auth.trello_user_key = ENV['TRELLO_USER_KEY'] || 'trello_user_key'
  auth.trello_user_secret = ENV['TRELLO_USER_SECRET'] || 'trello_user_secret'
  auth.trello_app_token = ENV['TRELLO_APP_TOKEN'] || 'trello_app_token'
end
