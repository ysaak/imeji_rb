class Tag < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 3 }, uniqueness: true

  before_validation :parse_name

  has_and_belongs_to_many :wallpapers, -> { order('rand()') }

  has_many :aliases, class_name: 'Tag', foreign_key: 'alias_of_id'
  has_one :alias_of, class_name: 'Tag', foreign_key: 'id', primary_key: 'alias_of_id'
  has_one :background_wallpaper, class_name: 'Wallpaper', foreign_key: 'id', primary_key: 'wallpaper_id'


  has_many :implications, class_name: 'TagImplication'
  has_many :implied_tags, :through => :implications

  has_many :implied_by, class_name: 'TagImplication', foreign_key: 'implied_tag_id'

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

  def update_implied_tags(new_tags_names, tags_names_to_remove)
    # Adding new tag
    if new_tags_names.present?
      new_tags_list = Tag.where :name => new_tags_names.map{|name| name.downcase}

      new_tags_list.each do |tag|
        self.implied_tags << tag unless self.implied_tags.include? tag and (tag.imply? self or tag.implication_of? self)
      end
    end

    # Removing tags
    if tags_names_to_remove.present?
      tags_to_remove = Tag.where :name => tags_names_to_remove.map{|name| name.downcase}

      tags_to_remove.each do |tag|
        self.implied_tags.delete tag
      end
    end
  end

  def imply?(tag)
    self.implied_tags.each do |i_tag|
      return true if i_tag.id == tag.id or i_tag.imply? tag
    end

    false
  end

  def implication_of?(tag)
    self.implied_by.each do |tag_impl|
      return true if tag_impl.tag.id == tag.id or tag_impl.tag.implication_of? tag
    end

    false
  end

  def self.list_ids_by_names(names)
    Tag.where(LIST_IDS_BY_NAME_QUERY, names, names, names).ids
  end

  def self.contains_word(word)
    where('name LIKE :word', :word => "%#{word}%").order(:name)
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

    return [] if tag.blank? or (not tag.instance_of?(Tag)) or tag.implied_tags.blank?

    res = []

    tag.implied_tags.each do |tag|
      res << tag
      res.concat list_implied_tags(tag)
    end

    res
  end
end
