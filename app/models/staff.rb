class Staff < ApplicationRecord
  devise :custom_authenticatable, :database_authenticatable, :rememberable
  enum staff_role: %i(administrator chef waiter receptionist).freeze

  after_initialize :set_default_staff_role, if: :new_record?

  class << self
    def roles_select
      staff_roles.map do |role, _|
        [I18n.t("staff_role.#{role}"), role]
      end
    end
  end

  def valid_for_custom_authentication? pass
    staff = Staff.find_by email: email

    return false unless staff
    staff.valid_password? pass
  end

  def role
    I18n.t "staff_role.#{staff_role}"
  end

  private

  def set_default_staff_role
    self.staff_role ||= :administrator
  end
end
