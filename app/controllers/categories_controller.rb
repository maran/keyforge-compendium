class CategoriesController < InheritedResources::Base
   before_action :authenticate_user!

  def update
    super do |format|
      format.html { redirect_to categories_path }
    end
  end

  def create
    super do |format|
      format.html { redirect_to categories_path }
    end
  end

protected
  def begin_of_association_chain
    current_user
  end

  private

    def category_params
      params.require(:category).permit(:name)
    end
end

