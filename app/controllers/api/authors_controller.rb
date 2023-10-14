class Api::AuthorsController < ApiApplicationController
  def index
    @authors = Author.includes(:books).page(params[:page])

    response_success(
      data: AuthorSerializer.new(@authors,{
        meta: AuthorSerializer.meta(@authors),
        params: {
          include_relations: {
            books: true
          }
        }
      }).serializable_hash
    )
  end
end
