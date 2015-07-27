class QueryParser
  METATAGS = 'md5|-rating|rating|width|height|ratio|order|limit|ext|-ext|color'

  def parse_query(query)

    q = {}
    q[:tag_count] = 0

    q[:tags] = {
        :related => [],
        :include => [],
        :exclude => []
    }

    if query.nil?
      return q
    end

    scan_query(query).each do |part|

      q[:tag_count] += 1 unless part =~ /\Alimit:.+\Z/

      if part =~ /\A(#{METATAGS}):(.+)\Z/i

        case $1.downcase
          when 'md5'
            q[:md5] = $2.downcase.split(/,/)

          when '-rating'
            q[:rating_negated] = $2.upcase

          when 'rating'
            q[:rating] = $2.upcase

          when 'width'
            q[:width] = parse_helper($2)

          when 'height'
            q[:height] = parse_helper($2)

          when 'ratio'
            q[:ratio] = parse_helper($2, :ratio)

          when 'order'
            q[:order] = $2.downcase

          when 'limit'
            q[:limit] = $2.to_i

          when 'ext'
            q[:ext] = $2.downcase

          when '-ext'
            q[:ext_negated] = $2.downcase

          when 'color'
            q[:color] = parse_cast($2, :color)
        end
      else
        parse_tag(part, q[:tags])
      end

    end

    q
  end

  private

  def scan_query(query)
    return query.to_s.downcase.gsub(/\s+/m, ' ').gsub(/^\s+|\s+$/m, '').split(' ')
  end

  def parse_cast(object, type)
    case type
      when :integer
        object.to_i

      when :float
        object.to_f

      when :ratio
        object =~ /\A(\d+(?:\.\d+)?):(\d+(?:\.\d+)?)\Z/i

        if $1 && $2.to_f != 0.0
          ($1.to_f / $2.to_f).round(2)
        else
          object.to_f.round(2)
        end

      when :color
        color = object.to_s

        if color[0] == '#'
          color = color[1..-1]
        end

        if color.length == 3
          [
              (color[0]*2).hex.to_s,
              (color[1]*2).hex.to_s,
              (color[2]*2).hex.to_s
          ]
        else
          [
              (color[0..1]).hex.to_s,
              (color[2..3]).hex.to_s,
              (color[4..5]).hex.to_s
          ]
        end

    end
  end

  def parse_helper(range, type = :integer)
    # "1", "0.5", "5.", ".5":
    # (-?(\d+(\.\d*)?|\d*\.\d+))
    case range
      #when /\A(.+?)\.\.(.+)/
      #  return [:between, parse_cast($1, type), parse_cast($2, type)]

      when /\A<=(.+)/, /\A\.\.(.+)/
        return [:lte, parse_cast($1, type)]

      when /\A<(.+)/
        return [:lt, parse_cast($1, type)]

      when /\A>=(.+)/, /\A(.+)\.\.\Z/
        return [:gte, parse_cast($1, type)]

      when /\A>(.+)/
        return [:gt, parse_cast($1, type)]

      #when /,/
      #  return [:in, range.split(/,/).map {|x| parse_cast(x, type)}]

      else
        return [:eq, parse_cast(range, type)]

    end
  end

  def parse_tag(tag, output)
    if tag[0] == "-" && tag.size > 1
      output[:exclude] << tag[1..-1].mb_chars.downcase

    elsif tag[0] == "~" && tag.size > 1
      output[:include] << tag[1..-1].mb_chars.downcase


#    elsif tag =~ /\*/
#      matches = Tag.name_matches(tag.downcase).select("name").limit(Danbooru.config.tag_query_limit).order("post_count DESC").map(&:name)
#      matches = ["~no_matches~"] if matches.empty?
#     output[:include] += matches

    else
      output[:related] << tag.mb_chars.downcase
    end
  end
end