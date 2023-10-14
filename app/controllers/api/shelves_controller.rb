class Api::ShelvesController < ApiApplicationController

  def index
    @shelves = Shelve.includes(:books).page(params[:page])

    response_success(
      data: ShelveSerializer.new(@shelves,{
        meta: ShelveSerializer.meta(@shelves),
        params: {
          include_relations: {
            books: true
          }
        }
      }).serializable_hash
    )
  end

end
