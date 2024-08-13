class Account < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.string :user_id
      t.boolean :admin, default: false
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :avatar_url
      t.timestamps
    end
  end
end
