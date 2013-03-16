var Updater = function() {
  this.isPlotted = false;
  this.options = {
    series: {
      shadowSize: 0
    },

    yaxis: {
    },

    xaxis: {
      mode: "time",
      minTickSize: [1, "hour"],
      timeformat: "%H:%I:%S"
    }
  }

  var self = this;
  setInterval(function() { self.updateChart() }, 3000);
}

Updater.prototype.plot = function(data) {
  this.chart = $.plot("#chart", data, this.options);
};

Updater.prototype.updateChart = function() {
  var self = this;

  $.get("/events", function(response) {
    self.plot(response.chartData);
  });
};

new Updater();
