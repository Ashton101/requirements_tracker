class AddMostLikelyToRequirements < ActiveRecord::Migration
  def change
    add_column :requirements, :most_likely, :integer
  end
end
