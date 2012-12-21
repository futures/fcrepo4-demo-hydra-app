require 'spec_helper'

describe GenericFile do
  before do
    subject.terms_of_service = '1'
    subject.apply_depositor_metadata("jcoyne")
  end
  it "should have descMetadata" do
    subject.descMetadata.should be_kind_of GenericFileRdfDatastream
  end

  it "should have workflowMetadata" do
    subject.workflowMetadata.should be_kind_of Hydra::Datastream::Workflow
  end

  describe "that has a collection" do
    let :collection do
      Hydra::Workflow::Collection.create!
    end
    before do
      subject.collection = collection
      subject.save!
    end
    it "should record it's collection" do
      GenericFile.find(subject.pid).collection.should == collection
    end
  end
end
