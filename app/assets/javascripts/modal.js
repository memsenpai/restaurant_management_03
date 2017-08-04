$(document).on('turbolinks:load', function(){
  $(document).on('click', '.dish-item-id', function () {
    var id = $(this).attr('data-id');
    $('.orderdish_' + id).show();
  });
  $(document).on('click', '.combo-item-id', function () {
    var id = $(this).attr('data-id');
    $('.ordercombo_' + id).show();
  });
  $(document).on('click', '.cancel-dish-order', function () {
    var data_split = $(this).attr('data-id').split('_');
    var id = data_split[0];
    var order_id = data_split[1];
    var url = '/admin/orders/' + order_id + '/order_dishes/' + id;
    $.ajax({
      url: url,
      type: 'PATCH',
      data: {'order_dish': {'status': 'cancel'}}
    });
  });
  $(document).on('click', '.cancel-combo-order', function () {
    var data_split = $(this).attr('data-id').split('_');
    var id = data_split[0];
    var order_id = data_split[1];
    var url = '/admin/orders/' + order_id + '/order_combos/' + id;
    $.ajax({
      url: url,
      type: 'PATCH',
      data: {'order_combo': {'status': 'cancel'}}
    });
  });
});
