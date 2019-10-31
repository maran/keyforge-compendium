require 'net/http'

class ScrapeDecksWorker
  include Sidekiq::Worker

  def perform()
    # Competitive scrape
#    decks = Net::HTTP.get(URI("https://www.keyforgegame.com/api/decks/?wins=1,100"))
#    max_decks = JSON.parse(decks)["count"].to_i
#    page_size = 20
#    start_page= 1
#    end_page = (max_decks.to_f / page_size).ceil
#    (start_page..end_page).each do |page|
#       RefreshCompetitiveDeckWorker.perform_async(page, page_size)
#    end

    # Normal scrape
    decks = Net::HTTP.get(URI("https://www.keyforgegame.com/api/decks/"))
    max_decks = JSON.parse(decks)["count"].to_i
    page_size = 20
    start_page= 1
    setting = Setting.find_or_initialize_by(name: "scraping_deck_page")
    if setting.new_record?
      setting.value = start_page
      setting.save
    end

    start_page= setting.value.to_i
    end_page = (max_decks / page_size)
    Rails.logger.info "Importing decks from page #{start_page} to page #{end_page} (#{end_page} - #{start_page} pages)"
    (start_page..end_page).each do |page|
      ImportDeckWorker.perform_async(page, page_size)
    end
  end
end
