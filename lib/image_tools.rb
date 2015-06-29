require 'RMagick'
require 'fileutils'
require 'digest'

class ImageTools


  def getImageData(imgPath)
    img = Magick::Image.read(imgPath).first

    {
        width: img.columns,
        height: img.rows,
        filesize: img.filesize
    }
  end

    def thumbnail(source, target, width, height = nil)
      return nil unless File.file?(source)
      height ||= width

      img = Magick::Image.read(source).first
      rows, cols = img.rows, img.columns

      source_aspect = cols.to_f / rows
      target_aspect = width.to_f / height
      thumbnail_wider = target_aspect > source_aspect

      factor = thumbnail_wider ? width.to_f / cols : height.to_f / rows
      img.thumbnail!(factor)
      img.crop!(Magick::CenterGravity, width, height)

      FileUtils.mkdir_p(File.dirname(target))
      img.write(target) { self.quality = 75 }
    end

  def generatePalette(img, num=5)

    image = Magick::ImageList.new(img)
    q = image.quantize(num, Magick::RGBColorspace)
    palette = q.color_histogram.sort {|a, b| b[1] <=> a[1]}
    total_depth = image.columns * image.rows
    results = []

    palette.count.times do |i|
      p = palette[i]

      r1 = p[0].red / 256
      g1 = p[0].green / 256
      b1 = p[0].blue / 256

      r2 = r1.to_s(16)
      g2 = g1.to_s(16)
      b2 = b1.to_s(16)

      r2 += r2 unless r2.length == 2
      g2 += g2 unless g2.length == 2
      b2 += b2 unless b2.length == 2

      hex = "#{r2}#{g2}#{b2}"
      depth = p[1]

      results << {
          rgb: {
              red: r1,
              green: g1,
              blue: b1
          },
          hex: hex,
          percent: ((depth.to_f / total_depth.to_f) * 100).round(2)
      }
    end

    results
  end

end