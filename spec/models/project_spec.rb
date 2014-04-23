require 'spec_helper'

describe Project do
  describe "Factory is set up correctly" do
    it "creates a Project using Factory Girl" do
    	expect{ create(:project) }.to change{ Project.count }.by(1)
    end	

    it "creates a User for the Project using Factory Girl" do
    	expect{ create(:project) }.to change{ User.count }.by(1)
    end	
  end
end
