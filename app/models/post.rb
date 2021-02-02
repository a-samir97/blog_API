class Post < ApplicationRecord
  belongs_to :user
  has_many :comments , :dependent => :delete_all
  has_and_belongs_to_many :tags
end
