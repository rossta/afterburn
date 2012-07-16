module Afterburn
  class Authorization
    include Trello
    include Trello::Authorization

    attr_accessor :trello_user_key, :trello_user_secret, :trello_app_token

    def initialize(member_name)
      @member_name = member_name
    end

    def configure
      yield self if block_given?
      Trello::Authorization.const_set :AuthPolicy, OAuthPolicy
      OAuthPolicy.consumer_credential = OAuthCredential.new trello_user_key, trello_user_secret
      OAuthPolicy.token = OAuthCredential.new trello_app_token, nil
      Afterburn::Member.add_member(member)
    end

    def trello_user_key
      @trello_user_key ||= member.trello_user_key
    end

    def trello_user_secret
      @trello_user_secret ||= member.trello_user_secret
    end

    def trello_app_token
      @trello_app_token ||= member.trello_app_token
    end

    def member
      Afterburn::Member.find(@member_name)
    end
  end
end