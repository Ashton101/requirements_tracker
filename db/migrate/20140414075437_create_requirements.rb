class CreateRequirements < ActiveRecord::Migration
  def change
    create_table :requirements do |t|
      t.string :name
      t.string :description
      t.integer :proj_id

      t.timestamps
    end
  end
end
