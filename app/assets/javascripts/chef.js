$(document).on('turbolinks:load', function () {
  $(document).on('click', '.name-item', function () {
    var id = $(this).attr('id');
    $('.modal_item_' + id).show();
  });

  $(document).on('click', '.fa-chevron-down', function () {
    var id = $(this).attr('id');
    var value = parseInt($('.quantity_' + id).val());
    if(value > 0){
      value -= 1;
      $('.quantity_' + id).val(value);
    }
  });

  $(document).on('click', '.fa-chevron-up', function () {
    var id = $(this).attr('id');
    var value = parseInt($('.quantity_' + id).val());
    var max = $('.quantity_' + id).attr('max');
    if(value < max){
      value += 1;
      $('.quantity_' + id).val(value);
    }
  });

  $(document).on('change', '.range-field-rails', function () {
    var id = $(this).attr('data');
    $('.value_quantity_' + id).text($(this).val());
  });
});
