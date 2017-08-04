$(document).ready(function() {
  $('.txt-search-category').keypress(function (e) {
    if (e.which == 13) {
      var html = '';
      $.ajax({
        type: 'GET',
        url: '/dishes',
        data: {name: $(this).val()},
        dataType: 'JSON',
        success: function (respond) {
          $.each(respond, function(key, value){
            html += '<div class="col-xs-6 col-sm-4 choose">';
            html += '<label>';
            html += '<input type="checkbox" class="add-category" ';
            html += 'name="category[dish_ids][]" value="'+ value.id +'">';
            html += value.name;
            html += '</label></div>';
          });
        }
      }).done(function() {
        $('.contain-item').html(html);
      });

      return false;
    }
  });

  $('body').on('click', '.add-category', function() {
    var html = '';
    if($(this).is(':checked')) {
      $(this).attr('checked', 'checked');
      html = $(this).parent().html();
      $(this).parent().remove();
      $('.item-selected').append('<span>' + html + '</span>');
    } else {
      $(this).parent().remove();
    }
  });
});
