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
      can [:home, :help, :contact, :error_404, :sign_in], :static_page
      can [:create, :failure, :destroy, :change_release], :session
      can [:by_rank, :by_hierarchy, :with_enzymes, :add_row, :collapse_rows], ProteinCount
    end
  end
end
