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
  end

  private

    def file_params
      params.permit(:name)
    end
end
