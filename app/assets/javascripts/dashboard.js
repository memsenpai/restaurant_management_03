$(document).on('turbolinks:load', function(){
  var df = new Date();
  df.setDate(df.getDate() - 30);
  var dt = new Date();

  fetchIncomeData(df.toString(), dt, 'DESC');

  $('#filter').hide();

  $('#dish-trigger').click(function (){
    $('#filter').show();
    fetchOrderDishData(df.toString(), dt, 'DESC');
  });

  $('#combo-trigger').click(function (){
    $('#filter').show();
    fetchOrderComboData(df.toString(), dt, 'DESC');
  });

  $('#timein-trigger').click(function (){
    $('#filter').show();
    fetchTimeinData(df.toString(), dt, 'DESC');
  });

  $('#income-trigger').click(function (){
    $('#filter').hide();
    fetchIncomeData(df.toString(), dt, 'DESC');
  });

  $('#fetch-dish-button').click(function(){
    var data = getFilterData();
    fetchOrderDishData(data.from, data.to, data.order_by);
  });

  $('#fetch-combo-button').click(function(){
    var data = getFilterData();
    fetchOrderComboData(data.from, data.to, data.order_by);
  });

  $('#fetch-timein-button').click(function(){
    var data = getFilterData();
    fetchTimeinData(data.from, data.to, data.order_by);
  });

  $('#fetch-income-button').click(function(){
    var data = getFilterData();
    fetchIncomeData(data.year);
  });

  $('#week-radio').on('click', function(){
    $('#week-selector').show();
  });

  $('#month-radio').on('click', function(){
    $('#week-selector').hide();
  });

  $('#from').datepicker();

  var dates = $('#from, #to').datepicker({
    defaultDate: '+1w',
    changeMonth: true,
    numberOfMonths: 1,
    minDate: $('#from').datepicker('getDate'),
    onSelect: function(selectedDate) {
      var option = this.id == 'from' ? 'minDate' : 'maxDate',
        instance = $(this).data('datepicker'),
        date = $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings);
      dates.not(this).datepicker('option', option, date);
    }
  });

  /*global Highcharts:true*/

  Highcharts.setOptions({
    global: {
      useUTC: false
    }
  });
});

function getFilterData(){
  var data = {
    from: $('#from').datepicker('getDate'),
    to: $('#to').datepicker('getDate'),
    order_by: $('#order-selector').val()
  };
  return data;
}

function fetchOrderDishData(from, to, order_by){
  $.ajax({
    type: 'GET',
    url: '/api/charts/dish_orders',
    contentType: 'application/json; charset=utf-8',
    dataType: 'json',
    data: {
      from: from,
      to: to,
      order_by: order_by
    },
    success: function(data) {
      initDishChart(data.dishes);
    }
  });
}

function fetchOrderComboData(from, to, order_by){
  $.ajax({
    type: 'GET',
    url: '/api/charts/combo_orders',
    contentType: 'application/json; charset=utf-8',
    dataType: 'json',
    data: {
      from: from,
      to: to,
      order_by: order_by
    },
    success: function(data) {
      initComboChart(data.combos);
    }
  });
}

function fetchTimeinData(from, to, order_by){
  $.ajax({
    type: 'GET',
    url: '/api/charts/timein',
    contentType: 'application/json; charset=utf-8',
    dataType: 'json',
    data: {
      from: from,
      to: to,
      order_by: order_by
    },
    success: function(data) {
      initTimeinChart(data.timein);
    }
  });
}

function fetchIncomeData(year){
  $.ajax({
    type: 'GET',
    url: '/api/charts/income',
    contentType: 'application/json; charset=utf-8',
    dataType: 'json',
    data: {
      year: year
    },
    success: function(data) {
      initIncomeChart(data.income);
    }
  });
}

function initDishChart(data) {
  $('#dish').siblings().hide();
  $('#dish').show();
  $('#dish-chart').highcharts({
    chart: {
      type: 'column'
    },
    plotOptions: {
      column: {
      }
    },
    title: {
      text: I18n.t('dashboard.orderchart.orderedtimes')
    },
    xAxis: {
      type: 'category',
      labels: {
        rotation: -45,
        style: {
          fontSize: '13px',
          fontFamily: 'Verdana, sans-serif'
        }
      }
    },
    yAxis: {
      allowDecimals: false,
      min: 0,
      title: {
        text: I18n.t('dashboard.orderchart.xaxistext')
      }
    },
    legend: {
      enabled: false
    },
    credits: {
      enabled: false
    },
    tooltip: {
      pointFormat: I18n.t('dashboard.orderchart.pointformat', {point: '{point.y}'})
    },
    series: [{
      name: I18n.t('dashboard.orderchart.series.name'),
      data: data,
      maxPointWidth: 50,
      dataLabels: {
        enabled: true,
        color: '#FFFFFF',
        format: '{point.y}',
        style: {
          fontSize: '16px',
          fontFamily: 'Verdana, sans-serif'
        }
      }
    }]
  });
}

function initComboChart(data) {
  $('#combo').siblings().hide();
  $('#combo').show();
  $('#combo-chart').highcharts({
    chart: {
      type: 'column'
    },
    title: {
      text: I18n.t('dashboard.combochart.orderedtimes')
    },
    xAxis: {
      type: 'category',
      labels: {
        rotation: -45,
        style: {
          fontSize: '13px',
          fontFamily: 'Verdana, sans-serif'
        }
      }
    },
    yAxis: {
      allowDecimals: false,
      min: 0,
      title: {
        text: I18n.t('dashboard.combochart.xaxistext')
      }
    },
    legend: {
      enabled: false
    },
    credits: {
      enabled: false
    },
    tooltip: {
      pointFormat: I18n.t('dashboard.orderchart.pointformat')
    },
    series: [{
      name: I18n.t('dashboard.combochart.series.name'),
      data: data,
      maxPointWidth: 50,
      dataLabels: {
        enabled: true,
        color: '#FFFFFF',
        format: '{point.y}',
        style: {
          fontSize: '16px',
          fontFamily: 'Verdana, sans-serif'
        }
      }
    }]
  });
}

function initTimeinChart(data) {
  $('#timein').siblings().hide();
  $('#timein').show();
  $('#timein-chart').highcharts({
    chart: {
      zoomType: 'x'
    },
    plotOptions: {
      column: {
      }
    },
    xAxis: {
      title: {
        enabled: true,
        text: 'Hours of the Day'
      },
      type: 'datetime',
      tickInterval: 3600 * 500,
      dateTimeLabelFormats : {
        hour: '%I %p',
        minute: '%I:%M %p'
      }
    },
    series: [{
      data: data,
      maxPointWidth: 50,
      name: 'Total order',
      pointInterval: 24 * 3600 * 1000
    }]
  });
}

function initIncomeChart(data) {
  $('#income').siblings().hide();
  $('#income').show();
  $('#income-chart').highcharts({
    chart: {
      type: 'column'
    },
    title: {
      text: I18n.t('dashboard.incomechart.title.text')
    },
    xAxis: {
      categories: [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ],
      crosshair: true
    },
    yAxis: {
      min: 0,
      title: {
        text: I18n.t('dashboard.incomechart.yaxis.title')
      }
    },
    tooltip: {
      headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
      pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
          '<td style="padding:0"><b>{point.y} $</b></td></tr>',
      footerFormat: '</table>',
      shared: true,
      useHTML: true
    },
    plotOptions: {
      column: {
        pointPadding: 0.2,
        borderWidth: 0
      }
    },
    series: data
  });
}
