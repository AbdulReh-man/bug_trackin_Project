class Bug < ApplicationRecord
  belongs_to :project
  belongs_to :creator, class_name: "User"
  belongs_to :developer, class_name: "User", optional: true
  has_one_attached :screenshot

  validates :developer_id, presence: true, on: :update
  validates :title, presence: true, uniqueness: { scope: :project_id, message: "should be unique within the project" }
  validates :bug_type, presence: true, inclusion: { in: ['bug', 'feature'], message: "must be either 'bug' or 'feature'" }
  validates :status, presence: true, inclusion: { in: ->(bug) { bug.feature? ? bug.feature_statuses : bug.bug_statuses }, message: "is not valid for the selected bug type" }
  validate :screenshot_format

  def feature_statuses
    ['new', 'started', 'completed']
  end

  def bug_statuses
    ['new', 'started', 'resolved']
  end

  def feature?
    bug_type == 'feature'
  end

  def bug?
    bug_type == 'bug'
  end
  
  private
  def screenshot_format
    if screenshot.attached? && !['image/png', 'image/gif'].include?(screenshot.content_type)
      errors.add(:screenshot, "must be a .png or .gif image")
    end
  end
end
