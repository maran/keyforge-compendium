class NewsController < ApplicationController
  def index
    @pages = Page.limit(3).where(is_blog: true).order(created_at: :desc).page(params[:page])
  end

  def show
    @page = Page.find_by(slug: params[:id])
    unless @page.present?
      redirect_to "/news", notice: "Could not find news post"
    end
  end
end
