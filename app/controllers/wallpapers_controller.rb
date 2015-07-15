class WallpapersController < ApplicationController

  def index
    @walls = Wallpaper.where('purity = :purity', :purity => 'SFW').order('rand()').limit(12)
  end

  def show
    @wall = Wallpaper.find(params[:id])


    tagIds = @wall.tags.ids
    @tagCount = Tag.wallpapers_count(tagIds)
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


      if (not urlQuery[:tags][:related].blank?) or (not urlQuery[:tags][:exclude].blank?)

        includeTagIds = []
        excludeTagIds = []

        tagQuery = 'name IN (?) OR EXISTS (SELECT 1 FROM tags alias WHERE tags.alias_of_id = alias.id AND alias.name IN (?)) OR EXISTS (SELECT 1 FROM tags alias WHERE alias.alias_of_id = tags.id AND alias.name IN (?))'

        if not urlQuery[:tags][:related].blank?
          #includeTagQuery = 'name IN (?) OR EXISTS (SELECT 1 FROM tags alias WHERE tags.alias_of_id = alias.id AND alias.name IN (?)) OR EXISTS (SELECT 1 FROM tags alias WHERE alias.alias_of_id = tags.id AND alias.name IN (?))'
          includeTagIds = Tag.where(tagQuery, urlQuery[:tags][:related], urlQuery[:tags][:related], urlQuery[:tags][:related]).ids

          includeTagIds << 0 if includeTagIds.blank?
        end

        if not urlQuery[:tags][:exclude].blank?
          #excludeTagQuery = 'name NOT IN (?) AND NOT EXISTS (SELECT 1 FROM tags alias where alias.alias_of_id = tags.id AND alias.name IN (?)) AND NOT EXISTS (SELECT 1 FROM tags alias where tags.alias_of_id = alias.id AND alias.name IN (?))'
          excludeTagIds =  Tag.where(tagQuery, urlQuery[:tags][:exclude], urlQuery[:tags][:exclude], urlQuery[:tags][:exclude]).ids

          excludeTagIds << 0 if excludeTagIds.blank?
        end

        if not includeTagIds.blank?
          joinQuery << 'INNER JOIN tags_wallpapers ON wallpaper_id = wallpapers.id'
          sqlQuery << 'tag_id IN (:qIncTagIds)'
          qParams[:qIncTagIds] = includeTagIds
        end

        if not excludeTagIds.blank?
          sqlQuery << 'not exists (select 1 from tags_wallpapers tw2 where tw2.wallpaper_id = wallpapers.id and tag_id in (:qExcTagIds))'
          qParams[:qExcTagIds] = excludeTagIds
        end

      end


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
        @limit = urlQuery[:limit]
      end

      @walls = Wallpaper.all.limit(@limit).offset( (page-1) * @limit )
    end

    if request.xhr?
      render jbuilder: @walls;
      return
    end
  end

  def tag_search
    term = params[:term]
    @tags = Tag.where('name LIKE ?', "#{term}%").order(:name).pluck(:name)
  end

  def untagged
    @walls = Wallpaper.where('NOT EXISTS (SELECT 1 FROM tags_wallpapers WHERE wallpaper_id = wallpapers.id)', {}).limit(12)
  end
end
