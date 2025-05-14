class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :name
      t.string :email
      t.string :address
      t.string :credit_card_number
      t.string :phone_number

      t.timestamps
    end
  end
end
