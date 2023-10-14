# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class CategorySerializer
  include JSONAPI::Serializer
  attributes :name

  attribute :books, if: Proc.new { |record, params|
    params[:include_relations]&.dig(:books) || false
  } do |category|
    BookSerializer.new(category.books,{
      params: {
        include_relations: {
          categories: false
        }
      }
    }).serializable_hash
  end

  class << self
    def meta(categories)
      {
        current_page: categories.current_page,
        next_page: categories.next_page,
        prev_page: categories.prev_page,
        total_pages: categories.total_pages,
        total_count: categories.total_count
      }
    end
  end

end
