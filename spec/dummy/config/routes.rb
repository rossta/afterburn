Rails.application.routes.draw do

  mount Afterburn::Engine => "/afterburn", :as => :burn
end
