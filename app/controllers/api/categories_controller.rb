class Api::CategoriesController < ApiApplicationController
  def index
    @categories = Category.includes(:books).page(params[:page])
    response_success(
      data: CategorySerializer.new(@categories,{
        meta: CategorySerializer.meta(@categories),
        params: {
          include_relations: {
            books: true
          }
        }
      }).serializable_hash
    )
  end

end
