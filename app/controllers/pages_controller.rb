class PagesController < ApplicationController
  def show
    @page = Page.find_by(slug: params[:id])
  end

  def by_id
    @page = Page.find(params[:id])
  end
end
