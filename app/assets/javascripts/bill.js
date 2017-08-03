$(document).on('turbolinks:load', function() {
  $('body').on('click', '.payment-btn', function() {
    var order_id = $('.order-id').data('order-id');
    var customer_id = $('.customer-id').data('customer-id');
    var customer_discount = $('.customer-discount').data('customer-discount');
    var membership_discount = $('#membership-discount').data('membership-discount');

    $.ajax({
      type:'POST',
      url: '/admin/bills',
      data: {
        bill: {
          customer_id: customer_id,
          order_id: order_id,
          discount: customer_discount,
          membership_discount: membership_discount
        }
      }
    }).done(function(data) {
      if (data.bill_id) {
        $('.order_item').each(function() {
          var id = $(this).find('.item-id').data('id');
          var price = $(this).find('.item-price').data('price');
          var discount = $(this).find('.item-discount').data('discount');
          var quantity = $(this).find('.item-quantity').data('quantity');
          var type = $(this).find('.item-type').data('type');

          $.ajax({
            type:'POST',
            url: '/admin/bill_details',
            data: {
              bill_detail: {
                id_item: id,
                price: price,
                discount: discount,
                quantity: quantity,
                bill_id: data.bill_id,
                item_type: type
              }
            }
          });
        });
        window.location = '/admin/bills/' + data.bill_id;
      }
    });
  });
});
