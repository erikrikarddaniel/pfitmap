class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new()
    if user.role == 'admin'
      can :manage, :all
    else
      can :read, :all
      cannot :read, User
      # Static pages
      can [:home, :help, :contact, :error_404], :static_page
      can [:create, :failure, :destroy], :session
    end
  end
end
