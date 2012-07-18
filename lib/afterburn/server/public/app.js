Burn = Ember.Application.create({
  rootElement: $('#main')
});  
var router = Burn.router = Ember.Router.create({
  location: 'hash'
});

Burn.initialize(router);
