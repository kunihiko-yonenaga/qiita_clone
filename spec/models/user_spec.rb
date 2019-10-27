require "rails_helper"

RSpec.describe User, type: :model do
  describe "user-validation" do
    context "nameとメールアドレスが入力されている時" do
      let(:user) { build(:user) }
      it "バリデーションを通る（ユーザー作成できる）" do
        expect(user).to be_valid
      end
    end
  end

  describe "user-validation-異常" do
    context "nameが入力されていない時" do
      let(:user) { build(:user, name: nil) }
      it "バリデーションを通らない（ユーザー作成できない）" do
        expect(user.valid?).to be false
      end
    end

    context "メールアドレスが入力されていない時" do
      let(:user) { build(:user, email: nil) }
      it "バリデーションを通らない" do
        expect(user.valid?).to be false
      end
    end

    context "すでに登録済みのメールアドレスが入力された時" do
      before { create(:user, email: "user@example.com") }

      let(:user) { build(:user, email: "user@example.com") }
      it "バリデーションを通らない" do
        expect(user.valid?).to be false
      end
    end
  end
end
