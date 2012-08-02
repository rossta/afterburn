module TrelloHelper
  def authorize_account
    Afterburn.authorize ENV['TRELLO_USER_NAME'] do |auth|
      auth.trello_user_key = ENV['TRELLO_USER_KEY']
      auth.trello_user_secret = ENV['TRELLO_USER_SECRET']
      auth.trello_app_token = ENV['TRELLO_APP_TOKEN']
    end
  end

  def fetch_trello_member
    authorize_account if Afterburn.current_member.nil?
    Afterburn.current_member
  end

  def fetch_trello_boards
    fetch_trello_member.trello_boards
  end

  def fetch_trello_board
    fetch_trello_boards.first
  end

  def fetch_trello_list
    fetch_trello_board.lists.first
  end

end

RSpec.configuration.send(:include, TrelloHelper)