class ParseDeckListService
  def self.from_image(image_path)
    require "google/cloud/vision"

    image_annotator = Google::Cloud::Vision::ImageAnnotator.new

    response = image_annotator.text_detection(
      image: File.open(image_path),
      max_results: 1 # optional, defaults to 10
    )

    result = []
    response.responses.each do |res|
      result = res.text_annotations.collect do |text|
        text.description
      end
    end
    ParseDeckListService.from_string(result[0])
  end


  def self.from_string(ar)
    list = ar.split("\n")
    matches = {}

    list.each do |card|
      m = card.match(/(\d+)/)
      if m.present? && m.size > 0
        if m[1].to_i > 0
          c = Expansion.find(1).cards.no_mavericks.find_by(number: m[1].to_i)
          if c.present?
            key = c.house_id
            matches[key] ||= []
            matches[key] << c.id
          else
            puts "Could not find card with number: #{m[1]}"
          end
        end
      end
    end

    matches.each do |m|
      puts m[1].length.inspect
    end

    return matches, ar
  end
end
