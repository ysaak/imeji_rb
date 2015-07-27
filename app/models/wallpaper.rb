class Wallpaper < ActiveRecord::Base
  has_many :colors, dependent: :destroy

  has_and_belongs_to_many :tags, -> { order('tags.category DESC, tags.name ASC') },
                          after_add: :update_tag_wall_count, after_remove: :update_tag_wall_count

  def update_tag_wall_count(tag)
    tag.update_wallpapers_count
  end

  def wall_path
    return "walls/#{self.id.to_s}.#{self.ext}"
  end

  def thumb_path
    return "thumbs/#{self.id.to_s}.png"
  end

end
