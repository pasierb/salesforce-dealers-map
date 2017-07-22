class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.filter(params = {})
    result = where(%Q(1 = 1))

    params.each do |key, value|
      if value.present?
        result = result.send(key, value)
      end
    end if params.present?

    result
  end
end
