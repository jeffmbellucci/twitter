require 'json'

class Status < ActiveRecord::Base
  attr_accessible :author_id, :body, :status_id

  belongs_to :author, :foreign_key => :author_id, :class_name => "User"

  def self.sync_twitter_status
    author = User.find_by_username(TwitterSession.current_user)
    status_array = self.get_user_timeline
    author = User.create(:username => TwitterSession.current_user,
                 :user_id => status_array[0]["user"]["id"]) unless author
    status_array.each do |tweet|
      new_status = Status.new(:author_id => author.id,
                              :body => tweet["text"],
                              :status_id => tweet["id"])
      new_status.save!
    end
  end

  def self.get_user_timeline
    body = TwitterSession.get("http://api.twitter.com/1.1/statuses/user_timeline.json").body
    JSON.parse(body)
  end
end
