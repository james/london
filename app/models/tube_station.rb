class TubeStation < ApplicationRecord
  scope :night_stations, -> { where(night: true) }

  include LondonPoint
end
