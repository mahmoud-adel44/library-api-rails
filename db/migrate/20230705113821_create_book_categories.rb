class CreateBookCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :book_categories do |t|
      t.belongs_to :book, null: false, foreign_key: true
      t.belongs_to :category, null: false, foreign_key: true
      t.timestamps
    end

    add_index :book_categories, [:book_id, :category_id], unique: true
  end
end
