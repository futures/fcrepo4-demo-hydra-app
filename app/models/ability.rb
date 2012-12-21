class Ability
  include CanCan::Ability
  include Hydra::Ability

  def custom_permissions
    workflow_permissions
  end

  def workflow_permissions
    can :accept, GenericFile do |file|
      @user.moderates_collection_ids.include?(file.collection.pid)
    end
  end
end
