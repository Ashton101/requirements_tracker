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
	has_ancestry
	belongs_to :project, foreign_key: :proj_id
end


