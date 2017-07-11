$(document).on('click','#btn-edit-discount', function(){
  var x = $(this).attr('data');
  var discount = $('.discount'+x).text();
  var discount_status = $('.discount-status' + x).text();
  $('#discount_id_field').val(x);
  $('#discount_field').val(discount);
  $('#discount_status').val(discount_status);
  $('#edit-discount-modal').css('display','block');
});

$(document).on('click', '.btn-save-modal', function(){
  var discount_id = $('#discount_id_field').val();
  var discount = $('#discount_field').val();
  var discount_status = $('#discount_status :selected').val();
  if(discount != null && discount_id != null && discount_status != null){
    var url =  '/admin/discount_codes/'+ discount_id;
    $.ajax({
      type:'PUT',
      url: url,
      data: {
        discount_code: {
          discount: discount,
          status: discount_status,
        }
      }
    }).success(function(data){
      $('.modal').hide();
      $('.default-dg-table').replaceWith(data);
      $('.pagination').load(document.URL + ' .-pagination');
    });
  }
});

$(document).on('click','#btn-generate-code', function(){
  var discount = $('#new_code_discount').val();
  var quantity = $('#new_code_quantity').val();
  var status = $('#new_code_status').val();
  if(discount != null && quantity != null && status != null){
    $.ajax({
      type:'POST',
      url: '/admin/discount_codes',
      data: {
        quantity: quantity,
        discount_code: {
          discount: discount,
          status: status,
        }
      }
    }).success(function(data){
      $('.modal').hide();
      $('.default-dg-table').replaceWith(data);
      $('#discount-pagination').load(document.URL + ' .pagination');
      $('#counter').load(document.URL + ' #counter');
    });
  }
});

$(document).on('click','.choose-code-btn', function(){
  var id = $('.order-id').text();
  var link ='/admin/orders/' + id;
  var discount = $('#code-true strong').text();
  $('.modal').hide();
  $.ajax({
    type:'PUT',
    url: link,
    data: {
      order: {
        discount: discount,
      }
    }
  }).success(function(){
    $('#order-discount').text(discount + '%');
    var dis_id = $('#discount-id').text();
    var link = '/admin/discount_codes/' + dis_id;
    $.ajax({
      type:'PUT',
      url: link,
      data: {
        discount_code: {
          status: 'Used',
        }
      }
    });
  });
});
