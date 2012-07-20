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

Burn.Project = Ember.Object.extend({
  id: "1234",
  name: "Project X"
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
          router.get('applicationController').connectOutlet({
            name: 'sidebar',
            outletName: 'sidebar',
            context: [Burn.Project.create()]
          });
          router.get('applicationController').connectOutlet({
            name: 'projects',
            context: [Burn.Project.create()]
          });
        }
      }),

      show: Ember.Route.extend({
        route: '/:project_id',

        connectOutlets: function(router, project) {
          var project = Burn.Project.create()
          router.get('applicationController').connectOutlet('project', project);
        }
      })
    })
  })
});

Burn.initialize(router);
