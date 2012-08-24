on_travis = ENV['TRAVIS']
trello_env = ENV['TRELLO_USER_KEY'] && ENV['TRELLO_USER_SECRET']

if !(on_travis && trello_env)
raise <<-WARNING

  Set up your trello key information. You can get this information at https://trello.com/1/appKey/generate

  export TRELLO_USER_NAME=your_trello_user_name
  export TRELLO_USER_KEY=your_public_trello_key
  export TRELLO_USER_SECRET=your_trello_secret

  Then visit https://trello.com/1/connect?key=your_public_trello_key&name=afterburn&response_type=token&scope=read,write,account&expiration=never

  export TRELLO_APP_TOKEN=your_app_token

WARNING
end

Afterburn.authorize ENV['TRELLO_USER_NAME'] do |auth|
  auth.trello_user_key = ENV['TRELLO_USER_KEY']
  auth.trello_user_secret = ENV['TRELLO_USER_SECRET']
  auth.trello_app_token = ENV['TRELLO_APP_TOKEN']
end