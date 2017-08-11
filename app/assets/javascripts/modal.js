$(document).on('turbolinks:load', function(){
  $(document).on('click', '.dish-item-id', function () {
    var id = $(this).attr('data-id');
    $('.orderdish_' + id).show();
  });

  $(document).on('click', '.combo-item-id', function () {
    var id = $(this).attr('data-id');
    $('.ordercombo_' + id).show();
  });
$(document).on('turbolinks:load', function () {
  if(window.location.pathname != "/admin/orders"){
    $(document).on('click', '.cancel-dish-order', function () {
      var data_split = $(this).attr('data-id').split('_');
      var id = data_split[0];
      var order_id = data_split[1];
      var staff_id = $('#staff_id').val();
      var url = '/admin/orders/' + order_id + '/order_dishes/' + id;
      $('.cancel[data-id=' + id + ']').show();
      $(document).on('click', '.submit-cancel-item', function(){
        var describe = $('input[data=' + id + ']').val();
        var data = {'order_dish': {'status': 'cancel',
          'reasons_attributes': {
            '0': {'describe': describe, 'staff_id': staff_id}
          }}};
        $.ajax({
          url: url,
          type: 'PATCH',
          data: data,
          success: function(){
            $('.cancel[data-id=' + id + ']').css('display', 'none');
          }
        });
      });
    });

    $(document).on('click', '.cancel-combo-order', function () {
      var data_split = $(this).attr('data-id').split('_');
      var id = data_split[0];
      var order_id = data_split[1];
      var staff_id = $('#staff_id').val();
      var url = '/admin/orders/' + order_id + '/order_combos/' + id;
      $('.cancel[data-id=' + id + ']').show();
      $(document).on('click', '.submit-cancel-item', function(){
        var describe = $('input[data=' + id + ']').val();
        var data = {'order_combo': {'status': 'cancel',
          'reasons_attributes': {
            '0': {'describe': describe, 'staff_id': staff_id}
          }}};
        $.ajax({
          url: url,
          type: 'PATCH',
          data: data,
          success: function(){
            $('.cancel[data-id=' + id + ']').css('display', 'none');
          }
        });
      });
    });
  }
});

  $(document).on('click', '.btn-show-customer', function() {
    var id = $(this).parent().parent().find('#customer-id').data('id');
    $('.show-info-customer-' + id).show();
    return false;
  });
});
