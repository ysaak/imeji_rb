class Group < ActiveRecord::Base
  has_many :tags

  validates :name, presence: true, length: { minimum: 3 }, uniqueness: true
end
