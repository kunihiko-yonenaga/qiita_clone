class Api::V1::ArticlesController < Api::V1::BaseApiController
  before_action :set_article, only: [:show]

  def index
    articles = Article.all
    render json: articles
  end

  def show
    render json: @article
  end

  def create
    @article = current_user.articles.create!(article_params)
    render json: @article
  end

  private

    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :body)
    end
end
