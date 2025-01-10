class User < ApplicationRecord
  has_many :user_projects
  has_many :projects, through: :user_projects

  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
         def manager?
          self.role == "manager"
         end

         def developer?
          self.role == "developer"
         end

         def qa?
          self.role == "qa"
         end
end
