class Tag < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 3 }, uniqueness: true

  has_and_belongs_to_many :wallpapers, -> { order('rand()') }

  belongs_to :group

  has_many :aliases, class_name: 'Tag', foreign_key: 'alias_of_id'
  has_one :alias_of, class_name: 'Tag', foreign_key: 'id', primary_key: 'alias_of_id'
  has_one :background_wallpaper, class_name: 'Wallpaper', foreign_key: 'id', primary_key: 'wallpaper_id'

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

  private
    LIST_IDS_BY_NAME_QUERY = 'name IN (?) OR EXISTS (SELECT 1 FROM tags alias WHERE tags.alias_of_id = alias.id AND alias.name IN (?)) OR EXISTS (SELECT 1 FROM tags alias WHERE alias.alias_of_id = tags.id AND alias.name IN (?))'
end
