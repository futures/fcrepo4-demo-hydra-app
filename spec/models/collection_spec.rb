require 'spec_helper'

describe Hydra::Workflow::Collection do
  it "should have generic_files" do
    subject.save!
    img = GenericFile.new(:terms_of_service => '1')
    img.apply_depositor_metadata("jcoyne")
    img.save!

    img.collection.should be_nil
    img.collection = subject
    img.save!

    img2 = GenericFile.new(collection: subject, terms_of_service: '1')
    img2.apply_depositor_metadata("jcoyne")
    img2.save!

    c1 = Hydra::Workflow::Collection.find(subject.pid)
    c1.generic_files.should == [img, img2]
  end

  describe "has moderators" do
    before do
      @u1 = User.create(email: 'bob@example.com', password: 's3kr3t')
      @u2 = User.create(email: 'jane@example.com', password: 's3kr3t')
      @u3 = User.create(email: 'samantha@example.com', password: 's3kr3t')
      subject.save
    end

    after do
      subject.destroy
    end
    it "should store them" do
      subject.moderators = [@u2, @u3]
      subject.reload 
      subject.moderators.should == [@u2, @u3]
    end
    describe "and documents" do
      before do
        subject.moderators = [@u2, @u3]
        @doc_in_collection = GenericFile.new(terms_of_service: '1', collection: subject)
        @doc_in_collection.apply_depositor_metadata("jcoyne")
        @doc_in_collection.save!
        
      end
      after do
        @doc_in_collection.destroy
      end

      it "should allow moderators to accept documents into their collection"  do
        Ability.new(@u2).can?(:accept, @doc_in_collection).should be_true
      end
      it "should not allow non-moderators to accept documents into the collection" do
        Ability.new(@u1).can?(:accept, @doc_in_collection).should be_false
      end
    end
  end
end
