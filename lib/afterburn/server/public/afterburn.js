var Afterburn = {
  setup: function(projects) {
    _(projects).each(function(project) {
      new Afterburn.Chart(project).render();
    });
  }
};

Afterburn.Chart = function(project) {
  console.log(project);
  var self = this;
  self.project = project;
  self.id = project.id;
  self.name = project.name;
};

Afterburn.Chart.prototype = {

  render: function() {
    var self = this;
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
