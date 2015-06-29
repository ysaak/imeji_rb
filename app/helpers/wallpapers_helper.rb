module WallpapersHelper

  def wallpaper_image_tag(wall, options={})
    return  image_tag 'walls/' + wall.id.to_s + wall.ext, options
  end

  def wallpaper_thumb_tag(wall, options={})
    return  image_tag 'thumbs/' + wall.id.to_s + '.png', options
  end

  def wallpaper_dl_path(wall)
    return '/images/walls/' + wall.id.to_s + wall.ext
  end

  def color_link(color)

    arr_color = [color.red.to_i, color.green.to_i, color.blue.to_i]
    hexColor = ''

    arr_color.each do |component|
      hex = component.to_s(16)
      if component < 16
        hexColor << "0#{hex}"
      else
        hexColor << hex
      end
    end


    #background-color: rgb(<%= color.red %>, <%= color.green %>, <%= color.blue %>); color: <%= get_color_from_background(color.red.to_i, color.green.to_i, color.blue.to_i) %>; flex: 0 0 auto; width: 20%

    return link_to ' ', search_color_path(hexColor), 'style' => 'background-color: #' + hexColor

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
