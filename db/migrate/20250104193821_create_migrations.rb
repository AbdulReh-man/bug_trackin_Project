class CreateMigrations < ActiveRecord::Migration[8.0]
  def change
    create_table :bugs do |t|
      t.string :title, null: false
      t.text :description
      t.references :project, null: false, foreign_key: true
      t.datetime :deadline
      t.string :status, null: false
      t.string :bug_type, null: false 
      t.timestamps
    end

    add_index :bugs, [:title, :project_id], unique: true 
  end
end
