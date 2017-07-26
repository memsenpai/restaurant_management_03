class Ability
  include CanCan::Ability
  def initialize arg
    @user = arg || Staff.new
    alias_action :index, :show, :edit, :update, to: :modify
    alias_action :index, :show, to: :view
    alias_action :update, to: :change

    can :manage, [Staff]
    can :manage, [Order]

    case_role
  end

  private

  attr_reader :user

  def case_role
    case user.staff_role
    when "administrator"
      can :manage, :all
    when "receptionist"
      can :change, [Order, OrderDish, OrderCombo]
      can :view, [Combo, Dish, DiscountCode, Category, Promo]
    when "chef"
      can :view, :chef
      can :modify, [Order, OrderDish, OrderCombo]
    end
  end
end
