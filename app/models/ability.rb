class Ability
  include CanCan::Ability
  def initialize arg
    @user = arg || Administrator.new
    alias_action :edit, :update, to: :modify
    alias_action :index, :show, :edit, to: :view

    can :manage, [Administrator]
    can :manage, [Order]

    case_role
  end

  private

  attr_reader :user

  def list_receptionist
    [
      Order,
      OrderDish,
      OrderCombo,
      Combo,
      Dish,
      DiscountCode,
      Category,
      :categories
    ]
  end

  def case_role
    case user.admin_role
    when "administrator"
      can :manage, :all
    when "receptionist"
      can :manage, list_receptionist
    when "chef"
      can :view, :chef
      can :modify, [Order, OrderDish, OrderCombo]
    end
  end
end
