# == Schema Information
#
# Table name: projects
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Project < ActiveRecord::Base
	attr_accessible :name, :created_at, :user_id
	
	belongs_to :user
	has_many :requirements, foreign_key: :proj_id

end
