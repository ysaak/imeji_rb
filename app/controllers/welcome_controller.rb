require 'RMagick'
require 'fileutils'
require 'digest'

class WelcomeController < ApplicationController

  def init

    baseDir = '/Users/ysaak/Pictures/Wallpapers/';

    llist = Dir[baseDir + '**/*.png', baseDir + '**/*.jpg']


    iTools = ImageTools.new

    llist.each do |img|

      imgData = iTools.getImageData(img)
      imgHash = Digest::SHA2.hexdigest(File.read(img))

      @wall = Wallpaper.new({
          filehash: imgHash,
          ext: File.extname(img),
          size: imgData[:filesize],
          width: imgData[:width],
          height: imgData[:height],

          category: 'GENERAL',
          purity: 'SFW'
      });

      @wall.save!

      fullImage = Rails.public_path.to_s + '/images/walls/' + @wall.id.to_s + @wall.ext

      # Copie de l'image
      FileUtils.cp(img, fullImage)

      # Thumbnail
      thumbPath = Rails.public_path.to_s + '/images/thumbs/' + @wall.id.to_s + '.png';
      iTools.thumbnail(fullImage, thumbPath, 300, 200)

      # Palette
      imgPalette = iTools.generatePalette(img, 5)

      imgPalette.each do |color|

        colorData = {
            wallpaper_id: @wall.id,
            red: color[:rgb][:red],
            green: color[:rgb][:green],
            blue: color[:rgb][:blue],
            percent: color[:percent]
        }

        @wall.colors.create(colorData)

      end

    end
  end

  def index
    @walls = Wallpaper.all
  end
end
