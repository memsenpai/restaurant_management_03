$(document).on('turbolinks:load', function(){
  fetchStaffData(2017);

  var d = new Date();
  $('#order-trigger').click(function(){
    fetchOrderData(1, d.getMonth() + 1, d.getFullYear(), 'DESC', 'month');
  });

  $('#fetch-button').click(function(){
    var week = $('#week-selector').val();
    var month = $('#month-selector').val();
    var year = $('#year-selector').val();
    var order_by = $('#order-selector').val();
    var group_by = $('input[name="my-radio"]:checked').val();
    fetchOrderData(week, month, year, order_by, group_by);
  });

  $('#week-radio').on('click', function(){
    $('#week-selector').show();
  });

  $('#month-radio').on('click', function(){
    $('#week-selector').hide();
  });

  updateWeekSelector(d.getFullYear(), d.getMonth() + 1);

  $('#month-selector').on('change', function(){
    updateWeekSelector($('#year-selector').val(), $('#month-selector').val());
  });

  $('#year-selector').on('change', function(){
    updateWeekSelector($('#year-selector').val(), $('#month-selector').val());
  });
});

function fetchStaffData(year){
  $.ajax({
    type: 'GET',
    url: '/api/charts/staffs',
    contentType: 'application/json; charset=utf-8',
    dataType: 'json',
    data: {year: year},
    success: function(data){
      initStaffChart(data.staff);
    }
  });
}

function fetchOrderData(week, month, year, order_by, group_by){
  $.ajax({
    type: 'GET',
    url: '/api/charts/orders',
    contentType: 'application/json; charset=utf-8',
    dataType: 'json',
    data: {
      week: week,
      month: month,
      year: year,
      order_by: order_by,
      group_by: group_by
    },
    success: function(data){
      initOrderChart(data.dishes);
    }
  });
}

function initStaffChart(data) {
  $('#staff').siblings().hide();
  $('#staff').show();
  $('#staff-chart').highcharts({
    chart: {
      type: 'column'
    },
    title: {
      text: I18n.t('dashboard.orderchart.title.text')
    },
    xAxis: {
      categories: Object.keys(Object.values(data)[0]),
      crosshair: true
    },
    yAxis: {
      min: 0,
      title: {
        text: 'Staffs'
      }
    },
    tooltip: {
      headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
      pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
        '<td style="padding:0"><b>{point.y}</b></td></tr>',
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
    series:
    [
      {
        name: Object.keys(data)[0],
        data: Object.values(Object.values(data)[0]),
      },
      {
        name: Object.keys(data)[1],
        data: Object.values(Object.values(data)[1]),
      },
      {
        name: Object.keys(data)[2],
        data: Object.values(Object.values(data)[2]),
      },
      {
        name: Object.keys(data)[3],
        data: Object.values(Object.values(data)[3]),
      }
    ]
  });
}

function initOrderChart(data){
  $('#order').siblings().hide();
  $('#order').show();
  $('#order-chart').highcharts({
    chart: {
      type: 'column'
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
      pointFormat: I18n.t('dashboard.orderchart.pointformat', point: {point.y})
    },
    series: [{
      name: I18n.t('dashboard.orderchart.series.name'),
      data: data,
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

function getNumberOfMonth(year, month){
  var firstOfMonth = new Date(year, month - 1, 1);
  var lastOfMonth = new Date(year, month, 0);
  var firstDay = firstOfMonth.getDay();
  if(firstDay == 7)
    firstDay = 1;
  else
    firstDay += 1;
  var used = firstOfMonth.getDay() % 7 + 1 + lastOfMonth.getDate();
  return Math.ceil(used / 7);
}

function updateWeekSelector(year, month){
  $('#week-selector').empty();
  var numberofmonth = getNumberOfMonth(year, month);
  for(var i = 0; i < numberofmonth; i++){
    $('#week-selector').append('<option>' + (i + 1) + '</option>');
  }
}
