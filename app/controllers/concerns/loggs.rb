module Loggs
  extend ActiveSupport::Concern

  included do
    after_create :log_creation
  end

  def log_creation
    Rails.logger.info "User #{self.username} created at #{self.created_at}"
  end
end
