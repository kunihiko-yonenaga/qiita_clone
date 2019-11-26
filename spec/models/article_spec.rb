require "rails_helper"

RSpec.describe Article, type: :model do
  describe "title-validation check" do
    context "タイトルが５文字以上50文字以下のとき" do
      let(:article) { build(:article) }
      it "バリデーションが通る" do
        expect(article).to be_valid
      end
    end

    context "タイトルが未入力のとき（０文字）" do
      let(:article) { build(:article, title: nil) }
      it "バリデーションが通らない" do
        expect(article).not_to be_valid
      end
    end

    context "タイトルが１文字以上５文字未満のとき" do
      let(:article) { build(:article, title: Faker::Lorem.characters(number: Random.new.rand(1..4))) }
      it "バリデーションが通らない" do
        expect(article).not_to be_valid
      end
    end

    context "タイトルが51文字以上のとき" do
      let(:article) { build(:article, title: Faker::Lorem.characters(number: Random.new.rand(51..9_999_999))) }
      it "バリデーションが通らない" do
        expect(article).not_to be_valid
      end
    end

    describe "body-validation check" do
      context "記事が書かれているとき" do
        let(:article) { build(:article) }
        it "バリデーションが通る" do
          expect(article).to be_valid
        end
      end

      context "記事が書かれていないとき" do
        let(:article) { build(:article, title: nil) }
        it "バリデーションが通らない" do
          expect(article).not_to be_valid
        end
      end
    end
  end
end
