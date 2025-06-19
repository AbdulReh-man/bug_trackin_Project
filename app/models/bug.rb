class Bug < ApplicationRecord
  belongs_to :project
  belongs_to :creator, class_name: "User"
  belongs_to :developer, class_name: "User", optional: true
  has_one_attached :screenshot

  enum :status, { newStatus: 0, started: 1, completed: 2, resolved: 3 }
  enum :bug_type, { bug: 0, feature: 1 }
  
  validates :developer_id, presence: true, on: :update
  validates :title, presence: true, uniqueness: { scope: :project_id, message: "should be unique within the project" }
  validates :bug_type, presence: true
  validates :status, presence: true

  private

  def screenshot_format
    if screenshot.attached? && !['image/png', 'image/gif'].include?(screenshot.content_type)
      errors.add(:screenshot, "must be a .png or .gif image")
    end
  end
end