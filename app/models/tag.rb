class Tag < ActiveRecord::Base
  self.inheritance_column = 'zoink'

  validates :name, presence: true, length: { minimum: 3 }, uniqueness: true

  has_and_belongs_to_many :wallpapers, -> { order('rand()') }

  has_many :aliases, class_name: 'Tag', foreign_key: 'alias_of_id'
  has_one :alias_of, class_name: 'Tag', foreign_key: 'id', primary_key: 'alias_of_id'

  has_one :background_wallpaper, class_name: 'Wallpaper', foreign_key: 'id', primary_key: 'wallpaper_id'

  enum type: [:general, :character, :title]

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
end
