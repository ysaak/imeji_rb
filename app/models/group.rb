class Group < ActiveRecord::Base
  has_many :tags

  has_many :subgroup, class_name: 'Group', foreign_key: 'parent_id'
  has_one :parent, class_name: 'Group', foreign_key: 'id', primary_key: 'parent_id'

  validates :name, presence: true, length: { minimum: 3 }, uniqueness: true

  def self.list_roots
    where(:parent_id => nil).order(:name)
  end
end
