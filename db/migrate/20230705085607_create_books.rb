class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :name
      t.belongs_to :author, null: false, foreign_key: true
      t.belongs_to :shelve, null: false, foreign_key: true
      t.datetime :borrowed_at
      t.timestamps
    end
  end
end
