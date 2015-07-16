module TagsHelper

  def background_string(wallpaper, x_pos, y_pos)
    if wallpaper.nil?
      'background: #6a819a'
    else
      raw("background: url('#{image_url wallpaper.wall_path}') no-repeat #{x_pos} #{y_pos}")
    end
  end

end
