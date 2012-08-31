# Afterburn

Afterburn is tool for tracking progress of Trello projects.

## Frontend

### Rails 3

You can mount Afterburn on a subpath in your existing Rails 3 app adding this to routes.rb:

```ruby
mount Afterburn::Server.new, :at => "/afterburn"
```
