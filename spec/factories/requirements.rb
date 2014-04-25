FactoryGirl.define do
	factory :requirement do

	  factory :parent_requirement do
	    name 'this is a requirement name'
	    proj_id 1
	  end
	  
	  factory :child_requirement do
	  	name 'this is a child requirment'
	  	proj_id 1
	  	association :parent_id, factory: :parent_requirement
	  end

	end  
end