if !(ENV['TRELLO_USER_KEY'] && ENV['TRELLO_USER_SECRET'])
raise <<-WARNING

  Set up your trello key information. You can get this information at https://trello.com/1/appKey/generate

  export TRELLO_USER_KEY=your_public_trello_key
  export TRELLO_USER_SECRET=your_trello_secret

  Then visit https://trello.com/1/connect?key=your_public_trello_key&name=afterburn&response_type=token&scope=read,write,account&expiration=never

  export TRELLO_APP_TOKEN=your_app_token

WARNING
end

require 'trello'

include Trello
include Trello::Authorization

Trello::Authorization.const_set :AuthPolicy, OAuthPolicy
OAuthPolicy.consumer_credential = OAuthCredential.new ENV['TRELLO_USER_KEY'], ENV['TRELLO_USER_SECRET']
OAuthPolicy.token = OAuthCredential.new ENV['TRELLO_APP_TOKEN'], nil