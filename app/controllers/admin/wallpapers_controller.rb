require 'pathname'

class Admin::WallpapersController < ApplicationController
  def import

    @import_folder = Pathname(Parameter.import_path)

    @file_list = []

    llist = Dir[@import_folder.to_s + '**/*.png', @import_folder.to_s + '**/*.jpg']

    llist.each do |file|
      @file_list << { :text => file.to_s[@import_folder.to_s.size..-1], :hash => Base64.encode64(file.to_s) }
    end
  end

  def do_import

    Rails.logger.info params[:wallfile]

    if params[:type] == 'single'
      # TODO : check mime type content_type
      wall = import_wallpaper params[:wallfile].tempfile.path, params[:wallfile].original_filename

      # TODO: flash info about success or error :(
      redirect_to wall

    else
      Rails.logger.info 'Multple upload !!'

      @import_folder = Pathname(Parameter.import_path)
      llist = Dir[@import_folder.to_s + '**/*.png', @import_folder.to_s + '**/*.jpg']

      # TODO: run in background thread
      llist.each do |file|

        import_wallpaper file

      end

      redirect_to :admin_import_wallpaper
    end
  end

  def import_wallpaper(img_file, img_name=nil)
    iTools = ImageTools.new

    imgData = iTools.getImageData(img_file)
    imgHash = Digest::SHA2.hexdigest(File.read(img_file))

    wall = Wallpaper.new({
        filehash: imgHash,
        ext: File.extname(img_name.nil? ? img_file : img_name)[1..-1],
        size: imgData[:filesize],
        width: imgData[:width],
        height: imgData[:height],

        category: 'GENERAL',
        purity: 'SFW'
    })

    wall.save!

    full_image = Rails.public_path.to_s + '/images/' + wall.wall_path

    # Copie de l'image
    FileUtils.cp(img_file, full_image)

    # Thumbnail
    thumb_path = Rails.public_path.to_s + '/images/' + wall.thumb_path
    iTools.thumbnail(full_image, thumb_path, 300, 200)

    # Palette
    img_palette = iTools.generatePalette(img_file, 5)

    img_palette.each do |color|

      color_data = {
          wallpaper_id: wall.id,
          red: color[:rgb][:red],
          green: color[:rgb][:green],
          blue: color[:rgb][:blue],
          percent: color[:percent]
      }

      wall.colors.create(color_data)
    end

    wall
  end
end
