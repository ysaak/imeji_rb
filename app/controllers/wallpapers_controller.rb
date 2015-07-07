class WallpapersController < ApplicationController

  def index
    @walls = Wallpaper.where('purity = :purity', :purity => 'SFW').order('rand()').limit(12)
  end

  def show
    @wall = Wallpaper.find(params[:id])
  end

  def search

    @queryString = params[:q]
    if params.has_key? :color
      @queryString = "color:#{params[:color]}"
    end

    urlQuery = QueryParser.new.parse_query(@queryString)

    # Init vars
    sqlQuery = []
    joinQuery = []
    qParams = {}
    @limit = 20
    page = 1

    if params.has_key? :page
      page = params[:page].to_i
      if page <= 0
        page = 1
      end
    end

    if urlQuery[:tag_count] > 0


      [:width, :height, :ratio, :score].each do |part|

        if urlQuery.has_key? part

          query = part.to_s + ' ';
          case urlQuery[part][0]
            when :lte
              query += '<='
            when :lt
              query += '<'
            when :gte
              query += '>='
            when :gt
              query += '>'
            else
              query += '='
          end

          query += ' :' + part.to_s
          sqlQuery << query
          qParams[part] = urlQuery[part][1]
        end
      end


      [:purity, :purity_negated, :ext, :ext_negated].each do |part|
        if urlQuery.has_key? part
          if part.to_s.end_with? 'negated'
            key = part.to_s.partition('_')[0]
            op = '<>'
          else
            key = part.to_s
            op = '='
          end

          sqlQuery << "#{key} #{op} :#{part.to_s}"
          qParams[part] = urlQuery[part]
        end
      end

      if urlQuery.has_key? :color
        joinQuery << 'INNER JOIN colors ON wallpapers.id = colors.wallpaper_id'
        sqlQuery << 'SQRT( POW( red - :qRed, 2 ) + POW( green - :qGreen, 2 ) + POW( blue - :qBlue, 2 ) ) <= 20'

        qParams[:qRed] = urlQuery[:color][0]
        qParams[:qGreen] = urlQuery[:color][1]
        qParams[:qBlue] = urlQuery[:color][2]
      end

      @q = urlQuery


      if urlQuery.has_key? :limit
        @limit = urlQuery[:limit]
      end

      if joinQuery.length > 0
        @walls = Wallpaper.joins(joinQuery.join(' ')).distinct.where(sqlQuery.join(' AND '), qParams).limit(@limit).offset( (page-1) * @limit )
      else
        @walls = Wallpaper.where(sqlQuery.join(' AND '), qParams).limit(@limit).offset( (page-1) * @limit )
      end
    else
      if urlQuery.has_key? :limit
        @limit = @urlQuery[:limit]
      end

      @walls = Wallpaper.all.limit(@limit).offset( (page-1) * @limit )
    end

    if request.xhr?
      render jbuilder: @walls;
      return
    end
  end
end
