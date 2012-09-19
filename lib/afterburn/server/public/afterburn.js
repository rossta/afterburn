(function(context) {
  var _ = context._;
  var $ = context.$;
  var Highcharts = context.Highcharts;

  var Afterburn = {
    setup: function(projects) {
      _(projects).each(render);
    },
    render: function(project) {
      new Afterburn.Highchart(project).render();
    },
    debug: function(project) {
      new Afterburn.RickshawChart(project).render();
    },
    assert: function(name, object) {
      if (!object) {
        throw(""+name+"not defined");
      } else {
        console.log(name, object);
      }
    }
  };

  Afterburn.RickshawChart = function() {
    this.palette = new Rickshaw.Color.Palette( { scheme: 'classic9' } );
  };

  _.extend(Afterburn.RickshawChart.prototype, {

    render: function() {
      // set up our data series with 50 random data points
      var self = this,
          seriesData = [ [], [], [], [], [], [], [], [], [] ],
          random = new Rickshaw.Fixtures.RandomData(150),
          palette = self.palette;

      for (var i = 0; i < 150; i++) {
        random.addData(seriesData);
      }

      // instantiate our graph!

      var graph = new Rickshaw.Graph( {
        element: document.getElementById("chart"),
        width: 900,
        height: 500,
        renderer: 'area',
        stroke: true,
        series: [
          {
            color: palette.color(),
            data: seriesData[0],
            name: 'Moscow'
          }, {
            color: palette.color(),
            data: seriesData[1],
            name: 'Shanghai'
          }, {
            color: palette.color(),
            data: seriesData[2],
            name: 'Amsterdam'
          }, {
            color: palette.color(),
            data: seriesData[3],
            name: 'Paris'
          }, {
            color: palette.color(),
            data: seriesData[4],
            name: 'Tokyo'
          }, {
            color: palette.color(),
            data: seriesData[5],
            name: 'London'
          }, {
            color: palette.color(),
            data: seriesData[6],
            name: 'New York'
          }
        ]
      } );

      graph.render();

      this.addSlider(graph);
      this.addHoverDetail(graph);

      var annotator = new Rickshaw.Graph.Annotate( {
        graph: graph,
        element: document.getElementById('timeline')
      } );

      var legend = this.addLegend(graph);

      var shelving = new Rickshaw.Graph.Behavior.Series.Toggle( {
        graph: graph,
        legend: legend
      } );

      var order = new Rickshaw.Graph.Behavior.Series.Order( {
        graph: graph,
        legend: legend
      } );

      var highlighter = new Rickshaw.Graph.Behavior.Series.Highlight( {
        graph: graph,
        legend: legend
      } );

      var smoother = new Rickshaw.Graph.Smoother( {
        graph: graph,
        element: $('#smoother')
      } );

      var ticksTreatment = 'glow';

      var xAxis = new Rickshaw.Graph.Axis.Time( {
        graph: graph,
        ticksTreatment: ticksTreatment
      } );

      xAxis.render();

      var yAxis = new Rickshaw.Graph.Axis.Y( {
        graph: graph,
        tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
        ticksTreatment: ticksTreatment
      } );

      yAxis.render();

      // add some data every so often

      var messages = [
        "Changed home page welcome message",
        "Minified JS and CSS",
        "Changed button color from blue to green",
        "Refactored SQL query to use indexed columns",
        "Added additional logging for debugging",
        "Fixed typo",
        "Rewrite conditional logic for clarity",
        "Added documentation for new methods"
      ];

      setInterval( function() {
        random.addData(seriesData);
        graph.update();
      }, 3000 );

      function addAnnotation(force) {
        if (messages.length > 0 && (force || Math.random() >= 0.95)) {
          annotator.add(seriesData[2][seriesData[2].length-1].x, messages.shift());
        }
      }

      addAnnotation(true);
      setTimeout( function() { setInterval( addAnnotation, 6000 ) }, 6000 );
    },

    addSlider: function(graph) {
      var slider = new Rickshaw.Graph.RangeSlider( {
        graph: graph,
        element: $('#slider')
      });
      return slider;
    },

    addHoverDetail: function(graph) {
      var hoverDetail = new Rickshaw.Graph.HoverDetail( {
        graph: graph
      } );
      return hoverDetail;
    },

    addLegend: function(graph) {
      var legend = new Rickshaw.Graph.Legend( {
        graph: graph,
        element: document.getElementById('legend')
      });
      return legend;
    }
  });


  Afterburn.Highchart = function(project) {
    var self = this;
    self.project = project;
    self.id = project.id;
    self.name = project.name;
  };

  Afterburn.Highchart.prototype = {

    render: function() {
      var self = this;
      Afterburn.assert("Project series", self.project.series);
      Afterburn.assert("Project categories", self.project.categories);

      Highcharts.setOptions({
        xAxis: {
          gridLineWidth: 1
        },
        yAxis: {
          minorTickInterval: 'auto'
        }
      });
      new Highcharts.Chart({
        chart: {
          renderTo: "project_" + self.id,
          type: 'area',
          zoomType: 'x'
        },
        title: {
          text: "Cumulative flow diagram for "+self.name+" project"
        },
        xAxis: {
          type: 'datetime',
          // maxZoom: 14 * 24 * 3600000, // fourteen days
          maxZoom: 1 * 24 * 3600000, // 1 day
          tickInterval: 1 * 24 * 3600000, // 1 day
          tickmarkPlacement: 'on',
          title: {
            enabled: false
          }
        },
        yAxis: {
          title: {
            text: 'Cards'
          },
          labels: {
            formatter: function() {
              return this.value;
            }
          }
        },
        tooltip: {
          formatter: function() {
            return ''+
            Highcharts.dateFormat('%A %B %e, %Y', new Date(this.x)) +': '+ Highcharts.numberFormat(this.y, 0, ',') +' cards';
          }
        },
        plotOptions: {
          area: {
            stacking: 'normal',
            lineColor: '#666666',
            lineWidth: 1,
            marker: {
              lineWidth: 1,
              lineColor: '#666666'
            }
          },
          series: {
            cursor: 'pointer',
            point: {
              events: {
                click: function() {
                  console.log("click", this.x, this.y);
                }
              }
            },
            marker: {
              lineWidth: 1
            }
          }

        },
        series: self.project.series
      });
    }
  };

  Afterburn.RenderControls = function(args) {

    this.initialize = function() {

      this.element = args.element;
      this.graph = args.graph;
      this.settings = this.serialize();

      this.inputs = {
        renderer: this.element.elements.renderer,
        interpolation: this.element.elements.interpolation,
        offset: this.element.elements.offset
      };

      this.element.addEventListener('change', function(e) {

        this.settings = this.serialize();

        if (e.target.name == 'renderer') {
          this.setDefaultOffset(e.target.value);
        }

        this.syncOptions();
        this.settings = this.serialize();

        var config = {
          renderer: this.settings.renderer,
          interpolation: this.settings.interpolation
        };

        if (this.settings.offset == 'value') {
          config.unstack = true;
          config.offset = 'zero';
        } else if (this.settings.offset == 'expand') {
          config.unstack = true;
          config.offset = this.settings.offset;
        } else {
          config.unstack = false;
          config.offset = this.settings.offset;
        }

        this.graph.configure(config);
        this.graph.render();

      }.bind(this), false);
    }

    this.serialize = function() {

      var values = {};
      var pairs = $(this.element).serializeArray();

      pairs.forEach( function(pair) {
        values[pair.name] = pair.value;
      } );

      return values;
    };

    this.syncOptions = function() {

      var options = this.rendererOptions[this.settings.renderer];

      Array.prototype.forEach.call(this.inputs.interpolation, function(input) {

        if (options.interpolation) {
          input.disabled = false;
          input.parentNode.classList.remove('disabled');
        } else {
          input.disabled = true;
          input.parentNode.classList.add('disabled');
        }
      });

      Array.prototype.forEach.call(this.inputs.offset, function(input) {

        if (options.offset.filter( function(o) { return o == input.value } ).length) {
          input.disabled = false;
          input.parentNode.classList.remove('disabled');

        } else {
          input.disabled = true;
          input.parentNode.classList.add('disabled');
        }

      }.bind(this));

    };

    this.setDefaultOffset = function(renderer) {

      var options = this.rendererOptions[renderer];

      if (options.defaults && options.defaults.offset) {

        Array.prototype.forEach.call(this.inputs.offset, function(input) {
          if (input.value == options.defaults.offset) {
            input.checked = true;
          } else {
            input.checked = false;
          }

        }.bind(this));
      }
    };

    this.rendererOptions = {

      area: {
        interpolation: true,
        offset: ['zero', 'wiggle', 'expand', 'value'],
        defaults: { offset: 'zero' }
      },
      line: {
        interpolation: true,
        offset: ['expand', 'value'],
        defaults: { offset: 'value' }
      },
      bar: {
        interpolation: false,
        offset: ['zero', 'wiggle', 'expand', 'value'],
        defaults: { offset: 'zero' }
      },
      scatterplot: {
        interpolation: false,
        offset: ['value'],
        defaults: { offset: 'value' }
      }
    };

    this.initialize();
  };


  context.Afterburn = Afterburn;
  return Afterburn;
})(window);
