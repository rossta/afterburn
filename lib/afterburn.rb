require 'trello'

module Afterburn
  autoload :RedisConnection, "afterburn/redis_connection"
  autoload :Helpers, "afterburn/helpers"
  autoload :TrelloObjectWrapper, "afterburn/trello_object_wrapper"
  autoload :Board, "afterburn/board"
  autoload :Member, "afterburn/member"
  autoload :List, "afterburn/list"
  autoload :ListMetric, "afterburn/list_metric"
  autoload :BoardInterval, "afterburn/board_interval"
  autoload :Project, "afterburn/project"
  autoload :Server, "afterburn/server"

  extend RedisConnection
  extend self

  include Trello
  include Trello::Authorization
  
  def authorize(member_name)
    Afterburn::Member.find(member_name).tap do |member|
      Trello::Authorization.const_set :AuthPolicy, OAuthPolicy
      OAuthPolicy.consumer_credential = OAuthCredential.new member.trello_user_key, member.trello_user_secret
      OAuthPolicy.token = OAuthCredential.new member.trello_app_token, nil
    end
  end
end
