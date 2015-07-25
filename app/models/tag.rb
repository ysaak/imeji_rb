class Tag < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 3 }, uniqueness: true

  has_and_belongs_to_many :wallpapers, -> { order('rand()') }

  belongs_to :group

  has_many :aliases, class_name: 'Tag', foreign_key: 'alias_of_id'
  has_one :alias_of, class_name: 'Tag', foreign_key: 'id', primary_key: 'alias_of_id'
  has_one :background_wallpaper, class_name: 'Wallpaper', foreign_key: 'id', primary_key: 'wallpaper_id'

  def self.wallpapers_count(tagsIds)

    if tagsIds.blank?
      return {}
    end

    query = 'SELECT tag_id, COUNT(1) res FROM tags_wallpapers WHERE tag_id IN (' + tagsIds.join(',') + ') GROUP BY tag_id'
    res = self.connection.select_all(query)

    countData = {}

    res.each do |r|
      countData[r['tag_id']] = r['res']
    end

    return countData

  end

  def self.list_ids_by_names(names)
    Tag.where(LIST_IDS_BY_NAME_QUERY, names, names, names).ids
  end

  def self.contains_word(word)
    where('name LIKE :word', {:word => "%#{word}%"}).order(:name)
  end

  private
    LIST_IDS_BY_NAME_QUERY = 'name IN (?) OR EXISTS (SELECT 1 FROM tags alias WHERE tags.alias_of_id = alias.id AND alias.name IN (?)) OR EXISTS (SELECT 1 FROM tags alias WHERE alias.alias_of_id = tags.id AND alias.name IN (?))'
end
