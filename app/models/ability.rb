class Ability
  include CanCan::Ability

  def initialize user
    user ||= Admin.new
    alias_action :edit, :update, to: :modify
    alias_action :index, :show, :edit, to: :view

    can :manage, [Admin]

    case user.admin_role
    when "administrator"
      can :manage, :all
    when "receptionist"
      can :manage, [Order, OrderDish, OrderCombo,
        Combo, Dish, DiscountCode, Category, :categories]
    when "chef"
      can :view, :chef
      can :modify, [Order, OrderDish, OrderCombo]
    end
  end
end
