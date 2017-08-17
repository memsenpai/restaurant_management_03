$(document).on('turbolinks:load', function () {
  $(document).on('click', '.button-new-staff', function () {
    $('.modal-new-staff').show();
  });

  $(document).on('click', '.btn-update-user', function () {
    var id = $(this).attr('data-id');
    var href = $('.modal-edit-staff').find('form').attr('action').split('/');
    href[3] = id;
    $('.modal-edit-staff').find('form').attr('action', href.join('/'));
    $('.modal-edit-staff').show();
    var email = $('.staff-email-' + id).text();
    var name = $('.staff-name-' + id).text();
    var role = $('.staff-role-' + id).text();
    $('.title').text(I18n.t('edit_staff') + name);
    $('.modal-edit-staff').find('#staff_email').val(email);
    $('.modal-edit-staff').find('#staff_name').val(name);
    $('.modal-edit-staff').find('#role_field').val(role);
  });

  $(document).on('click', '#change_password', function () {
    if(document.getElementById('change_password').checked){
      $('.password').removeClass('hide');
      $('.password').find('input').attr('required', 'true');
    } else {
      $('.password').addClass('hide');
      $('.password').find('input').removeAttr('required');
    }
  });
});
