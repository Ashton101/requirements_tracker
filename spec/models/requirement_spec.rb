require 'spec_helper'

describe Requirement do
  
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
      child_requirement = FactoryGirl.create(:child_requirement)
      child_requirement.update_attributes(minimum: 3)
      expect(child_requirement.parent.minimum).to eq(3)
    end

    it "updates the parent correclty" do 
    	parent_requirement = FactoryGirl.create(:parent_requirement)
      child_requirment_1 = FactoryGirl.create(:child_requirement, parent_id: parent_requirement.id, minimum: 3 )	
      child_requirment_2 = FactoryGirl.create(:child_requirement, parent_id: parent_requirement.id, minimum: 5 )	
      expect(parent_requirement.minimum).to eq(8)
    end	
  end


end
