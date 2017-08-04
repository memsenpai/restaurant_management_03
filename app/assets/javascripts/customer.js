$(document).ready(function() {
  $('body').on('click', '.btn-edit-customer', function() {
    var button = $(this);
    var id = $(this).parent().parent()
      .find('#customer-id').attr('data-id');
    var name = $(this).parent().parent()
      .find('#customer-name');
    var email = $(this).parent().parent()
      .find('#customer-email');
    var phone = $(this).parent().parent()
      .find('#customer-phone');
    var code = $(this).parent().parent()
      .find('#customer-code');
    var blacklist = $(this).parent().parent()
      .find('#customer-blacklist');
    var name_html = name.attr('data-name');
    var email_html = email.attr('data-email');
    var phone_html = phone.attr('data-phone');
    var code_html = code.attr('data-code');
    var blacklist_html = blacklist.attr('data-blacklist');

    if ($(this).html().trim() == I18n.t('button.edit')) {
      name.html('<input type="text" value="'+ name_html +'" />');
      email.html('<input type="text" value="'+ email_html +'" />');
      phone.html('<input type="text" value="'+ phone_html +'" />');
      code.html('<input type="text" value="'+ code_html +'" />');

      blacklist.html('<input type="number" value="'+ blacklist_html +'" />');
      $(this).html(I18n.t('button.save'));
    } else {
      name_html = name.find('input').val();
      email_html = email.find('input').val();
      phone_html = phone.find('input').val();
      code_html = code.find('input').val();
      blacklist_html = blacklist.find('input').val();
      name.attr('data-name', name_html);
      email.attr('data-email', email_html);
      phone.attr('data-phone', phone_html);
      code.attr('data-code', code_html);
      blacklist.attr('data-blacklist', blacklist_html);

      $.ajax({
        type:'PUT',
        url: '/admin/customers/' + id,
        dataType: 'json',
        data: {
          customer: {
            name: name_html,
            email: email_html,
            phone_num: phone_html,
            code: code_html,
            warning_times: blacklist_html
          }
        }
      }).done(function(result){
        if (!result.status) {
          alert(I18n.t('errors.update_customer'));
        } else {
          name.html(name_html);
          email.html(email_html);
          phone.html(phone_html);
          code.html(code_html);
          var yes = I18n.t('yes');
          var no = I18n.t('no');
          if (blacklist_html > 2) {
            blacklist.html('<span class="is-black-list">'+ yes +'</span>');
          } else {
            blacklist.html('<span class="not-is-black-list">'+ no +'</span>');
          }
          button.html(I18n.t('button.edit'));
        }
      });
    }

    return false;
  });

  $('body').on('click', '.btn-create-customer-coupons', function() {
    $('.rows-item-create').show();
    return false;
  });

  $('body').on('click', '.btn-close-customer', function() {
    $('.rows-item-create').hide();
    return false;
  });

  $('body').on('click', '.btn-create-customer', function() {
    var name = $(this).parent().parent()
      .find('#customer-name');
    var email = $(this).parent().parent()
      .find('#customer-email');
    var code = $(this).parent().parent()
      .find('#customer-code');
    var phone = $(this).parent().parent()
      .find('#customer-phone');

    var name_html = name.find('input').val();
    var email_html = email.find('input').val();
    var code_html = code.find('input').val();
    var phone_html = phone.find('input').val();
    name.attr('data-name', name_html);
    email.attr('data-email',email_html);
    code.attr('data-code', code_html);
    phone.attr('data-phone', phone_html);

    var customer = {
      name: name_html,
      email: email_html,
      code: code_html,
      phone_num: phone_html,
      warning_times: 0
    };

    var check = false;
    $.ajax({
      type:'POST',
      url: '/admin/customers',
      dataType: 'json',
      data: {
        customer: customer
      }
    }).done(function(result){
      if (result) {
        $('.rows-item-create').hide();
        check = true;
      } else {
        alert(I18n.t('errors.create_customer'));
      }
    });

    if (!check){
      return false;
    }
  });

  $('body').on('click', '.btn-delete-customer', function() {
    var confirm_delete = confirm(I18n.t('are_you_sure_delete'));

    if (confirm_delete == false) {
      return false;
    }

    var id = $(this).parent().parent()
      .find('#customer-id').attr('data-id');
    var check = false;
    $.ajax({
      type:'DELETE',
      url: '/admin/customers/' + id,
      dataType: 'json',
      data: {
        id: id
      }
    }).done(function(result){
      if (result) {
        $('.rows-item-create').hide();
        check = true;
      } else {
        alert(I18n.t('errors.create_customer'));
      }
    });

    if (!check) {
      return false;
    }
  });
});
