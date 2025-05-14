class CreateReviews < ActiveRecord::Migration[7.2]
  def change
    create_table :reviews do |t|
      t.integer :book_id
      t.integer :user_id
      t.integer :rating
      t.text :review

      t.timestamps
    end
  end
end
