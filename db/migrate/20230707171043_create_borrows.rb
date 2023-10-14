class CreateBorrows < ActiveRecord::Migration[7.0]
  def change
    create_table :borrows do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :book, null: false, foreign_key: true
      t.datetime :borrowed_at, null: false
      t.datetime :return_time, null: false
      t.datetime :returned_at
      t.integer :status, :limit => 3 , default: 0
      t.timestamps
    end
  end
end
