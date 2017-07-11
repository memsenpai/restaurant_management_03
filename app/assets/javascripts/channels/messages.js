/*global App:true*/
App.messages = App.cable.subscriptions.create('MessagesChannel', {
  received: function() {
    $('#chef-home-page').load(document.URL + ' #order-list-in-chef');
  },
});
