class Dealer < ApplicationRecord
  scope :with_coordinates, -> {
    where(%Q(longitude IS NOT NULL AND latitude IS NOT NULL))
  }
  scope :without_coordinates, -> {
    where(%Q(longitude IS NULL OR latitude IS NULL))
  }
  scope :coordinates, -> (flag) {
    flag.to_i > 0 ? with_coordinates : without_coordinates
  }

  validates :salesforce_identifier, presence: true
  validates :name, presence: true

  def has_coordinates?
    longitude.present? && latitude.present?
  end
end
