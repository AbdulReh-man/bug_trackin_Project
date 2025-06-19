class ChangeDatatypeToInteger < ActiveRecord::Migration[8.0]
  def change
    change_column :bugs, :status, :integer, using: 'status::integer'
    change_column :bugs, :bug_type, :integer, using: 'bug_type::integer'
  end
end
