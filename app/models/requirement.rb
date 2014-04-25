# == Schema Information
#
# Table name: requirements
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :string(255)
#  proj_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  ancestry    :string(255)
#
class Requirement < ActiveRecord::Base
	has_ancestry
	belongs_to :project, foreign_key: :proj_id

	# This is a function that is used to update the range columns of all requirements in the requirements tree
	# when a new requirement is added. 
	# This function takes a (leaf) requirement object and range parameters as input, 
	# It navigates the tree from the bottom up and adds the range param to all parents' ranges of the new child
	def add_range_parents(requirement,min,ml,max)
		while !(requirement.parent_id.nil?)
			the_parent = Requirement.find(requirement.parent_id)

			the_parent.update_attributes(minimum: the_parent.minimum + min,
												maximum: the_parent.maximum + max,
												most_likely: the_parent.most_likely + ml)
			requirement = Requirement.find(requirement.parent_id)
		end
	end

	# After you edit a requirement, this function can look at all the requirements parents and children
	# and updates the ranges
	def update_tree_range_after_edit(requirement_old,requirement_new)
		#new minus the old requirements
		min = requirement_new.minimum - requirement_old.minimum
		ml = requirement_new.most_likely - requirement_old.most_likely
		max = requirement_new.maximum - requirement_old.maximum

		#case1 the edited requirement has no parent
		if (requirement_new.parent_id.nil?)
			#case2 the edited requirement has no children			
			if (requirement_new.has_children?)	
				reset_ranges(requirement_new)
			end
		#case3 the edited requirement has parents and children	
		else
			reset_ranges(requirement_new)
			add_range_parents(requirement_new,min,ml,max)
		end
	end

	#This function resets the ranges of children in the subtree of received requirement to zero
	def reset_ranges(requirement)
		kids = requirement.subtree_ids
		kids.delete(requirement.id)
		kids.each do |kid| 
			req = Requirement.find(kid)
			req.update_attributes(minimum: 0, most_likely: 0, maximum: 0)
		end
	end

end


