module FilterHelper
  def filterrific_value_for_card_amount(i, type)
    @filterrific.to_hash["with_card_count"][:"#{i}_#{type}"] rescue nil
  end

  def filterrific_value_for_adhd(i, type)
    @filterrific.to_hash["with_adhd"][:"#{i}_#{type}"] rescue nil
  end

  # This can probably be used for all other methods TODO
  def filterrific_value_for_all(key, second_key)
    HashWithIndifferentAccess.new(@filterrific.to_hash)[key][second_key] rescue nil
  end

  # Fallback for legacy urls
  def filterrific_value_for(i, type)
    if @filterrific.to_hash["with_cards"].present?
      @filterrific.to_hash["with_cards"][i][type] rescue nil
    elsif @filterrific.to_hash["with_card_ids"].present? # We do this for backwards compatitbility of older queries
      @filterrific.to_hash["with_card_ids"][i][type] rescue nil
    end
  end

  def has_filters(params)
    params.has_key?(:filterrific)
  end

  def card_times(filter)
    filters = filter.to_hash
    if filters.has_key?("with_card_ids")
      if filters["with_card_ids"].is_a?(Array)
        return filters["with_card_ids"].reject(&:blank?).length - 1
      elsif filters["with_card_ids"].is_a?(Hash) # This is a fallback for older URLs that ended up in google for the old search with cards format, this doesnt make it work sadly but at least it does not 500
        return filters["with_card_ids"].keys.length
      end
    end

    return 0
  end

  def search_result(filter, amount)
    result_string = "Found #{amount} decks"
    filters = HashWithIndifferentAccess.new(filter.to_hash)
    if filters.has_key?("with_deck_name")
      result_string += " with '#{filters['with_deck_name']}' in the name"
    end

    if filters.has_key?("by_house") && filters["by_house"].has_key?(:house_ids)
      houses = filters["by_house"][:house_ids].collect do |house_id|
        House.select("name").find(house_id).name
      end
      if houses.length > 1
        result_string += " for houses #{houses.join(' and ')}"
      else
        result_string += " for house #{houses[0]}"
      end
    end

    ["with_cards", "with_card_ids"].each do |typ|
      if filters.has_key?(typ)
        filters[typ].reject!{|x| x["card_title"].blank?}
        if filters[typ].length > 0
          result_string += " with "
          result_string += filters[typ].collect{|x| "#{x['card_count']} times the card '#{x['card_title']}'"}.join(' and ')
        end
      end
    end

    if filters.has_key?("with_favourites")
      result_string += " in your own decks"
    end

    return result_string
  end
end
