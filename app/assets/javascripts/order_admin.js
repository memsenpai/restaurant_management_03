$(document).on('click','#btn-add-dish',function(){
  var order_id = $('.order-id').text();
  $.get('/admin/orders/'+ order_id +'/order_dishes/new', function(data){
    $('#new-dish-row').append(data);
  });
});

$(document).on('click','#btn-add-combo',function(){
  var order_id = $('.order-id').text();
  $.get('/admin/orders/'+ order_id +'/order_combos/new', function(data){
    $('#new-dish-row').append(data);
  });
});

$(document).on('change', '.select-in-order', function(){
  var dish_id = $(this).val();
  $(this).parent().parent().parent().data('id' + dish_id);
});

$(document).on('click', '#dish-delete', function(){
  $(this).parent().remove();
});

$(document).on('click', '.close', function(){
  $('.modal').hide();
});

$(document).on('click','#btn-save-order',function(){
  addDish(0, $('#new-dish-row .new-dish-row').length);
  addCombo(0, $('#new-dish-row .new-combo-row').length);
});

function addCombo(index, length) {
  if(index < length){
    var element = $('#new-dish-row .new-combo-row')[index];
    var combo_id = $(element).find('#new_order_combo :selected').val();
    var combo_quantity = $(element).find('#new_order_combo_quantity').val();
    var order_id = $('.order-id').text();
    var link_create_order_combo = '/admin/orders/'+ order_id +'/order_combos';
    $.ajax({
      type:'POST',
      url: link_create_order_combo,
      data: {
        order_combo: {
          combo_id: combo_id,
          quantity: combo_quantity
        }
      }
    }).success(function(d){
      setTimeout(function(){
        if(index + 1 < length) {addCombo(index + 1, length);}
        if(index + 1 == length) {
          $('.items-table').replaceWith(d);
        }
      },500);
    });
  }
}

function addDish(index, length) {
  if(index < length){
    var element = $('#new-dish-row .new-dish-row')[index];
    var dish_id = $(element).find('#new_order_dish :selected').val();
    var dish_quantity = $(element).find('#new_order_dish_quantity').val();
    var order_id = $('.order-id').text();
    var link_create_order_dish = '/admin/orders/'+ order_id +'/order_dishes';
    $.ajax({
      type:'POST',
      url: link_create_order_dish,
      data: {
        order_dish: {
          dish_id: dish_id,
          quantity: dish_quantity
        }
      }
    }).success(function(d){
      setTimeout(function(){
        if(index + 1 < length) {addDish(index + 1, length);}
        if(index + 1 == length) {
          $('.items-table').replaceWith(d);
        }
      },500);
    });
  }
}
