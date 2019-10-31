module Slugable
  extend ActiveSupport::Concern

  included do

    before_save :set_slug

    def set_slug
      unless self.slug.present?
        self.slug = self.title.parameterize
      end
    end
  end
end
