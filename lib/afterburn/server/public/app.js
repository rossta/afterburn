var Burn;

Burn = Ember.Application.create({
  rootElement: $('#main')
});  

Burn.ApplicationView = Ember.View.extend({
  templateName: 'application'
});

Burn.SidebarView = Ember.View.extend({
  templateName: 'sidebar'
});

Burn.ProjectsView = Ember.View.extend({
  templateName: 'projects'
});

Burn.ProjectView = Ember.View.extend({
  templateName: 'project'
});

Burn.ApplicationController = Ember.Controller.extend({});

Burn.SidebarController = Ember.ArrayController.extend({});

Burn.ProjectsController = Ember.ArrayController.extend({});

Burn.ProjectController = Ember.ArrayController.extend({});

Burn.store = DS.Store.create({
  revision: 4,
  adapter: DS.RESTAdapter.create()  // should just work as string 'DS.RESTAdapter'
});

Burn.Project = DS.Model.extend({
  id: DS.attr('string'),
  name: DS.attr('string'),
  enabled: DS.attr('boolean')
});

var router = Burn.router = Ember.Router.create({
  location: 'hash',

  root: Ember.Route.extend({
    index: Ember.Route.extend({
      route: '/',
      redirectsTo: 'projects.index'
    }),
    projects: Ember.Route.extend({
      route: '/projects',
      index: Ember.Route.extend({
        route: '/',
        showProject: Ember.Route.transitionTo('show'),
        connectOutlets: function(router, context) {
          var projects = Burn.Project.find()
          router.get('applicationController').connectOutlet({
            name: 'sidebar',
            outletName: 'sidebar',
            context: projects
          });
          router.get('applicationController').connectOutlet({
            name: 'projects',
            context: projects.objectAt(0)
          });
        }
      }),

      show: Ember.Route.extend({
        route: '/:project_id',

        connectOutlets: function(router, project) {
          router.get('applicationController').connectOutlet('project', project);
        }
      })
    })
  })
});

Burn.initialize(router);
