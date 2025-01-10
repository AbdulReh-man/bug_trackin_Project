class AddCreatorAndDeveloperToBugs < ActiveRecord::Migration[8.0]
  def change
    add_reference :bugs, :creator, foreign_key: {to_table: :users}, null: false
    add_reference :bugs, :developer, foreign_key: {to_table: :users}, null: false

  end
end
