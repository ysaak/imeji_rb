class TagImplication < ActiveRecord::Base
  belongs_to :tag
  belongs_to :implied_tag, class_name: 'Tag', foreign_key: 'implied_tag_id'
end
