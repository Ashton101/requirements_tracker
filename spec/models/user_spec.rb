require 'spec_helper'

describe User do
  describe "Factory is set up correctly" do
    it "creates a user using Factory Girl" do
    	expect{ create(:user) }.to change{ User.count }.by(1)
    end	
  end
end
