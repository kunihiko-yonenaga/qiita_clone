class Article < ApplicationRecord
  with_options presence: true do
    validates :title
    validates :body
  end

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :article_likes, dependent: :destroy
end
