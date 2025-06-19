class User < ApplicationRecord
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable
  
  include DeviseTokenAuth::Concerns::User

  has_many :user_projects
  has_many :projects, through: :user_projects
  include Loggs

  before_destroy :user_project_destroy
  
  enum :role, { manager: 0, developer: 1, qa: 2 }

  def user_project_destroy
    self.user_projects.destroy_all
  end

end
