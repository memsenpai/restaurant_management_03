if( window.location.pathname == '/admin/chef') {
  App.messages = App.cable.subscriptions.create('MessagesChannel', {
    received: function(respond) {
      var notice;
      if(respond.dish)
        notice = respond.dish;
      else
        notice = respond.combo;
      notice += ' ' + respond.status;
      location.reload();

      $('.flash-push.success').remove();
      $('<div><div class="flash-push success">' + notice + '</div></div>')
        .prependTo('.navbar.navbar-default.navbar-static-top.fadeInDownBig');
    },
  });
}
