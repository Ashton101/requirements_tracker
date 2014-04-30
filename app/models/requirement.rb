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
  has_ancestry cache_depth: true
  belongs_to :project, foreign_key: :proj_id

  # before_destroy :subtract_range_from_parents, on: :destroy
  #after_save :add_min_range_to_parent
  # after_update :update_tree_range_after_edit, on: :update


  # def add_min_range_to_parent
  #   if parent_id.present?
  #     parent.minimum += self.minimum
  #     parent.save
  #   end
  # end

  # def add_max_range_to_parent
  #   if self.parent_id.present?
  #     self.parent.update_attribute(:minimum, (self.minimum + self.parent.minimum))
  #   end
  # end

  # def add_ml_range_to_parent
  #   if self.parent_id.present?
  #     self.parent.update_attribute(:minimum, (self.minimum + self.parent.minimum))
  #   end
  # end



  # def add_range_to_parents
  #   copy_to_traverse_tree = Marshal.load( Marshal.dump(self) ) 
  #   while !(copy_to_traverse_tree.parent_id.nil?)
  #     the_parent = Requirement.find(copy_to_traverse_tree.parent_id)
  #     the_parent.update_attributes(minimum: (the_parent.minimum + self.minimum),
  #                                   maximum: (the_parent.maximum + self.maximum),
  #                                   most_likely: (the_parent.most_likely + self.most_likely))
  #     copy_to_traverse_tree = Requirement.find(copy_to_traverse_tree.parent_id)
  #   end
  # end

  # def update_tree_range_before_delete
  #   copy_to_traverse_tree = Marshal.load( Marshal.dump(self) ) 
  #   while !(copy_to_traverse_tree.parent_id.nil?)
  #     the_parent = Requirement.find(copy_to_traverse_tree.parent_id)
  #     the_parent.update_attributes(minimum: (the_parent.minimum - self.minimum),
  #                                   maximum: (the_parent.maximum - self.maximum),
  #                                   most_likely: (the_parent.most_likely - self.most_likely))
  #     copy_to_traverse_tree = Requirement.find(copy_to_traverse_tree.parent_id)
  #   end
  # end

  # def update_tree_range_after_edit(requirement_old)
  #   min = self.minimum - requirement_old.minimum
  #   ml = self.most_likely - requirement_old.most_likely
  #   max = self.maximum - requirement_old.maximum

  #   if self.parent_id.nil?    
  #     if (self.has_children?) 
  #       reset_subtree_ranges
  #     end
  #   else
  #     reset_subtree_ranges
      
  #     copy_to_traverse_tree = Marshal.load( Marshal.dump(self) ) 
  #     while !(copy_to_traverse_tree.parent_id.nil?)
  #       the_parent = Requirement.find(copy_to_traverse_tree.parent_id)
  #       the_parent.update_attributes(minimum: (the_parent.minimum + min),
  #       maximum: (the_parent.maximum + max),
  #       most_likely: (the_parent.most_likely + ml))
  #       copy_to_traverse_tree = Requirement.find(copy_to_traverse_tree.parent_id)
  #     end
  #   end
  # end

  # def reset_subtree_ranges
  #   kids = self.subtree_ids
  #   kids.delete(self.id)
  #   kids.each do |kid| 
  #     req = Requirement.find(kid)
  #     req.update_attributes(minimum: 0, most_likely: 0, maximum: 0)
  #   end
  # end





  def update_ranges
    # node is instance of requirement
    unless self.has_nil_range?  
      current_node = self.parent
      while !current_node.is_root?
        current_node.set_range_to_sum_of_children_ranges
        current_node = current_node.parent
      end
      current_node.set_range_to_sum_of_children_ranges
    end
  end


  def set_range_to_sum_of_children_ranges
    range = self.find_sum_of_ranges_of_children
    self.update_attributes(minimum: range[:min], most_likely: range[:ml], maximum: range[:max])
  end

protected

  def find_sum_of_ranges_of_children
    range = {min: 0, ml: 0, max: 0}
    self.children.each do |node|
      range[:min] += node.minimum
      range[:ml] += node.most_likely
      range[:max] += node.maximum
    end
    return range
  end

  def has_nil_range?
  	[minimum, maximum, most_likely].any? { |range| range.nil? }
  end


  # def deepest_parent_node
  #   depth = 0
  #   deepest = 0
  #   if self.root.has_children? 
  #     ids = self.root.subtree_ids
  #     ids.each do |id|
  #       current_node = Requirement.find(id)
  #       if current_node.depth > depth
  #         depth = current_node.depth
  #         deepest = current_node
  #       end
  #     end
  #     node = deepest
  #   else
  #     node = self
  #   end

  #   node.parent
  # end

end
