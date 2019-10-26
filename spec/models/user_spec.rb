require "rails_helper"

RSpec.describe User, type: :model do
  describe "user-validation" do
    context "アカウントとメールアドレスが入力されている時" do
      let(:user) { build(:user) }
      it "バリデーションをとおる（ユーザー作成できる）" do
        expect(user).to be_valid
      end
    end
  end
  describe "user-validation-異常" do
    context "アカウントが入力されていない時" do
      let(:user) { build(:user, name: nil) }
      it "バリデーションを通らない（ユーザー作成できない）" do
        expect(user.valid?).to be false
      end
    end
    context "メールアドレスが入力されていない時" do
      let(:user) { build(:user, email: nil) }
      it "バリデーションをとおらない" do
        expect(user.valid?).to be false
      end
    end
    context "すでに登録済みのアカウントが入力された時" do
      before { create(:user, name: "user-x") }
      let(:user) { build(:user, name: "user-x") }
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