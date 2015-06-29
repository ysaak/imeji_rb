class WallpapersController < ApplicationController

  def index
    @walls = Wallpaper.all.limit(20)
  end

  def show
    @wall = Wallpaper.find(params[:id])
  end

  def search

    # Init vars
    query = ''
    joinQuery = ''
    qParams = {}


    # Width
    if params.has_key? :width

      if query.length > 0
        query += ' AND '
      end

      if params[:x].nil? or params[:x] == 'up'
        operator = '>='
      else
        operator = '<='
      end

      query += 'width ' + operator + ' :qWidth'
      qParams[:qWidth] = params[:width]
    end

    # Height
    if params.has_key? :height

      if query.length > 0
        query += ' AND '
      end

      if params[:y].nil? or params[:y] == 'up'
        operator = '>='
      else
        operator = '<='
      end

      query += 'height ' + operator + ' :qHeight'
      qParams[:qHeight] = params[:height]
    end

    # Colors
    if params.has_key? :color and /^((#?\h{6})|(#?\h{3}))$/ =~ params[:color]

      color = params[:color]
      if color[0] == '#'
        color = color[1..-1]
      end

      if color.length == 3
        qParams[:qRed] = (color[0]*2).hex.to_s
        qParams[:qGreen] = (color[1]*2).hex.to_s
        qParams[:qBlue] = (color[2]*2).hex.to_s
      else
        qParams[:qRed] = (color[0..1]).hex.to_s
        qParams[:qGreen] = (color[2..3]).hex.to_s
        qParams[:qBlue] = (color[4..5]).hex.to_s
      end

      joinQuery += ' INNER JOIN colors ON wallpapers.id = colors.wallpaper_id '

      if query.length > 0
        query += ' AND '
      end
      query += 'SQRT( POW( red - :qRed, 2 ) + POW( green - :qGreen, 2 ) + POW( blue - :qBlue, 2 ) ) <= 20'

    end

    if joinQuery.length > 0
      @walls = Wallpaper.joins(joinQuery).distinct.where(query, qParams)
    else
      @walls = Wallpaper.where(query, qParams)
    end

  end
end
