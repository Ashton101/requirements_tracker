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
	has_ancestry :cache_depth 
	belongs_to :project, foreign_key: :proj_id

	# before_destroy :subtract_range_from_parents, on: :destroy
	#after_save :add_min_range_to_parent
	# after_update :update_tree_range_after_edit, on: :update


	# def add_min_range_to_parent
	# 	if parent_id.present?
	# 		parent.minimum += self.minimum
	# 		parent.save
	# 	end
	# end

	# def add_max_range_to_parent
	# 	if self.parent_id.present?
	# 		self.parent.update_attribute(:minimum, (self.minimum + self.parent.minimum))
	# 	end
	# end

	# def add_ml_range_to_parent
	# 	if self.parent_id.present?
	# 		self.parent.update_attribute(:minimum, (self.minimum + self.parent.minimum))
	# 	end
	# end


	# def add_range_parents(requirement, min, max, ml)
	# 	while !(requirement.parent_id)
	# 		the_parent = Requirement.find(requirement.parent_id)

	# 		the_parent.update_attributes(minimum: the_parent.minimum + min,
	# 											maximum: the_parent.maximum + requirement.max,
	# 											most_likely: the_parent.most_likely + requirement.ml)
	# 		requirement = Requirement.find(requirement.parent_id)
	# 	end
	# end

	def add_range_to_parents
		copy_to_traverse_tree = Marshal.load( Marshal.dump(self) ) 
		while !(copy_to_traverse_tree.parent_id.nil?)
			the_parent = Requirement.find(copy_to_traverse_tree.parent_id)
			the_parent.update_attributes(minimum: (the_parent.minimum + self.minimum),
																		maximum: (the_parent.maximum + self.maximum),
																		most_likely: (the_parent.most_likely + self.most_likely))
			copy_to_traverse_tree = Requirement.find(copy_to_traverse_tree.parent_id)
		end
	end

	def update_tree_range_before_delete
		copy_to_traverse_tree = Marshal.load( Marshal.dump(self) ) 
		while !(copy_to_traverse_tree.parent_id.nil?)
			the_parent = Requirement.find(copy_to_traverse_tree.parent_id)
			the_parent.update_attributes(minimum: (the_parent.minimum - self.minimum),
																		maximum: (the_parent.maximum - self.maximum),
																		most_likely: (the_parent.most_likely - self.most_likely))
			copy_to_traverse_tree = Requirement.find(copy_to_traverse_tree.parent_id)
		end
	end


	
	# def update_tree_range_after_edit(requirement_old,requirement_new)
	# 	min = requirement_new.minimum - requirement_old.minimum
	# 	ml = requirement_new.most_likely - requirement_old.most_likely
	# 	max = requirement_new.maximum - requirement_old.maximum

	# 	if (requirement_new.parent_id.nil?)		
	# 		if (requirement_new.has_children?)	
	# 			reset_subtree_ranges(requirement_new)
	# 		end
	# 	else
	# 		reset_subtree_ranges(requirement_new)
	# 		add_range_parents(requirement_new,min,ml,max)
	# 	end
	# end

	def update_tree_range_after_edit(requirement_old)
		min = self.minimum - requirement_old.minimum
		ml = self.most_likely - requirement_old.most_likely
		max = self.maximum - requirement_old.maximum

		if self.parent_id.nil?		
			if (self.has_children?)	
				reset_subtree_ranges
			end
		else
			reset_subtree_ranges
			
			copy_to_traverse_tree = Marshal.load( Marshal.dump(self) ) 
			while !(copy_to_traverse_tree.parent_id.nil?)
				the_parent = Requirement.find(copy_to_traverse_tree.parent_id)
				the_parent.update_attributes(minimum: (the_parent.minimum + min),
				maximum: (the_parent.maximum + max),
				most_likely: (the_parent.most_likely + ml))
				copy_to_traverse_tree = Requirement.find(copy_to_traverse_tree.parent_id)
			end
		end
	end

	# def reset_subtree_ranges(requirement)
	# 	kids = requirement.subtree_ids
	# 	kids.delete(requirement.id)
	# 	kids.each do |kid| 
	# 		req = Requirement.find(kid)
	# 		req.update_attributes(minimum: 0, most_likely: 0, maximum: 0)
	# 	end
	# end

	def reset_subtree_ranges
		kids = self.subtree_ids
		kids.delete(self.id)
		kids.each do |kid| 
			req = Requirement.find(kid)
			req.update_attributes(minimum: 0, most_likely: 0, maximum: 0)
		end
	end

	def new_update_ranges
		#current node = find deepest node with children
		# current node = sum of ranges of children
		# current node = parent
		# 
		# loop above until parent = nil
		
	end

end


