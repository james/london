module LondonPoint
  extend ActiveSupport::Concern

  class_methods do
    def find_nearest(latitude, longitude)
      point = Arel.sql("ST_GeomFromText('POINT(#{longitude.to_f} #{latitude.to_f})', 4326)")
      order(Arel.sql("ST_Distance(lonlat, #{point})")).first
    end
  end

  def distance_from(latitude, longitude)
    point = Arel.sql("ST_GeomFromText('POINT(#{longitude.to_f} #{latitude.to_f})', 4326)")
    distance = self.class.select(Arel.sql("ST_Distance(lonlat, #{point}) AS distance")).where(id: self.id).take
    distance.distance.to_i
  end
end
