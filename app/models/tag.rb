class Tag < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 3 }, uniqueness: true

  before_validation :parse_name

  has_and_belongs_to_many :wallpapers, -> { order('rand()') }

  has_many :aliases, class_name: 'Tag', foreign_key: 'alias_of_id'
  has_one :alias_of, class_name: 'Tag', foreign_key: 'id', primary_key: 'alias_of_id'
  has_one :background_wallpaper, class_name: 'Wallpaper', foreign_key: 'id', primary_key: 'wallpaper_id'


  has_many :implications, class_name: 'TagImplication'
  has_many :implied_tags, :through => :implications

  enum category: [:general, :copyright, :character, :artist, :circle]

  # Parse the name of the tag to extract cateogry if present
  def parse_name
    self.name.downcase.chomp! ':'

    if self.name.include? ':'
      parts = self.name.split(':')

      if %w(copyright character artist circle).include? parts[0]
        self.category = parts[0].to_sym
      end

      self.name = parts[1]
    end
  end

  def update_wallpapers_count
    nb_wallpapers = Tag.joins(:wallpapers).where(:id =>  self.id).count
    self.wallpapers_count = nb_wallpapers || 0
    self.save
  end

  def self.list_ids_by_names(names)
    Tag.where(LIST_IDS_BY_NAME_QUERY, names, names, names).ids
  end

  def self.contains_word(word)
    where('name LIKE :word', {:word => "%#{word}%"}).order(:name)
  end

  def self.list_with_implied(names)
    return [] if names.blank?

    tags = where :name => names
    res = []

    tags.each do |tag|
      res << tag
      res.concat list_implied_tags(tag)
    end

    res
  end

  private
    LIST_IDS_BY_NAME_QUERY = 'name IN (?) OR EXISTS (SELECT 1 FROM tags alias WHERE tags.alias_of_id = alias.id AND alias.name IN (?)) OR EXISTS (SELECT 1 FROM tags alias WHERE alias.alias_of_id = tags.id AND alias.name IN (?))'

    def self.list_implied_tags(tag)
      return [] if tag.blank? or tag.implied_tags.blank?

      res = []

      tag.implied_tags.each do |tag|
        res << tag
        res.concat list_implied_tags(tag)
      end

      res
    end
end
