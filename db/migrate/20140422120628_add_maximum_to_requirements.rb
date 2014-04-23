class AddMaximumToRequirements < ActiveRecord::Migration
  def change
    add_column :requirements, :maximum, :integer
  end
end
