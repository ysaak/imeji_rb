class TagsController < ApplicationController
  def index
    @groups = Group.list_roots

    @root_group = nil
    @sub_group = nil

    @sub_groups = []
    gid = nil

    if params.has_key? :gid

      gid = params[:gid].to_i

      @root_group = Group.find gid
      if not @root_group.parent_id.nil?
        @sub_group = @root_group
        @root_group = @root_group.parent
      end

      @sub_groups = Group.where(:parent_id => @root_group.id).order(:name)
    end

    if gid.nil?
      @tags = Tag.all.order(:name)
    else
      @tags = Tag.where(:group_id => gid).order(:name)
    end
  end

  def show
    @tag = Tag.find_by! :id => params[:id]

    if @tag.alias_of_id != nil
      @tag = @tag.alias_of
    end

    @wallpapers = @tag.wallpapers.take 20

    @background_wallpaper = @tag.background_wallpaper
  end

  def search
    term = params[:term]
    @tags = Tag.where('name LIKE ?', "#{term}%").order(:name).pluck(:name)
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)

    if @tag.save
      redirect_to @tag
    else
      render 'new'
    end
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])

    if @tag.update(tag_params)
      redirect_to @tag
    else
      render 'edit'
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy

    redirect_to tags_path
  end

  private

    def tag_params
      params.require(:tag).permit(:name, :type, :wallpaper_id, :bg_x, :bg_y)
    end
end
