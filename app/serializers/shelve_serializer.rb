# == Schema Information
#
# Table name: shelves
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  max_amount :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ShelveSerializer
  include JSONAPI::Serializer
  attributes :name
  attribute :created_at do |record|
    record.created_at_formated
  end

  attribute :books, if: Proc.new { |record, params|
    params[:include_relations]&.dig(:books) || false
  } do |shelve|
    BookSerializer.new(shelve.books,{
      params: {
        include_relations: {
          shelve: false
        }
      }
    }).serializable_hash
  end

  class << self
    def meta(shelves)
      {
        current_page: shelves.current_page,
        next_page: shelves.next_page,
        prev_page: shelves.prev_page,
        total_pages: shelves.total_pages,
        total_count: shelves.total_count
      }
    end
  end
end
