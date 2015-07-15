module WallpapersHelper

  def wallpaper_image_tag(wall, options={})
    image_tag 'walls/' + wall.id.to_s + '.' + wall.ext, options
  end

  def wallpaper_thumb_tag(wall, options={})
    image_tag 'thumbs/' + wall.id.to_s + '.png', options
  end

  def wallpaper_thumb_path(wall)
    'thumbs/' + wall.id.to_s + '.png'
  end

  def wallpaper_dl_path(wall)
    '/images/walls/' + wall.id.to_s + '.' + wall.ext
  end

  def color_link(color)

    hex_color = ('%02x' * 3) % [color.red, color.green, color.blue]

    color_query = "color:#{hex_color}"

    link_to ' ', search_path(:q => color_query), 'style' => 'background-color: #' + hex_color

  end

  def get_color_from_background(red, green, blue)

    brighteness = ((red * 299) + (green * 587) + (blue * 114)) / 1000

    if brighteness > 125
      return '#000'
    else
      return '#FFF'
    end
  end
end
