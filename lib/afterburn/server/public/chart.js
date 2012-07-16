var Afterburn = {};
Afterburn.Chart = function(board) {
  var self = this;
  self.id = board.id;
  self.name = board.name;
};

Afterburn.Chart.prototype = {
  categories: function() {
    var self = this;
    return self.board.categories;
  },

  series: function() {
    // [
    //     <% @data[board.id]['series'].each do |serie| %>
    //       {
    //         name: "<%= serie['name'] %>",
    //         data: [<%= serie['data'].join(",") %>]
    //       },
    //     <% end %>
    //   ]
    return 
  },

  render: function() {
    var self = this;
    new Highcharts.Chart({
      chart: {
        renderTo: "container_" + self.id,
        type: 'area'
      },
      title: {
        text: "Cumulative flow diagram for "+self.name+"board"
      },
      xAxis: {
        categories: self.categories(),
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
      series: self.series()
    });
  }
};
