class AddMinimumToRequirements < ActiveRecord::Migration
  def change
    add_column :requirements, :minimum, :integer
  end
end
