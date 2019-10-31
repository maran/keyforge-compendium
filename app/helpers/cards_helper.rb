module CardsHelper
  def card_image_link(c, options = {})
    link_to image_tag("placeholder.png", options.reverse_merge(class: 'lazyload', 'data-src': c.front_image )), set_card_path(c.expansion.slug,c.slug)
  end

  def card_link(c)
    link_to c.title, set_card_path(c.expansion.slug,c.slug)
  end

  def prettify_text(text)
    text.gsub("<A>", image_tag("aember.png")).gsub("<D>", image_tag("damage.png"))
  end

  def rarity_icon(card)
    if card.is_a?(String)
      img = image_tag("rarity-#{card.downcase}.png", alt: card.downcase, title: card.downcase, size: 20)
    else
      img = image_tag("rarity-#{card.rarity.downcase}.png", alt: card.rarity, title: card.rarity, size: 20)

      if card.is_maverick?
        img = img + image_tag("rarity-maverick.png", alt: card.rarity, title: card.rarity, size: 20)
      end
    end

    return img
  end

  def rarity_and_icon(card)
    [rarity_icon(card), card.rarity].join(" ")
  end
end
