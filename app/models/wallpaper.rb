class Wallpaper < ActiveRecord::Base
  has_many :colors, dependent: :destroy

  has_and_belongs_to_many :tags, -> { order('tags.name ASC') }

  def wall_path
    return "walls/#{self.id.to_s}.#{self.ext}"
  end

  def thumb_path
    return "thumbs/#{self.id.to_s}.png"
  end

end
