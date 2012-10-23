class Ability
  include CanCan::Ability

  def initialize(user)
    # guest user (not logged in)
    user = user
    unless user
      user = User.new
      user.role = 'guest'
    end
    
    if user.admin?
      can :manage, :all
      can :invite, User
      can :edit_avatar, User, id: user.id
      can :read, :demands
    end

    if user.regular? 
      can :manage, Place, user_id: user.id
      can :create, Place
      can :read, Place
      can :submitted, Place, user_id: user.id

      can :invite, User 
      can :read, User
      can :edit_avatar, User, id: user.id
      
      can :read, PlaceRequest, booker_id: user.id 
      can :read, PlaceRequest, receiver_id: user.id 
      can :update, PlaceRequest, status: :pending, receiver_id: user.id
      can :create, PlaceRequest 
      
      can :read, Comment
      
      #can :see, :places
    end

    if user.guest? 
      can :read, Place, kind: :public
      can :read, Place, kind: :business
      can :read, User, public: true
      can :read, Comment, place: { kind: :public }
    end

  end
end
