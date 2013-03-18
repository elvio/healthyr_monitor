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

  var table = $("#slowest_database");
  table.find("tr").not(".header").remove();

  for (var i=0; i < stats.database.length; i++) {
    var stat = stats.database[i];
    var tr = $("<tr></tr>");
    tr.append($("<td></td>").html(stat.value));
    tr.append($("<td></td>").html(stat.time.total));
    tr.append($("<td></td>").html(stat.reported_at));
    table.append(tr);
  }

  table = $("#slowest_view");
  table.find("tr").not(".header").remove();

  for (var i=0; i < stats.view.length; i++) {
    var stat = stats.view[i];
    var tr = $("<tr></tr>");
    tr.append($("<td></td>").html(stat.value));
    tr.append($("<td></td>").html(stat.time.total));
    tr.append($("<td></td>").html(stat.reported_at));
    table.append(tr);
  }

  table = $("#slowest_controller");
  table.find("tr").not(".header").remove();

  for (var i=0; i < stats.controller.length; i++) {
    var stat = stats.controller[i];
    var tr = $("<tr></tr>");
    tr.append($("<td></td>").html(stat.value));
    tr.append($("<td></td>").html(stat.time.db));
    tr.append($("<td></td>").html(stat.time.view));
    tr.append($("<td></td>").html(stat.time.total));
    tr.append($("<td></td>").html(stat.reported_at));
    table.append(tr);
  }
};

Updater.prototype.update = function() {
  var self = this;

  $.get("/events", function(response) {
    self.updateChart(response);
    self.updateStats(response);
  });
};

new Updater();
