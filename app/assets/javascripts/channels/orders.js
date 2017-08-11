if (window.location.pathname == '/admin/orders') {
  App.orders = App.cable.subscriptions.create ('OrdersChannel', {
    received: function (respond) {
      var notice;
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
        $('.order_code_' + respond.id + ' span a').text(respond.status);
        var next_status = respond.status;
        switch(respond.status){
        case 'declined':
          $('.order_status_' + respond.id).find('span')
            .attr('class', 'label-red');
          $('.order_' + respond.id).addClass('text-cross-line');
          next_status = 'approved';
          break;
        case 'approved':
          $('.order_status_' + respond.id).find('span')
            .attr('class', 'label-green');
          $('.order_' + respond.id).removeClass('text-cross-line');
          next_status = 'serving';
          break;
        case 'serving':
        case 'done':
          $('.order_status_' + respond.id).find('span')
            .attr('class', 'label-blue');
          $('.order_' + respond.id).removeClass('text-cross-line');
          next_status = 'done';
          break;
        }

        if(respond.status == 'serving' || respond.status == 'uncheck') {
          $('.order_status_' + respond.id).find('span')
            .addClass('animated bounce');
        } else {
          $('.order_status_' + respond.id).find('span')
            .removeClass('animated bounce');
        }
        if(respond.reasons) {
          $('.order_' + respond.id).attr('title', respond.reasons);
        }

        $('.order_status_' + respond.id).find('span').text(respond.status);

        $('.modal[data-id=' + respond.id + ']').find('span.modal-status')
          .text(next_status);
        var url = $('.modal[data-id=' + respond.id + ']')
          .find('a[data-remote=true]').attr('href').split('=');
        $('.modal[data-id=' + respond.id + ']').find('a[data-remote=true]')
          .attr('href', url[0] + '=' + next_status);

        $('.flash-push.success').remove();
        $('<div><div class="flash-push success">' + notice + '</div></div>')
          .prependTo('.navbar.navbar-default.navbar-static-top.fadeInDownBig');
      }
    }
  });
}
