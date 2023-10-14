# frozen_string_literal: true

class CategoryBookValidator < ActiveModel::Validator
  #@param [Book]
  def initialize(book)
    # @type [Book]
    @book = book
  end

  # @return [void]
  def validate
    categories_with_too_many_books = Category.joins(:book_categories)
                                             .where(id: @book.category_ids)
                                             .group(:id)
                                             .having('COUNT(book_categories.book_id) > 3')

    categories_with_too_many_books.each do |category|
      @book.errors.add(:base, "Category #{category.name} should have less than or equal to 3 books")
    end
  end
end
