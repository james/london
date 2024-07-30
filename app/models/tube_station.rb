class TubeStation < ApplicationRecord
  def self.find_nearest(latitude, longitude)
    point = Arel.sql("ST_GeomFromText('POINT(#{longitude.to_f} #{latitude.to_f})')")
    TubeStation.order(Arel.sql("ST_Distance(lonlat, ?)", point)).first
  end

  def distance_from(latitude, longitude)
    point = Arel.sql("ST_GeomFromText('POINT(#{longitude.to_f} #{latitude.to_f})', 4326)")
    distance = TubeStation.select(Arel.sql("ST_Distance(lonlat, #{point}) AS distance")).where(id: self.id).take
    distance.distance.to_i
  end
end
