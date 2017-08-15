$(document).on('turbolinks:load', function(){
  $('.owl-carousel').owlCarousel({
    autoPlay: 4000,
    touchDrag: true,
    stopOnHover: true,
    items: 2,
    itemsDesktop: [1119,2],
    itemsDesktopSmall: [979, 2],
    itemsTablet: [768,2],
    itemsMobile: [479,1]
  });
});

$(document).on('click', '.update-combo-quantity-in-cart', function() {
  var order_combo = $(this).data('id');
  var idQuantityOrderComboField = '#quantity-of-order-combo-' + order_combo;
  var idOrderComboRow = '#order-combo-row-' + order_combo;
  var idOrderComboTotalPrice = ' #order-combo-total-price-' + order_combo;
  var quantity = $(idQuantityOrderComboField).val();
  var url = '/order_combos/' + order_combo;

  $.ajax({
    type:'PATCH',
    url: url,
    data: {
      order_combo: {
        quantity: quantity,
        combo_id: order_combo
      }
    }
  }).success(function(){
    $(idOrderComboRow).load(document.URL + idOrderComboTotalPrice);
  });
});

$(document).on('click', '.delete-combo-in-cart', function() {
  var order_combo = $(this).data('id');
  var url = '/order_combos/' + order_combo;
  $.ajax({
    type:'DELETE',
    url: url,
    data: {
      order_combo: {
        id: order_combo
      }
    }
  }).success(function(){
    $('#cart-text').load(document.URL + ' #order-card-text');
    $('#cart-content').load(document.URL + ' #cart-content-list');
  });
});

$(document).on('click', '.update-dish-quantity-in-cart', function() {
  var order_dish = $(this).data('id');
  var idQuantityOrderDishField = '#quantity-of-order-dish-' + order_dish;
  var idOrderDishRow = '#order-dish-row-' + order_dish;
  var idOrderDishTotalPrice = ' #order-dish-total-price-' + order_dish;
  var quantity = $(idQuantityOrderDishField).val();
  var url = '/order_dishes/' + order_dish;
  $.ajax({
    type:'PATCH',
    url: url,
    data: {
      order_dish: {
        quantity: quantity,
        dish_id: order_dish
      }
    }
  }).success(function(){
    $(idOrderDishRow).load(document.URL + idOrderDishTotalPrice);
  });
});

$(document).on('click', '.delete-dish-in-cart', function() {
  var order_dish = $(this).data('id');
  var url = '/order_dishes/' + order_dish;
  $.ajax({
    type:'DELETE',
    url: url,
    data: {
      order_dish: {
        id: order_dish
      }
    }
  }).success(function(){
    $('#cart-text').load(document.URL + ' #order-card-text');
    $('#cart-content').load(document.URL + ' #cart-content-list');
  });
});

$(document).on('click', '.add-dish-to-cart', function() {
  var dish = $('.dish-id').val();
  var id = '#quantity-dish-order-' + dish;
  var quantity = $(id).val();
  var url = '/order_dishes';
  $.ajax({
    type:'POST',
    url: url,
    data: {
      order_dish: {
        quantity: quantity,
        dish_id: dish
      }
    }
  }).success(function(){
    $('#cart-text').load(document.URL + ' #order-card-text');
  });
});

$(document).on('click', '.add-combo-to-cart', function() {
  var combo = $('.combo-id').val();
  var id = '#quantity-combo-order-' + combo;
  var quantity = $(id).val();
  var url = '/order_combos';
  $.ajax({
    type:'POST',
    url: url,
    data: {
      order_combo: {
        quantity: quantity,
        combo_id: combo
      }
    }
  }).success(function(){
    $('#cart-text').load(document.URL + ' #order-card-text');
  });
});

$(document).on('click', '.dishes-item-add-to-cart', function() {
  var dish_id = $(this).parent().data('id');
  var url = '/order_dishes';
  $.ajax({
    type:'POST',
    url: url,
    data: {
      order_dish: {
        quantity: 1,
        dish_id: dish_id
      }
    }
  }).success(function(){
    $('#cart-text').load(document.URL + ' #order-card-text');
  });
});

$(document).on('click', '.btn-add-to-cart-combo', function() {
  var combo = $(this).parent().attr('combo-id');
  var url = '/order_combos';

  $.ajax({
    type:'POST',
    url: url,
    data: {
      order_combo: {
        quantity: 1,
        combo_id: combo
      }
    }
  }).success(function(){
    $('#cart-text').load(document.URL + ' #order-card-text');
  });
});

$(document).on('click', '.modal-membership-levels', function(){
  $(this).next().show();
});

$(document).on('click', '.btn-point', function(){
  $('#myModal3').show();
});
$(document).on('click','.btn-membership-check', function(){
  $('#check-discount-code').removeClass('fa-paper-plane');
  $('#check-discount-code').addClass('fa-spin fa-circle-o-notch');
  var data = $('.membership-point-input').val();
  $('.point-render').load(document.URL + '?point=' + data +
    ' .point-row');
  setTimeout(function(){
    $('#check-discount-code').addClass('fa-paper-plane');
    $('#check-discount-code').removeClass('fa-spin fa-circle-o-notch');
  }, 500);
});

$(document).on('click','.confirm-add-point-btn', function(){
  var id = $('.order-id').attr('data-order-id');
  var link ='/admin/orders/' + id;
  var current_point = parseInt($('.membership-point').text().split(' ')[0]);
  var point_used = parseInt($('.membership-point-input').val());
  var new_point = point_used + current_point;
  $('.modal').hide();
  $.ajax({
    type:'PUT',
    url: link,
    data: {
      order: {
        point: new_point,
      }
    }
  }).success(function(){
    $('.membership-point').text(new_point + ' ' + I18n.t('order_point'));
    var customer_id = $('.orders-info-customer').attr('id');
    var link = '/admin/customers/' + customer_id;
    var point = parseInt($('.point-membership').attr('data')) - point_used;
    $.ajax({
      type:'PATCH',
      url: link,
      data: {
        customer: {
          membership_attributes: {
            customer_id: customer_id,
            point: point
          }
        }
      },
      success: function(){
        $('.orders-info-membership')
          .load(document.URL + ' .membership-content');
        $('#order-total').load(document.URL + ' .total-price-content');
        $('.payment').load(document.URL + ' .payment-btn-style');
      }
    });
  });
});
