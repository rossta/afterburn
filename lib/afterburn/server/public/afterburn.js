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
      if (!self.project.series) {
        console.log("Project series not defined");
        return;
      }
      if (!self.project.categories) {
        console.log("Project categories not defined");
        return;
      }

      new Highcharts.Chart({
        chart: {
          renderTo: "project_" + self.id,
          type: 'area'
        },
        title: {
          text: "Cumulative flow diagram for "+self.name+" project"
        },
        xAxis: {
          categories: self.project.categories,
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
            this.x +': '+ Highcharts.numberFormat(this.y, 0, ',') +' cards';
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
          }
        },
        series: self.project.series
      });
    }
  };

  context.Afterburn = Afterburn;
  return Afterburn;
})(window);