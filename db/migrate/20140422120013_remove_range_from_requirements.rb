class RemoveRangeFromRequirements < ActiveRecord::Migration
  def change
    remove_column :requirements, :range, :string
  end
end
