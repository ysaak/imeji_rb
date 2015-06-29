class Wallpaper < ActiveRecord::Base
  has_many :colors, dependent: :destroy

  has_and_belongs_to_many :tags
end
