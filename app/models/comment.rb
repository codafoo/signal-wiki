class Comment < ActiveRecord::Base
  belongs_to :page
  belongs_to :user
  
  def user_name
    self.user ? self.user.login.capitalize : "Anonymous"
  end
  
  def user_email
    self.user ? self.user.email : "nil"
  end
end
