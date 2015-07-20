module Admin::WallpapersHelper

  def print_bool(bool)

    if bool
      raw('<span style="color: green">yes</span>')
    else
      raw('<span style="color: red">no</span>')
    end

  end

end
