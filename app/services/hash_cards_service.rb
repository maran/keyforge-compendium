class HashCardsService
  def self.run(card_uuids)
    Digest::SHA2.hexdigest(card_uuids.sort.join(":"))
  end
end
