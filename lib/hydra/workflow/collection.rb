class Hydra::Workflow::Collection < ActiveFedora::Base
  has_many :generic_files, :property => :is_part_of
  before_destroy :drop_permissions


  def drop_permissions
    Permission.where(collection_id: pid).delete_all
  end

  def moderators
    User.joins(:permissions).where('permissions.collection_id = ?', pid)
  end
  def moderators=(users)
    raise "Can't set moderators on an unsaved collection" if new?
    users.each do |u|
      p = u.permissions.build
      p.collection_id= pid
      p.perm_type = PermType.moderate
      p.save!
    end
      
  end
end
