# Afterburn

Afterburn is tool for tracking progress of Trello projects.

## Frontend

### Rails 3

You can mount Afterburn on a subpath in your existing Rails 3 app adding this to routes.rb:

```ruby
mount Afterburn::Server.new, :at => "/afterburn"
```
### TODOS

* Better graph?
* Display Lead Time (LT), where LT is the time that has passed between a given
number of cards (features) in WIP take to reach be COMPLETED
* Display Throughput, where throughput is the number of cards that reach
COMPLETED within the given internal
* Display Cycle Time (CT), where CT is the amount of time it take to complete a
card; CT is the inverse of Throughput
* Display WIP Total (WT), where WT is the total number of cards in progress at a given time
* Display Arrival Rate (AR), where AR is the number of cards that move from Backlog to WIP in
a given interval; this informs Little's Law, where WIP = Arrival Rate * Lead Time

