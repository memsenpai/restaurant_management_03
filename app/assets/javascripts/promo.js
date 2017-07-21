$(document).on('turbolinks:load', function(){
  $('input[type = "radio"]').on('click', function() {
    $('#promo_dish_id').attr('value',
      document.querySelector('input[type = "radio"]:checked').value);
    $('.hidden-field-dish-id').attr('value',
      document.querySelector('input[type = "radio"]:checked').value);
    if($('.image-dish-select').length == 0){
      $('.new_promo')
        .prepend('<img class="image-dish-select" src="#">');
      $('.image-dish-select').attr('width', 80);
      $('.image-dish-select').attr('height', 80);
    }
    $.ajax({
      type: 'get',
      url: document.URL,
      data: {'dish_id': $('#promo_dish_id').val()},
      dataType: 'JSON',
      success: function (respond) {
        $('.image-dish-select').attr('src', respond);
      }
    });
  });
});
