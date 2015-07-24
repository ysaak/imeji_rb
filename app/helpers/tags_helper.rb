module TagsHelper

  def background_string(wallpaper, x_pos, y_pos)
    if wallpaper.nil?
      'background: #6a819a'
    else
      raw("background: url('#{image_url wallpaper.wall_path}') no-repeat #{x_pos} #{y_pos}")
    end
  end

  def tagslist_title(root_group, sub_group)
    if root_group.nil? and sub_group.nil?
      'Tags'
    elsif @sub_group.nil?
      "Tags : #{@root_group.name}"
    else
      "Tags : #{@sub_group.name}"
    end
  end

end
