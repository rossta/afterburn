#
# 1. Get your trello key and secret:
# => https://trello.com/1/appKey/generate.
# 2. Generate an app token for afterburn:
# => https://trello.com/1/connect?key=PUBLIC_KEY_FROM_ABOVE&name=MyApp&response_type=token&scope=read,write,account&expiration=never
# 3. Use the afterburn authorization block in an initializer file

Afterburn.authorize ENV['TRELLO_USER_NAME'] do |auth|
  auth.trello_user_key = ENV['TRELLO_USER_KEY']
  auth.trello_user_secret = ENV['TRELLO_USER_SECRET']
  auth.trello_app_token = ENV['TRELLO_APP_TOKEN']
end