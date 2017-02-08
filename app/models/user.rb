class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  def after_confirmation
  	@last = User.last
  	Dir.mkdir(File.join("./public/folders/", @last.name), 0777)
  end

end
