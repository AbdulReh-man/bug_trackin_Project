class User < ApplicationRecord
    # Add virtual login attribute for the form
  attr_accessor :login

  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,:validatable

  include DeviseTokenAuth::Concerns::User

  has_many :user_projects
  has_many :projects, through: :user_projects
  include Loggs

  before_destroy :user_project_destroy
  
  # Email downcase callback
  before_validation :downcase_email
  before_validation :downcase_username

  enum :role, { manager: 0, developer: 1, qa: 2 }

  def login
    @login || username || email
  end

  # Add case-insensitive finders for authentication
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup

    login = conditions.delete(:login).downcase
    where(conditions).where(
      "(LOWER(email) = :login OR LOWER(username) = :login)",
      login: login
    ).first
  end

  def user_project_destroy
    self.user_projects.destroy_all
  end
  
  private
  
  def downcase_email
    self.email = email.downcase if email.present?
  end
  
  def downcase_username
    self.username = username.downcase if username.present?
  end

end