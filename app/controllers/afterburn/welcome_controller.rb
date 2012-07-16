require_dependency "afterburn/application_controller"

module Afterburn
  class WelcomeController < ApplicationController
    def index
      @board = Afterburn::Board.fetch_by_member("rossta")
    end
  end
end
