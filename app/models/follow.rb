class Follow < ActiveRecord::Base
  attr_accessible :follower_id, :leader_id

  belongs_to :follower, :foreign_key => :follower_id, :class_name => "User"

  belongs_to :leader, :foreign_key => :leader_id, :class_name => "User"
end
