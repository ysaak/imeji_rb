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


  def tags_list(tags, mode=:ul)
    if mode == :inline
      tags_list_inline tags
    else
      tags_list_ul tags
    end
  end


  private
    def tags_list_inline(tags)

      list = tags || []

      if list.blank?
        ''
      else
        last = list.pop

        html = list.map{ |tag| tag_link tag }.join ', '

        if html.blank?
          html = tag_link last
        else
          html = "#{html} or #{tag_link last, false}"
        end

        html.html_safe
      end
    end

    def tags_list_ul(tags)

      html = '<ul>'

      tags.each do |tag|
        html += "<li>#{link_to '?', tag}#{tag_link tag}</li>"
      end

      html += '</ul>'

      html.html_safe

    end

    def tag_link(tag, with_walls_count=true)
      text = tag.name
      text += "<span>#{tag.wallpapers_count}</span>" if with_walls_count

      link_to raw(text), search_path(:q => tag.name), class: "tag-category-#{tag.category}"
    end
end
