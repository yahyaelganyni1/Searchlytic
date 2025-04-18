class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  private

  def article_params
    params.require(:article).permit(:title, :content, :author, :category, :tags, :published_at)
  end
end
