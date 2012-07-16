#
# 1. Get your trello key and secret: 
# => https://trello.com/1/appKey/generate.
# 2. Generate an app token for afterburn: 
# => https://trello.com/1/connect?key=PUBLIC_KEY_FROM_ABOVE&name=MyApp&response_type=token&scope=read,write,account&expiration=never
# 3. Use the afterburn authorization block in an initializer file

Afterburn.authorize 'rossta' do |auth|
  auth.trello_user_key = "trello-user-key"
  auth.trello_user_secret = "trello-user-secret"
  auth.trello_app_token = "trello-user-token"
end
