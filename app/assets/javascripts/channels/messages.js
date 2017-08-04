/*global App:true*/
App.messages = App.cable.subscriptions.create('MessagesChannel', {
  received: function(respond) {
    var notice;
    if(respond.dish)
      notice = respond.dish;
    else
      notice = respond.combo;
    notice += ' ' + respond.status;
    if(respond.table_id){
      notice = I18n.t('new_order');
      if(respond.action == 'create'){
        $('#show-order').load(document.URL + ' #orders-index');
      } else {
        $('.order_day_' + respond.id).text(respond.day);
        $('.order_time_in_' + respond.id).text(respond.time_in);
        $('.order_name_' + respond.id).text(respond.name);
        $('.order_table_' + respond.id).text(respond.table);
        $('.order_capacity_' + respond.id).text(respond.capacity);
        $('.order_discount_' + respond.id)
          .html(respond.discount + ' <i class="fa fa-percent"></i>');
        $('.order_status_' + respond.id + ' span a').text(respond.status);

        switch(respond.status){
        case 'uncheck', 'declined':
          $('.order_status_' + respond.id).find('span')
            .attr('class', 'label-red');
          break;
        case 'approved':
          $('.order_status_' + respond.id).find('span')
            .attr('class', 'label-green');
          break;
        case 'serving', 'done':
          $('.order_status_' + respond.id).find('span')
            .attr('class', 'label-blue');
          break;
        }

        if(respond.status == 'serving' || respond.status == 'uncheck') {
          $('.order_status_' + respond.id).find('span').addClass('animated bounce');
        } else {
          $('.order_status_' + respond.id).find('span').removeClass('animated bounce');
        }

      }
    }
    location.reload();

    $('.flash-push.success').remove();
    $('<div><div class="flash-push success">' + notice + '</div></div>')
      .prependTo('.navbar.navbar-default.navbar-static-top.fadeInDownBig');
  },
});
