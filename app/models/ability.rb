class Ability
  include CanCan::Ability
  def initialize arg
    @user = arg || Staff.new
    alias_action :index, :show, :edit, :update, to: :modify
    alias_action :index, :show, to: :view
    alias_action :update, to: :change

    can :manage, [Staff]

    case_role
  end

  private

  attr_reader :user

  def case_role
    case user.staff_role
    when "administrator"
      can :manage, :all
    when "receptionist"
      receptionist_role
    when "chef"
      chef_role
    when "waiter"
      waiter_role
    end
  end

  def waiter_role
    can :modify, [Order, OrderDish, OrderCombo]
  end

  def receptionist_role
    waiter_role
    can :view, [Customer, Bill]
  end

  def chef_role
    waiter_role
    can :view, :chef
  end
end
