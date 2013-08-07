class User < ActiveRecord::Base
  attr_accessible :username, :user_id
  validates :username, :uniqueness => true


  has_many :statuses, :foreign_key => :author_id, :class_name => "Status"
  has_many :following, :foreign_key => :follower_id, :class_name => "Follow"
  has_many :leading, :foreign_key => :leader_id, :class_name => "Follow"

  has_many :followers,
  :through => :leading,
  :source => :follower


  has_many :leaders,
  :through => :following,
  :source => :leader

  has_many :followed_statuses,
  :through => :leaders,
  :source => :statuses

end
