class Scorecard
  attr_accessor :latitude, :longitude, :scores

  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
    @scores = []

    areas.each do |area|
      scores << Score.new(name: area.name, description: area.area_type, points: area.score, geojson: area.geometry)
    end

    if distance_to_nearest_tube_station < 5000
      case nearest_tube_station.zone.to_i
      when 1
        scores << Score.new(name: nearest_tube_station.name, description: "Your nearest tube station is Zone 1", points: 50)
      when 2
        scores << Score.new(name: nearest_tube_station.name, description: "Your nearest tube station is Zone 1", points: 40)
      when 3
        scores << Score.new(name: nearest_tube_station.name, description: "Your nearest tube station is Zone 3", points: 30)
      when 4
        scores << Score.new(name: nearest_tube_station.name, description: "Your nearest tube station is Zone 4", points: 20)
      when 5
        scores << Score.new(name: nearest_tube_station.name, description: "Your nearest tube station is Zone 5", points: 10)
      when 6
        scores << Score.new(name: nearest_tube_station.name, description: "Your nearest tube station is Zone 6", points: 5)
      when 7
        scores << Score.new(name: nearest_tube_station.name, description: "Your nearest tube station is Zone 7", points: 4)
      when 8
        scores << Score.new(name: nearest_tube_station.name, description: "Your nearest tube station is Zone 8", points: 3)
      when 9
        scores << Score.new(name: nearest_tube_station.name, description: "Your nearest tube station is Zone 9", points: 2)
      when 10
        scores << Score.new(name: nearest_tube_station.name, description: "Your nearest tube station is Zone 10", points: 1)
      end
    end
  end

  def areas
    @areas ||= LondonArea.find_by_latitude_and_longitude(latitude, longitude)
  end

  def nearest_tube_station
    @nearest_tube_station ||= TubeStation.find_nearest(latitude, longitude)
  end

  def distance_to_nearest_tube_station
    @distance_to_nearest_tube_station ||= nearest_tube_station.distance_from(latitude, longitude)
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
