class WallpapersController < ApplicationController

  def index
    @walls = Wallpaper.where(:purity => 'SFW').order('rand()').limit(12)
  end

  def show
    @wall = Wallpaper.find(params[:id])
    @tagCount = Tag.wallpapers_count @wall.tags.ids
  end

  def edit

    @wallpaper = Wallpaper.find(params[:id])

    editQuery = QueryParser.new.parse_query(params[:edqu])

    if editQuery[:tag_count] > 0

      # Add tags
      if not editQuery[:tags][:related].blank?

        initTagsList = editQuery[:tags][:related]
        tags = Tag.where :name => editQuery[:tags][:related]

        tags.each do |tag|
          @wallpaper.tags << tag

          # Remove tag from request list
          initTagsList.delete tag.name
        end

        # Create non existing tags
        initTagsList.each do |newTagName|


          newTag = Tag.new :name => newTagName
          newTag.save!

          @wallpaper.tags << newTag
        end
      end

      # Remove tags
      if not editQuery[:tags][:exclude].blank?

        tags = Tag.where :name => editQuery[:tags][:exclude]

        tags.each do |tag|
          @wallpaper.tags.delete tag
        end

      end

      # Purity
      if editQuery.has_key? :purity and ['SFW', 'NSFW', 'SKETCHY'].include? editQuery[:purity]
        @wallpaper.purity = editQuery[:purity]
      end


      # or (not urlQuery[:tags][:].blank?)

      @wallpaper.save!
    end

    redirect_to wallpaper_path(@wallpaper)
  end

  def search

    if params.has_key? :q
      @queryString = params[:q]
    elsif session.has_key? :last_search
      @queryString = session[:last_search]
    end

    session[:last_search] = @queryString
    url_query = QueryParser.new.parse_query(@queryString)

    # Init vars
    sql_query = []
    join_query = []
    query_params = {}
    @limit = 20
    page = 1

    @related_tags = nil

    if params.has_key? :page
      page = params[:page].to_i
      if page <= 0
        page = 1
      end
    end

    if url_query[:tag_count] > 0


      [:width, :height, :ratio, :score].each do |part|

        if url_query.has_key? part

          query = part.to_s + ' ';
          case url_query[part][0]
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
          sql_query << query
          query_params[part] = url_query[part][1]
        end
      end


      [:purity, :purity_negated, :ext, :ext_negated].each do |part|
        if url_query.has_key? part
          if part.to_s.end_with? 'negated'
            key = part.to_s.partition('_')[0]
            op = '<>'
          else
            key = part.to_s
            op = '='
          end

          sql_query << "#{key} #{op} :#{part.to_s}"
          query_params[part] = url_query[part]
        end
      end

      if url_query.has_key? :color
        join_query << 'INNER JOIN colors ON wallpapers.id = colors.wallpaper_id'
        sql_query << 'SQRT( POW( red - :qRed, 2 ) + POW( green - :qGreen, 2 ) + POW( blue - :qBlue, 2 ) ) <= 20'

        query_params[:qRed] = url_query[:color][0]
        query_params[:qGreen] = url_query[:color][1]
        query_params[:qBlue] = url_query[:color][2]
      end


      if (not url_query[:tags][:related].blank?) or (not url_query[:tags][:exclude].blank?)
        if url_query[:tags][:related].present?
          include_tag_ids = Tag.list_ids_by_names(url_query[:tags][:related]) || []
          include_tag_ids << 0 if include_tag_ids.blank?

          join_query << 'INNER JOIN tags_wallpapers ON wallpaper_id = wallpapers.id'
          sql_query << 'tag_id IN (:qIncTagIds)'
          query_params[:qIncTagIds] = include_tag_ids
        end

        if url_query[:tags][:exclude].present?
          exclude_tag_ids = Tag.list_ids_by_names(url_query[:tags][:exclude]) || []
          exclude_tag_ids << 0 if exclude_tag_ids.blank?

          sql_query << 'not exists (select 1 from tags_wallpapers tw2 where tw2.wallpaper_id = wallpapers.id and tag_id in (:qExcTagIds))'
          query_params[:qExcTagIds] = exclude_tag_ids
        end
      end


      if url_query.has_key? :limit
        @limit = url_query[:limit]
      end

      if join_query.length > 0 then
        @walls = Wallpaper.joins(join_query.join(' ')).distinct.where(sql_query.join(' AND '), query_params).limit(@limit).offset((page-1) * @limit)
      else
        @walls = Wallpaper.where(sql_query.join(' AND '), query_params).limit(@limit).offset((page-1) * @limit)
      end


      if @walls.blank? and (url_query[:tags][:related].present? and url_query[:tags][:related].size == 1)
        @related_tags = Tag.contains_word url_query[:tags][:related][0]

        if @related_tags.present?
          @related_tags = @related_tags.to_a
        end
      end

    else
      if url_query.has_key? :limit
        @limit = url_query[:limit]
      end

      @walls = Wallpaper.all.limit(@limit).offset( (page-1) * @limit )
    end

    if request.xhr?
      render jbuilder: @walls
      return
    end
  end

  def untagged
    @walls = Wallpaper.where('NOT EXISTS (SELECT 1 FROM tags_wallpapers WHERE wallpaper_id = wallpapers.id)').limit(12)
  end
end
