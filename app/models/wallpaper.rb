class Wallpaper < ActiveRecord::Base
  has_many :colors, dependent: :destroy

  has_and_belongs_to_many :tags, -> { order('tags.category DESC, tags.name ASC') },
                          after_add: :update_tag_wall_count, after_remove: :update_tag_wall_count

  def update_tag_wall_count(tag)
    tag.update_wallpapers_count
  end

  def wall_path
    "walls/#{self.id.to_s}.#{self.ext}"
  end

  def thumb_path
    "thumbs/#{self.id.to_s}.png"
  end


  def update_tags_list(new_tags_names, tags_names_to_remove)

    # Adding new tag
    if new_tags_names.present?
      init_names_list = new_tags_names.map{|name| name.downcase}


      new_tags_list = Tag.list_with_implied init_names_list

      new_tags_list.each do |tag|
        tags << tag unless tags.include? tag

        # Remove tag from request list
        init_names_list.delete tag.name
      end

      # Any unkown tag name
      init_names_list.each do |tag_name|
        tags << Tag.create(:name => tag_name)
      end
    end

    # Removing tags
    if tags_names_to_remove.present?
      tags_to_remove = Tag.where :name => tags_names_to_remove.map{|name| name.downcase}

      tags_to_remove.each do |tag|
        tags.delete tag
      end
    end
  end
end
