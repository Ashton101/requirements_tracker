class AddAncestryDepthToRequirements < ActiveRecord::Migration
  def change
    add_column :requirements, :ancestry_depth, :integer
  end
end
