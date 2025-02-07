class Scorecard
  attr_accessor :latitude, :longitude, :scores

  def self.max_score
    self.new(51.501009, -0.141588).total_points
  end

  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
    @scores = []

    areas.each do |area|
      scores << Score.new(name: area.name, template: area.area_type, points: area.score, geojson: RGeo::GeoJSON.encode(area.geometry).to_json)
    end

    if distance_to_nearest_tube_station < 5000
      case nearest_tube_station.zone.to_i
      when 1
        scores << Score.new(template: 'nearest_tube', name: nearest_tube_station.name, zone: nearest_tube_station.zone.to_i, geo_point: nearest_tube_station.lonlat, points: 50)
      when 2
        scores << Score.new(template: 'nearest_tube', name: nearest_tube_station.name, zone: nearest_tube_station.zone.to_i, geo_point: nearest_tube_station.lonlat, points: 40)
      when 3
        scores << Score.new(template: 'nearest_tube', name: nearest_tube_station.name, zone: nearest_tube_station.zone.to_i, geo_point: nearest_tube_station.lonlat, points: 30)
      when 4
        scores << Score.new(template: 'nearest_tube', name: nearest_tube_station.name, zone: nearest_tube_station.zone.to_i, geo_point: nearest_tube_station.lonlat, points: 20)
      when 5
        scores << Score.new(template: 'nearest_tube', name: nearest_tube_station.name, zone: nearest_tube_station.zone.to_i, geo_point: nearest_tube_station.lonlat, points: 10)
      when 6
        scores << Score.new(template: 'nearest_tube', name: nearest_tube_station.name, zone: nearest_tube_station.zone.to_i, geo_point: nearest_tube_station.lonlat, points: 5)
      when 7
        scores << Score.new(template: 'nearest_tube', name: nearest_tube_station.name, zone: nearest_tube_station.zone.to_i, geo_point: nearest_tube_station.lonlat, points: 4)
      when 8
        scores << Score.new(template: 'nearest_tube', name: nearest_tube_station.name, zone: nearest_tube_station.zone.to_i, geo_point: nearest_tube_station.lonlat, points: 3)
      when 9
        scores << Score.new(template: 'nearest_tube', name: nearest_tube_station.name, zone: nearest_tube_station.zone.to_i, geo_point: nearest_tube_station.lonlat, points: 2)
      when 10
        scores << Score.new(template: 'nearest_tube', name: nearest_tube_station.name, zone: nearest_tube_station.zone.to_i, geo_point: nearest_tube_station.lonlat, points: 1)
      end
    end

    if distance_to_nearest_night_tube_station < 2500
      scores << Score.new(template: 'night_tube', name: nearest_night_tube_station.name, geo_point: nearest_night_tube_station.lonlat, points: 20)
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

  def nearest_night_tube_station
    @nearest_night_tube_station ||= TubeStation.night_stations.find_nearest(latitude, longitude)
  end

  def distance_to_nearest_night_tube_station
    @distance_to_nearest_night_tube_station ||= nearest_night_tube_station.distance_from(latitude, longitude)
  end

  def total_points
    scores.collect(&:points).sum
  end

  def percentage_of_max_score
    ((total_points.to_f / self.class.max_score.to_f) * 100).round
  end
end

class Score
  attr_accessor :name, :template, :points, :geojson, :zone, :geo_point
  def initialize(args = {})
    @name = args[:name]
    @template = args[:template]
    @points = args[:points]
    @geojson = args[:geojson]
    @zone = args[:zone]
    @geo_point = args[:geo_point]
  end
end
