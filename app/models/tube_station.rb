class TubeStation < ApplicationRecord
  def self.find_nearest(latitude, longitude)
    point = Arel.sql("ST_GeomFromText('POINT(#{longitude.to_f} #{latitude.to_f})')")
    TubeStation.order(Arel.sql("ST_Distance(lonlat, ?)", point)).first
  end
end
