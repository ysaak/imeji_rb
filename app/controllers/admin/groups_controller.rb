class Admin::GroupsController < ApplicationController
  def index
    all_groups = Group.all.order('parent_id IS NOT NULL, name')

    @groups = {}

    all_groups.each do |group|

      if group.parent_id.nil?

        @groups[group.id] = {
            :group => group,
            :children => []
        }
      else
        @groups[group.parent_id][:children] << group
      end
    end
  end

  def new
    @group = Group.new
    @group_array = Group.where(:parent_id => nil).order(:name)
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      redirect_to admin_groups_path
    else
      render 'new'
    end
  end

  def edit
    @group = Group.find(params[:id])
    @group_array = Group.where(:parent_id => nil).order(:name)
  end

  def update
    @group = Group.find(params[:id])

    if @group.update(group_params)
      redirect_to admin_groups_path
    else
      render 'edit'
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    redirect_to admin_groups_path
  end

  private
    def group_params
      params.require(:group).permit(:name, :parent_id)
    end
end
