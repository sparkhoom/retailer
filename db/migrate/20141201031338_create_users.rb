class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :phone_number
      t.string :password_digest
      t.string :email
      t.string :name

      t.timestamps
    end
  end
end
