var StatsTable = function(data, elementId, timeFields) {
  this.data = data;
  this.table = $("#" + elementId);
  this.timeFields = timeFields;

  this.__update();
};

StatsTable.prototype.__update = function() {
  this.table.find("tr").not(".header").remove();

  for (var i=0; i < this.data.length; i++) {
    var stat = this.data[i];
    var tr = $("<tr></tr>");

    tr.append($("<td></td>").html(stat.value));
    for (var j=0; j < this.timeFields.length; j++) {
      var field = this.timeFields[j];
      tr.append($("<td></td>").html(stat.time[field]));
    }
    tr.append($("<td></td>").html(stat.time.total));
    tr.append($("<td></td>").html(stat.reported_at));
    this.table.append(tr);
  }
}

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
  setInterval(function() { self.update() }, 3000);
}

Updater.prototype.plot = function(data) {
  this.chart = $.plot("#chart", data, this.options);
};

Updater.prototype.updateChart = function(response) {
  this.plot(response.chartData);
};

Updater.prototype.updateStats = function(response) {
  var stats = response.slowestStats;
  var database = new StatsTable(stats.database, "slowest_database", []);
  var view = new StatsTable(stats.view, "slowest_view", []);
  var controller = new StatsTable(stats.controller, "slowest_controller", ['db', 'view']);
};

Updater.prototype.update = function() {
  var self = this;

  $.get("/events", function(response) {
    self.updateChart(response);
    self.updateStats(response);
  });
};

new Updater();
