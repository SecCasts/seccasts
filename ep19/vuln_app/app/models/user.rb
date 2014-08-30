class User < ActiveRecord::Base
  
  def self.authenticate(username, password)
     user = User.find_by_username(username)
     if user && password == user.encrypted_password
       return user
     else
       return false
     end
  end

end
