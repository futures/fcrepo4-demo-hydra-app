require 'hydra/workflow'
class GenericFile < ActiveFedora::Base
  include Sufia::GenericFile
  has_metadata :name => "workflowMetadata", :type => Hydra::Datastream::Workflow
  belongs_to :collection, :class_name=>'Hydra::Workflow::Collection', :property => :is_part_of
  
  # Marks this image as having been reviewed and publishes it
  # def review!
  #   workflowMetadata.review_process.status = "completed"
  #   publish
  #   save!
  # end

  # def publish
  #   self.read_groups += ["public"] unless self.read_groups.include?("public")
  # end

end
