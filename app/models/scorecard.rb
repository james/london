class Scorecard
  attr_accessor :latitude, :longitude, :scores

  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
    @scores = []

    areas.each do |area|
      scores << Score.new(name: area.name, description: area.area_type, points: area.score, geojson: area.geometry)
    end

  def areas
    @areas ||= LondonArea.find_by_latitude_and_longitude(latitude, longitude)
  end

  def nearest_tube_station
    @nearest_tube_station ||= TubeStation.find_nearest(latitude, longitude)
  end

  def total_points
    scores.collect(&:points).sum
  end
end

class Score
  attr_accessor :name, :description, :points, :geojson
  def initialize(args = {})
    @name = args[:name]
    @description = args[:description]
    @points = args[:points]
    @geojson = args[:geojson]
  end
end
