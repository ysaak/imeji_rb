class TagsController < ApplicationController
  def show

    code = params[:code]
    if code.to_s.match(/^\d+$/).nil?
      @tag = Tag.find_by_name! code

      if @tag.alias_of_id != nil
        @tag = @tag.alias_of
      end
    else
      @tag = Tag.find_by! :id => code.to_i
    end

    @wallpapers_count = @tag.wallpapers.size
    @wallpapers = @tag.wallpapers.take 12

    @background_wallpaper = @tag.background_wallpaper
  end

  def search
    term = params[:term]
    @tags = Tag.where('name LIKE ?', "#{term}%").order(:name).pluck(:name)
  end
end
