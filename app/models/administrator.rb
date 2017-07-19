class Administrator < Human
  enum admin_role: %i(administrator chef waiter receptionist)

  validates :password, presence: true, length: {minimum: 6}, allow_nil: true

  after_initialize :set_default_admin_role, if: :new_record?
  before_save :downcase_email

  has_secure_password

  class << self
    def roles_select
      admin_roles.map do |role, _|
        [I18n.t("admin_role.#{role}"), role]
      end
    end
  end

  def role
    I18n.t "admin_role.#{admin_role}"
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def set_default_admin_role
    self.admin_role ||= :administrator
  end
end
