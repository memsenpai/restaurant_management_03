/*global WOW:true*/
$(document).on('turbolinks:load', function(){
  $('.datepicker2').datepicker({
    dateFormat: 'yy-mm-dd',
    defaultDate: 0,
    firstDay: 1,
    gotoCurrent: true,
    minDate: 0
  });

  $('.btn-table').click(function(){
    $('.btn-table').removeClass('btn-choose');
    $(this).addClass('btn-choose');
  });

  $(document).on('click','.close', function(){
    $('#myModal').css('display','none');
    $('#guest-popup').css('display','none');
  });

  var wow = new WOW(
    {
      boxClass: 'wow',
      animateClass: 'animated',
      offset: 0,
      mobile: true,
      live: true,
      scrollContainer: null
    }
  );
  wow.init();

  $(document).on('click', '.edit-pass', function() {
    $('#edit_pass_show').toggleClass('edit-pass-content-hide', 'edit-pass-content-show');
  });

  $(document).on('click', '#searchclear', function(){
    $('#searchinput').val('');
  });

  $('.home-overlay').bgswitcher({
    images: [
      'http://i.imgur.com/WVDh6N2.jpg',
      'http://i.imgur.com/gQGFY9C.jpg',
      'http://i.imgur.com/ITUizuk.jpg',
      'http://i.imgur.com/4MzLYrL.jpg',
      'http://i.imgur.com/g8AiwIu.jpg',
      'http://i.imgur.com/oryEB6Z.jpg',
      'http://i.imgur.com/YRk2lI7.jpg',
      'http://i.imgur.com/7uO7iFA.jpg'],
    effect: 'fade',
    interval: 5000,
    loop: true,
    shuffle: true,
    duration: 500,
    easing: 'linear'
  });
});

function book_table (){
  var val_date = $('#date_field').val();
  var val_time = $('#timepicker').val();
  var id_table = $('.btn-table.btn-choose').text();
  $('#myModal').css('display','none');
  $('#guest-popup').css('display','none');
  $.ajax({
    type:'POST',
    url: '/orders',
    dataType: 'json',
    data: {
      day: val_date,
      time_in: val_time,
      table_id: id_table
    }
  }).success(function(d){
    location.replace(d.path);
  });
}

$(document).on('click','#close-alert', function(){
  $('#popup1').addClass('hide');
});

$(document).ready(function(){
  var current_fs, next_fs, previous_fs;
  var current, next, prev;
  var left, opacity, scale;
  var animating;

  function next_step(element) {
    if(animating) return false;
    animating = true;
    current = $(element).attr('data-current');
    next = $(element).attr('data-next');

    current_fs = $('#block-' + current);
    next_fs = $('#block-' + next);

    $('#progressbar li:nth(' + next + ')').addClass('active');

    current_fs.animate({opacity: 0}, {
      step: function(now) {
        scale = 1 - (1 - now) * 0.2;
        left = (now * 50)+'%';
        opacity = 1 - now;
        current_fs.css({
          'transform': 'scale('+scale+')'
        });
        next_fs.css({'left': left, 'opacity': opacity});
      },
      duration: 500,
      complete: function(){
        current_fs.hide();
        animating = false;
        next_fs.show();
      },
      easing: 'easeInOutBack'
    });
  }

  function prev_step(element) {

    if(animating) return false;
    animating = true;

    current = $(element).attr('data-current');
    prev = $(element).attr('data-prev');

    current_fs = $('#block-' + current);
    previous_fs = $('#block-' + prev);

    $('#progressbar li:nth(' + current + ')').removeClass('active');

    previous_fs.show();

    current_fs.animate({opacity: 0}, {
      step: function(now) {
        scale = 0.8 + (1 - now) * 0.2;
        left = ((1-now) * 50) + '%';
        opacity = 1 - now;
        current_fs.css({'left': left});
        previous_fs.css({'transform': 'scale('+scale+')', 'opacity': opacity});
        current_fs.hide();
      },
      duration: 400,
      complete: function(){
        current_fs.hide();
        animating = false;
      },
      easing: 'easeInOutBack'
    });
  }

  $('.next').click(function(){
    var element = this;
    var step = $(this).attr('step');
    if(step == 1){
      var val_cap = $('#capacity_field').val();
      var val_date = $('#date_field').val();
      var val_time = $('#timepicker').val();
      var val_id = $('#chosen_table_value').val();

      if(val_cap == '' || val_date == '' || val_time == ''){
        $('.alert-1').addClass('show');
        setTimeout(function () {
          $('.alert-1').removeClass('show');
        }, 2500);
        return;
      }

      $('#btn-summit-table').css('display','inline-block');
      $.ajax({
        type:'GET',
        url: '/tables',
        dataType: 'json',
        data: {
          table: {
            capacity_gteq: val_cap,
            orders_day_eq: val_date,
            orders_time_in_eq: val_time,
            id: val_id
          }
        }
      }).done(function(data) {
        for(var i=0;i<19;i++) {
          $('#btn-'+ i).removeClass('btn-maru').removeClass('btn-choose').addClass('btn-batsu');
        }
        $.each(data, function (index, element) {
          $('#btn-' + element.code).addClass('btn-maru').removeClass('btn-batsu');
        });
        next_step(element);
      });
    }
    else if(step == 2){
      if($('.btn-table').hasClass('btn-choose')){
        next_step(element);
      }
      else{
        $('.alert-2').addClass('show');
        setTimeout(function () {
          $('.alert-2').removeClass('show');
        }, 2500);
        return;
      }
    }
    else if(step == 4){
      var customer_code = $('#code-customer').val();
      $.ajax({
        type:'GET',
        url: '/customers',
        dataType: 'json',
        data: {
          customer: {
            code: customer_code,
          }
        }
      }).success(function(){
        book_table();
      });
    }
    else if(step == 5){
      var val_name = $('#name-customer').val();
      var val_phone = $('#phone-customer').val();
      var val_email = $('#email-customer').val();
      $.ajax({
        type:'POST',
        url: '/customers',
        dataType: 'json',
        data: {
          customer: {
            name: val_name,
            email: val_email,
            phone_num: val_phone,
          }
        }
      }).success(function(){
        book_table();
      });
    }
  });

  $('.previous').click(function(){
    prev_step(this);
  });

  $('.submit').click(function(){
    return false;
  });
});

$(document).on('click','.btn-voucher',function(){
  $('#myModal2').show();
});

$(document).on('click','#check-discount-code', function(){
  $('#check-discount-code').removeClass('fa-paper-plane');
  $('#check-discount-code').addClass('fa-spin fa-circle-o-notch');
  var data = $('#discount-code-input').val();
  $('#discount-render').load(document.URL + '?discount=' + data +
    ' #discount-row');
  setTimeout(function(){
    $('#check-discount-code').addClass('fa-paper-plane');
    $('#check-discount-code').removeClass('fa-spin fa-circle-o-notch');
  }, 500);
});

$(document).ready(function(){
  $('input.timepicker').timepicker({
    timeFormat: 'HH:mm',
    minHour: 10,
    maxHour: 20,
    maxMinutes: 30,
    interval: 15
  });
});
