/*global WOW:true*/
$(document).on('turbolinks:load', function(){
  if(window.location.pathname == '/tables')
    tables_book();
});

$(document).on('turbolinks:load', function(){

  $(document).on('click','.close', function(){
    $('#myModal').css('display','none');
    $('.modal').css('display', 'none');
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

function tables_book(){
  $('.datepicker2').datepicker({
    dateFormat: 'yy-mm-dd',
    defaultDate: 0,
    firstDay: 1,
    gotoCurrent: true,
    minDate: 0
  });
  $('input.timepicker').timepicker({
    timeFormat: 'HH:mm',
    minHour: 10,
    maxHour: 20,
    maxMinutes: 30,
    interval: 15
  });
  $('.btn-table').click(function(){
    $('.btn-table').removeClass('btn-choose');
    $(this).addClass('btn-choose');
    if($(this).hasClass('btn-batsu')){
      $('.next').attr('disabled', 'true');
      $('.alert-2').addClass('show');
      setTimeout(function () {
        $('.alert-2').removeClass('show');
      }, 2500);
    }
    else {
      $('.next').removeAttr('disabled');
    }
  });
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
  $('.previous').click(function() {
    var step = $(this).attr('step');
    if (step == 3) {
      $('#booking-step-2').removeClass('is-complete');
      $('#booking-step-2').addClass('is-active');
      $('#booking-step-3').removeClass('is-active');
    } else if (step == 2) {
      $('#booking-step-1').removeClass('is-complete');
      $('#booking-step-1').addClass('is-active');
      $('#booking-step-2').removeClass('is-active');
    }
  });

  $(document).on('click','.next', function(){
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
      $('#booking-step-1').removeClass('is-active');
      $('#booking-step-1').addClass('is-complete');
      $('#booking-step-2').addClass('is-active');

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
          $('.btn-'+ i).removeClass('btn-maru').removeClass('btn-choose').addClass('btn-batsu');
        }
        $.each(data, function (index, element) {
          $('.btn-' + element.code).addClass('btn-maru').removeClass('btn-batsu');
        });
        next_step(element);
      });
    }
    else if(step == 2){
      if($('.btn-table').hasClass('btn-choose')){
        next_step(element);
        $('#booking-step-2').removeClass('is-active');
        $('#booking-step-2').addClass('is-complete');
        $('#booking-step-3').addClass('is-active');
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
      }).success(function(result){
        if (result.status == 0) {
          alert(I18n.t('errors.customer_code_not_exists'));
        } else if (result.status == -1) {
          alert(I18n.t('errors.you_cant_booking'));
        } else {
          book_table();
        }
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

  $(document).on('click', '.previous', function(){
    prev_step(this);
  });

  $(document).on('click', '.submit', function(){
    return false;
  });
}

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

$(document).on('turbolinks:load',function(){
  $('time.timeago').timeago();
  $('input.timepicker').timepicker({
    timeFormat: 'HH:mm',
    minHour: 10,
    maxHour: 20,
    maxMinutes: 30,
    interval: 15
  });

  $('body').on('click', '.btn-edit-membership', function() {
    var id = $(this).parent().parent()
      .find('[data-id]').attr('data-id');
    var name = $(this).parent().parent()
      .find('#membership-coupon-name');
    var money_paid = $(this).parent().parent()
      .find('#membership-coupon-money-paid');
    var discount = $(this).parent().parent()
      .find('#membership-coupon-discount');
    var status = $(this).parent().parent()
      .find('#membership-coupon-status');
    var name_html = name.attr('data-name');
    var money_paid_html = money_paid.attr('data-money-paid');
    var discount_html = discount.attr('data-discount');
    var status_html = status.attr('data-status');

    if ($(this).html().trim() == I18n.t('button.edit')) {
      name.html('<input type="text" value="'+ name_html +'" />');
      money_paid.html('<input type="number" value="'+ money_paid_html +'" />');
      discount.html('<input type="number" value="'+ discount_html +'" />');
      var active = '<option value="'+ I18n.t('status.active');
      active += '">'+ I18n.t('status.active_txt') +'</option>';
      var notactive = '<option value="'+ I18n.t('status.notactive');
      notactive += '">'+ I18n.t('status.notactive_txt') +'</option>';
      if (status_html == 'active') {
        active = '<option value="'+ I18n.t('status.active');
        active += '" selected>'+ I18n.t('status.active_txt') +'</option>';
      } else {
        notactive = '<option value="'+ I18n.t('status.notactive');
        notactive += '" selected>'+ I18n.t('status.notactive_txt') +'</option>';
      }
      status.html('<select>'+ active + notactive +'</select>');
      $(this).html(I18n.t('button.save'));
    } else {
      name_html = name.find('input').val();
      money_paid_html = money_paid.find('input').val();
      discount_html = discount.find('input').val();
      status_html = status.find('select').val();
      name.attr('data-name', name_html);
      money_paid.attr('data-money-paid', money_paid_html);
      discount.attr('data-discount', discount_html);
      status.attr('data-status', status_html);

      name.html(name_html);
      money_paid.html(money_paid_html);
      discount.html(discount_html);
      if (status_html == I18n.t('status.active')) {
        status.html('<i class="fa fa-circle status-active"></i>');
      } else {
        status.html('<i class="fa fa-circle status-notactive"></i>');
      }

      $.ajax({
        type:'PUT',
        url: '/admin/membership_coupons/' + id,
        dataType: 'json',
        data: {
          membership_coupon: {
            name: name_html,
            money_paid: money_paid_html,
            status: status_html,
            discount: discount_html
          }
        }
      }).success(function(){

      });
      $(this).html(I18n.t('button.edit'));
    }

    return false;
  });

  $('body').on('click', '.btn-create-membership-coupons', function() {
    $('.rows-item-create').show();
    return false;
  });

  $('body').on('click', '.btn-close-membership', function() {
    $('.rows-item-create').hide();
    return false;
  });

  $('body').on('click', '.btn-create-membership', function() {
    var name = $(this).parent().parent()
      .find('#membership-coupon-name');
    var money_paid = $(this).parent().parent()
      .find('#membership-coupon-money-paid');
    var discount = $(this).parent().parent()
      .find('#membership-coupon-discount');

    var name_html = name.find('input').val();
    var money_paid_html = money_paid.find('input').val();
    var discount_html = discount.find('input').val();
    name.attr('data-name', name_html);
    money_paid.attr('data-money-paid', money_paid_html);
    discount.attr('data-discount', discount_html);

    var membership_coupon = {
      name: name_html,
      money_paid: money_paid_html,
      status: 'active',
      discount: discount_html
    };

    $.ajax({
      type:'POST',
      url: '/admin/membership_coupons',
      dataType: 'json',
      data: {
        membership_coupon: membership_coupon
      }
    }).success(function(result){
      if (result) {
        $('.rows-item-create').hide();
      }
    });
  });
});

$(document).on('turbolinks:load', function(){
  $('body').on('click', '.btn-update-user', function() {
    var staff_id = $(this).parent().parent().find('.staff_role_update').attr('id');
    var staff_role = $(this).parent().parent().find('.staff_role_update').val();
    var html = $(this).html();
    $(this).html(html + '...');
    $(this).attr('disabled', 'disabled');
    $.ajax({
      type:'PUT',
      url: '/admin/staffs/' + staff_id,
      data: {
        staff: {
          staff_role: staff_role
        }
      }
    }).success(function() {
      $(this).removeAttr('disabled');
      $(this).html(html);
    });
  });
});

$(document).on('turbolinks:load', function(){
  var adjustment;

  $('ol.simple_with_animation').sortable({
    group: 'simple_with_animation',
    pullPlaceholder: false,
    onDrop: function ($item, container, _super) {
      changeStatus($item);

      var $clonedItem = $('<li/>').css({height: 0});
      $item.before($clonedItem);
      $clonedItem.animate({'height': $item.height()});

      $item.animate($clonedItem.position(), function  () {
        $clonedItem.detach();
        _super($item, container);
      });
    },

    onDragStart: function ($item, container, _super) {
      var offset = $item.offset(),
        pointer = container.rootGroup.pointer;

      adjustment = {
        left: pointer.left - offset.left,
        top: pointer.top - offset.top
      };

      _super($item, container);
    },
    onDrag: function ($item, position) {
      $item.css({
        left: position.left - adjustment.left,
        top: position.top - adjustment.top
      });
    }
  });

  function changeStatus($item){
    var nextstatus = $item[0].parentNode.getAttribute('status');
    var order_id = $item[0].getAttribute('order-id');
    var id = $item[0].id;
    var type = $item[0].getAttribute('type');
    $.ajax({
      type: 'PUT',
      headers: {'AUTHENTICATE-TOKEN': 'supersecrettoken1'},
      url: '/api/orders/' + order_id + '/' + type + '/' + id,
      contentType: 'application/json; charset=utf-8',
      dataType: 'json',
      data: JSON.stringify({status: nextstatus}),
      error: function() {
        location.reload();
      }
    });
  }
});
