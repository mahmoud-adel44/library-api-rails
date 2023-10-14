# frozen_string_literal: true

class ShelveBookValidator < ActiveModel::Validator
  def initialize(book)
    # @type [Book]
    @book = book
  end

  def validate
    if @book.shelve.max_amount <= @book.shelve.books.count
      @book.errors.add :base, "This Book Can not be added to this shelve max books is #{@book.shelve.max_amount}"
    end
  end
end
