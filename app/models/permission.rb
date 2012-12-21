class Permission < ActiveRecord::Base
  belongs_to :user
  belongs_to :perm_type
end
