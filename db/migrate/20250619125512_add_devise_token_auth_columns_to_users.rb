class AddDeviseTokenAuthColumnsToUsers < ActiveRecord::Migration[8.0]
  def up
    change_table :users do |t|
      # Required for devise_token_auth
      t.string :provider, null: false, default: 'email'
      t.string :uid, null: false, default: ''
      t.text :tokens

      # Devise confirmable (optional, but often used with devise_token_auth)
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      # If you're using lockable with Devise, you might also add:
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at
    end

    # First, update existing users to have a unique uid based on their email.
    # This must happen BEFORE adding the unique index.
    User.reset_column_information # Ensure the model knows about new columns
    User.find_each do |user|
      # Ensure uid is unique. If email can be null, you might need a fallback,
      # e.g., SecureRandom.uuid or the user's ID.
      user.uid = user.email.present? ? user.email : "user-#{user.id}-#{SecureRandom.uuid}"
      user.provider = 'email'
      user.save!(validate: false) # Use validate: false to bypass model validations if needed
    end

    # Now, add the unique index.
    add_index :users, [:uid, :provider], unique: true
    add_index :users, :confirmation_token, unique: true # If using confirmable
  end

  def down
    remove_index :users, [:uid, :provider] if index_exists?(:users, [:uid, :provider])
    remove_index :users, :confirmation_token if index_exists?(:users, :confirmation_token)

    change_table :users do |t|
      remove_column :users, :provider
      remove_column :users, :uid
      remove_column :users, :tokens

      if column_exists?(:users, :confirmation_token)
        remove_columns :users, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email
      end

      # If you added lockable columns:
      # if column_exists?(:users, :failed_attempts)
      #   remove_columns :users, :failed_attempts, :unlock_token, :locked_at
      # end
    end
  end
end