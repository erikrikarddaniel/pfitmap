class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new(:role => 'guest')
    if user.role == 'admin'
      can :manage, :all
    else
      can :read, :all
      cannot :read [Users]
    end
  end
end
