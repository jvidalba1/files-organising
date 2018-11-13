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

    documents = Document.by_tags(search, page.to_i)

    render json: {
      total_records: documents.count,
      related_tags: documents.map { |doc| doc.related_tags }.flatten.uniq,
      records: documents.map {|d| d.records }
    }
  end

  private

    def file_params
      params.permit(:name)
    end
end
