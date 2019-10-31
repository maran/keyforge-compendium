# Set the host name for URL creation
require 'fog'
SitemapGenerator::Sitemap.default_host = "https://keyforge-compendium.com"
SitemapGenerator::Sitemap.adapter = SitemapGenerator::FogAdapter.new(fog_directory: "kfc_deckimage_uploads",fog_credentials: {provider: "Google", google_storage_access_key_id: "GOOGUUQETVCMWXGMMONNYVRH", google_storage_secret_access_key: Rails.application.credentials.dig(:google_storage, :api_secret)})
SitemapGenerator::Sitemap.sitemaps_host = "https://storage.googleapis.com/kfc_deckimage_uploads/sitemap.xml.gz"
SitemapGenerator::Sitemap.create do
  Card.no_mavericks.find_each do |card|
    add card_path(card.slug), lastmod: card.created_at
  end

  add decks_path
  add stats_path
  add faqs_path
end
