class ChangeDeveloperIdNullConstraintOnBugs < ActiveRecord::Migration[8.0]
  def change
     change_column_null :bugs, :developer_id, true
  end
end
