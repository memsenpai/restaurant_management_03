$(document).ready(function() {
  $('body').on('click', '.payment-btn', function() {
    var order_id = $('.order-id').data('order-id');
    var guest_id = $('.guest-id').data('guest-id');
    var guest_discount = $('.guest-discount').data('guest-discount');
    alert(guest_discount);
    $.ajax({
      type:'POST',
      url: '/admin/bills',
      data: {
        bill: {
          guest_id: guest_id,
          order_id: order_id,
          discount: guest_discount
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
