Rails.application.routes.draw do

  mount Afterburn::Server.new => "/afterburn", :as => :burn
end
