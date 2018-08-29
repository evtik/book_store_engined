class Ability
  include CanCan::Ability
  prepend Draper::CanCanCan

  def initialize(user)
    user ||= User.new
    if user.admin?
      can(:manage, :all)
    else
      can(:read, Ecomm::Order, customer_id: user.id)
    end
  end
end
