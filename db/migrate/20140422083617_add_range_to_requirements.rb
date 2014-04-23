class AddRangeToRequirements < ActiveRecord::Migration
  def change
    add_column :requirements, :range, :string
  end
end
