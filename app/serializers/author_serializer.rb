# == Schema Information
#
# Table name: authors
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class AuthorSerializer
  include JSONAPI::Serializer
  attributes :name

  attribute :books, if: Proc.new { |author, params|
    params[:include_relations]&.dig(:books)
  } do |author|
    BookSerializer.new(author.books, {
      params: {
        include_relations: {
          author: false
        }
      }
    }).serializable_hash
  end

  class << self
    def meta(authors)
      {
        current_page: authors.current_page,
        next_page: authors.next_page,
        prev_page: authors.prev_page,
        total_pages: authors.total_pages,
        total_count: authors.total_count
      }
    end
  end
end
