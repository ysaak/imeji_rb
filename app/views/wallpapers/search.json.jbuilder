json.limit @limit

json.wallpapers @walls do |wall|

  json.thumb_path image_path wall.thumb_path
  json.path url_for wall

  json.width wall.width
  json.height wall.height
end