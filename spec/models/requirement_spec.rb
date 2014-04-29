require 'spec_helper'
require 'database_cleaner'



describe Requirement do

  DatabaseCleaner.strategy = :transaction


  before(:each) do
    DatabaseCleaner.start
  end

  after(:each) do
    DatabaseCleaner.clean
  end
  
  describe "Factory is set up correctly" do
    describe "Parent Requirement setup" do
	    it "creates a Parent Requirement using Factory Girl" do
	    	expect{ create(:parent_requirement) }.to change{ Requirement.count }.by(1)
	    end	

	    #  it "creates a Project for the Parent Requirement using Factory Girl" do
	    # 	expect{ create(:parent_requirement) }.to change{ Project.count }.by(1)
	    # end	

	   #  it "creates a User for the Parent Requirment using Factory Girl" do
	   #  	expect{ create(:parent_requirement) }.to change{ User.count }.by(1)
	   #  end	
    end
    describe "Parent Requirement setup" do
    	it "creates a parent requirment for a child requirment" do
    		expect{ create(:child_requirement) }.to change{ Requirement.count }.by(2)
    	end	

    	it "associates the Parent Requirement with the Child Requirment" do
    		child_requirment = FactoryGirl.create(:child_requirement)
    		expect(child_requirment.parent.class).to eq(Requirement)
    	end	
    end	
  end
  
  describe "Estimations passed from child to parent" do
  	it "stores the estimation in the parent when the child is updated" do 
      parent_requirement = FactoryGirl.create(:parent_requirement, minimum: 1, maximum: 1, most_likely: 1)
      child_requirement1 = FactoryGirl.create(:child_requirement, parent_id: parent_requirement.id, minimum: 2, maximum: 1, most_likely: 1)

      child_requirement1.add_range_to_parents

      old_requirement = Marshal.load( Marshal.dump(child_requirement1) ) 

      child_requirement1.update_attributes(minimum: 3)

      child_requirement1.update_tree_range_after_edit(old_requirement)

      expect(child_requirement1.parent.minimum).to eq(4)
    end

    it "updates the parent range correctly when a sub-requirement is added" do 
    	parent_requirement1 = FactoryGirl.create(:parent_requirement, minimum: 1, maximum: 1, most_likely: 1)
      child_requirement11 = FactoryGirl.create(:child_requirement, parent_id: parent_requirement1.id, minimum: 2, maximum: 1, most_likely: 1)	

      child_requirement11.add_range_to_parents

      child_requirement2 = FactoryGirl.create(:child_requirement, parent_id: child_requirement11.id, minimum: 3, maximum: 1, most_likely: 1)	

      child_requirement2.add_range_to_parents
     
      expect(parent_requirement1.reload.minimum).to eq(6)
    end	
  end

  describe "Estimations of children when a parent is edited" do
    it "Should clear all ranges of children in the subtree" do
      parent_requirement3 = FactoryGirl.create(:parent_requirement, minimum: 1, maximum: 1, most_likely: 1)
      child_requirement3 = FactoryGirl.create(:child_requirement, parent_id: parent_requirement3.id, minimum: 2, maximum: 1, most_likely: 1) 

      old_requirement2 = Marshal.load( Marshal.dump(parent_requirement3) ) 

      parent_requirement3.update_attributes(minimum: 3)

      parent_requirement3.update_tree_range_after_edit(old_requirement2)

      expect(child_requirement3.reload.minimum).to eq(0)

    end
  end

  describe "When deleting a requirement" do
    it "Should delete all children belonging to that requirement" do
      parent_requirement4 = FactoryGirl.create(:parent_requirement, minimum: 1, maximum: 1, most_likely: 1)
      child_requirement41 = FactoryGirl.create(:child_requirement, parent_id: parent_requirement4.id, minimum: 2, maximum: 1, most_likely: 1) 

      child_requirement41.add_range_to_parents

      child_requirement42 = FactoryGirl.create(:child_requirement, parent_id: child_requirement41.id, minimum: 2, maximum: 1, most_likely: 1)

      child_requirement42.add_range_to_parents
      
     parent_requirement4.update_tree_range_before_delete
      parent_requirement4.destroy


      expect{Requirement.find(child_requirement42.reload.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "Should update parent requirements ranges accordingly" do
      parent_requirement5 = FactoryGirl.create(:parent_requirement, minimum: 1, maximum: 1, most_likely: 1)
      child_requirement51 = FactoryGirl.create(:child_requirement, parent_id: parent_requirement5.id, minimum: 2, maximum: 1, most_likely: 1) 

      child_requirement51.add_range_to_parents

      child_requirement52 = FactoryGirl.create(:child_requirement, parent_id: child_requirement51.id, minimum: 2, maximum: 1, most_likely: 1)

      child_requirement52.add_range_to_parents

      child_requirement52.update_tree_range_before_delete

      child_requirement52.destroy

      expect(parent_requirement5.reload.minimum).to eq(3)
    end
  end

end
