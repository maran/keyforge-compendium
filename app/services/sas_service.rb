class SasService
  def self.run(deck_id)
    url = URI("https://decksofkeyforge.com/public-api/v3/decks/#{deck_id}")
    begin
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      req = Net::HTTP::Get.new(url)
      req["Api-Key"] = Rails.application.credentials.dof[:api_secret]
      res = http.request(req)

      sas = JSON.parse(res.body)
      if sas["status"].present? && sas["status"] == 400
        return {}
      else
        return sas['deck']
      end
    rescue JSON::ParserError => e
      puts "Error: #{e}"

      return {}
    end
  end
end
