module DecksHelper
  def fav_deck_url(user)
    if user.username.present?
      user_decks_url(user.username)
    else
      user_decks_url(user.id)
    end
  end

  def card_list_item_class(c)
    case c.card_type
    when "Creature"
      return "item-creature"
    when "Action"
      return "item-action"
    when "Artifact"
      return "item-artifact"
    when "Upgrade"
      return "item-upgrade"
    end
  end

  def should_show_tag(t)
    return false if t.hide_by_default?
    return false if t.virtual_count < 3
    return true
  end

  def compare_class(val,other_val)
    if val > other_val
      return "bg-success"
    elsif val < other_val
      return "bg-danger"
    end
  end

  def fav_class(deck)
    current_user.deck_ids.include?(@deck.id) ? "active" : ""
  end

  def rating_makeup(rating)
    if rating > 0
      "<span class='text-success'>+#{rating}</span>"
    else
      "<span class='text-danger'>#{rating}</span>"
    end
  end

  def display_house_icons(deck)
    deck.houses.collect do |house|
      display_house_icon(house)
    end.join(" ")
  end

  def display_house_icon_from_name(house_name)
    #display_house_icon(House.find_by(name: house_name))
    image_tag("#{house_name.downcase}.png", alt:house_name, title: house_name, size: 25)
  end

  def display_house_icon(house)
    image_tag(house.icon_url, alt: house.name, title: house.name, size: 25)
  end

  def card_count_table(deck,card)
    count = deck.card_count(card) || 0
    if count > 0
      return count
    end
  end
  def card_count(deck,card)
    count = deck.card_count(card) || 0
    if count > 1
      return "#{count}x "
    end
  end

  def selected_house(form,house_id)
    params = form.object.to_hash
    if params.has_key?("by_house") && params["by_house"].has_key?(:house_ids)
      house_ids = params["by_house"][:house_ids]
      if house_ids.is_a?(Array)
        house_ids.include?(house_id.to_s)
      else
        house_id.to_s == house_ids.to_s
      end
    else
      return false
    end
  end

  def show_amber(c)
    if c > 0
      c.times.collect do
        image_tag("aember.png")
      end.join("")
    end
  end

  def should_show_mav(params)
    params[:show_mavericks].present? && params[:show_mavericks] == "true"
  end
end
