class CreateSessionTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :session_tokens do |t|
      t.integer :user_id, null: false
      t.string :token, null: false

      t.timestamps
    end
    add_index :session_tokens, :token
  end
end
