require "rails_helper"

RSpec.describe "Articles", type: :request do
  describe "GET /articles" do
    subject { get(api_v1_articles_path) }

    before { create_list(:article, 3) }

    it "記事の一覧が取得できる" do
      subject

      res = JSON.parse(response.body)

      aggregate_failures do
        expect(response).to have_http_status(:ok)
        expect(res.length).to eq 3
        expect(res[0].keys).to eq ["id", "title", "body", "user"]
        expect(res[0]["user"].keys).to eq ["id", "name", "email"]
      end
    end
  end

  describe "GET /users/:id" do
    subject { get(api_v1_article_path(article_id)) }

    context "指定した id のユーザーが存在する場合" do
      let(:article) { create(:article) }
      let(:article_id) { article.id }

      it "任意のユーザーの値が取得できる" do
        subject

        res = JSON.parse(response.body)

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(res["id"]).to eq article.id
          expect(res["title"]).to eq article.title
          expect(res["body"]).to eq article.body
          expect(res["user"]["id"]).to eq article.user.id
          expect(res["user"].keys).to eq ["id", "name", "email"]
        end
      end
    end

    context "指定した id のユーザーが存在しない場合" do
      let(:article_id) { 10000 }

      it "ユーザーが見つからない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "POST /articles" do
    subject { post(api_v1_articles_path(params: params)) }

    let(:params) { { article: attributes_for(:article) } }
    let(:current_user) { create(:user) }

    before do
      allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user)
    end

    it "記事作成できる" do
      expect { subject }.to change { Article.count }.by(1)
      expect(response).to have_http_status(:no_content)
      res = JSON.parse(response.body)
      expect(res["title"]).to eq params[:article][:title]
      expect(res["body"]).to eq params[:article][:body]
    end
  end

  describe "PATCH /articles/:id" do
    subject { patch(api_v1_article_path(article_id), params: params) }

    let(:params) { { article: attributes_for(:article) } }
    let(:article) { create(:article) }
    let(:article_id) { article.id }

    it "articleのレコード更新ができる" do
      expect { subject }.to change { Article.find(article.id).title }.from(article.title).to(params[:article][:title]) &
                            change { Article.find(article.id).body }.from(article.body).to(params[:article][:body])
      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE /api/v1/articles/:id" do
    subject { delete(api_v1_article_path(article.id)) }

    let!(:article) { create(:article, user: current_user) }
    let(:current_user) { create(:user) }
    before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(current_user) }

    context "自分の記事を削除する場合" do
      it "articleのレコードを削除できる" do
        expect { subject }.to change { current_user.articles.count }.by(-1)
        expect(response).to have_http_status(:success)
      end
    end
  end
end
