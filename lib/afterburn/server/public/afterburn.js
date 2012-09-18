(function(context) {
  var _ = context._;
  var $ = context.$;
  var Highcharts = context.Highcharts;

  var Afterburn = {
    setup: function(projects) {
      _(projects).each(render);
    },
    render: function(project) {
      new Afterburn.Chart(project).render();
    },
    assert: function(name, object) {
      if (!object) {
        throw(""+name+"not defined");
      } else {
        console.log(name, object);
      }
    }
  };

  Afterburn.Chart = function(project) {
    var self = this;
    self.project = project;
    self.id = project.id;
    self.name = project.name;
  };

  Afterburn.Chart.prototype = {

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

  context.Afterburn = Afterburn;
  return Afterburn;
})(window);
