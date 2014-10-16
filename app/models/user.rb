class User < ActiveRecord::Base
  has_many :taggings
  has_many :tags, through: :taggings
  has_many :items
end