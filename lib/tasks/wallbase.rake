require 'terminfo'

namespace :wallbase do
  desc "Load wallpapers from path"
  task :load, :response do |t, args|

    require "#{Rails.root}/lib/image_tools"
    require "#{Rails.root}/app/models/wallpaper"

    response = args[:response]

    puts response

    baseDir = '/Users/ysaak/Pictures/Wallpapers/';

    llist = Dir[baseDir + '**/*.png', baseDir + '**/*.jpg']

    # Term data
    termsize = TermInfo.screen_size


    nbFiles = llist.size
    nbFilesStr = nbFiles.to_s.size

    fileTextMaxLen = termsize[1].to_i - (4 + 2 * nbFilesStr) - (12)
    lineFormat = '[%' + nbFilesStr.to_s + 'd/%d] %-' + fileTextMaxLen.to_s + 's | ETA %2d:%02d'


    workDuration = []

    i = 0


    iTools = ImageTools.new

    llist.each do |img|

      dMin = 0
      dSec = 0
      if workDuration.size > 0
        avg = workDuration.inject{ |sum, el| sum + el }.to_f / workDuration.size

        avg *= nbFiles - i

        dSec = avg % 60
        dMin = ((avg / 60) % 60).to_i
      end

      i += 1
      puts lineFormat % [ i, nbFiles, img.truncate(fileTextMaxLen), dMin, dSec ]

      start = Time.now.to_i

      iTools.addImage(img)

      finish = Time.now.to_i

      workDuration << finish - start
    end
  end
end
