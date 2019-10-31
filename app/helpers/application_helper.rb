module ApplicationHelper

  def alert_helper(type)
    if type == "alert"
      return "warning"
    elsif type == "notice"
      return "success"
    else
      return type
    end
  end

  def edit_path(edit_link)
    link_to edit_link, class: "btn btn-secondary" do
      fa_icon "pencil"
    end
  end

  def delete_path(path, item_name)
    link_to path, method: :delete, class: "btn btn-danger", data: {confirm: "Are you sure you want to delete this #{item_name}?"} do 
      fa_icon "trash"
    end
  end
end
