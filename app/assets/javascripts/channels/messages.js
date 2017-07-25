/*global App:true*/
App.messages = App.cable.subscriptions.create('MessagesChannel', {
  received: function(respond) {
    var notice;
    if(respond.dish)
      notice = respond.dish;
    else
      notice = respond.combo;
    notice += ' ' + respond.status;
    if(respond.customer_id && respond.table_id){
      notice = I18n.t('new_order');
      $('#show-order').load(document.URL + ' #orders-index');
    }
    $('#chef-home-page').load(document.URL + ' #order-list-in-chef');
    $('.flash-push.success').remove();
    $('<div><div class="flash-push success">' + notice + '</div></div>')
      .prependTo('.navbar.navbar-default.navbar-static-top.fadeInDownBig');
  },
});
