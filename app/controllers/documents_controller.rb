class DocumentsController < ApplicationController

  def create
    file = Document.new(file_params)
    file.assign_tags(params[:tags])

    if file.save
      render json: { uuid: file.uuid }, status: :created
    else
      render json: file.errors, status: :unprocessable_entity
    end
  end

  def search
    search = params[:tag_search_query]
    page = params[:page]

    response = Document.response(search, page.to_i)

    render json: {
      total_records: response[:documents].count,
      related_tags: response[:related_tags].map {|tag| { name: tag.name } },
      records: response[:documents].map {|d| {name: d.name, uuid: d.uuid}}
    }
  end

  private

    def file_params
      params.permit(:name)
    end
end
