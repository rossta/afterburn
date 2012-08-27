Rails.application.routes.draw do
  match "/" => redirect("/afterburn")
  mount Afterburn::Server.new => "/afterburn", :as => :burn
end
