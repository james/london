class LondonArea < ApplicationRecord
  def self.find_by_latitude_and_longitude(latitude, longitude)
    LondonArea.where("ST_Contains(geometry::geometry, ST_SetSRID(ST_Point(?, ?), 4326))", longitude, latitude)
  end
end
